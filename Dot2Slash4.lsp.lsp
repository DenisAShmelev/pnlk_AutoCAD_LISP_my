;; ^C^C(if (not c:Dot2Slash)(load "Dot2Slash3.lsp"));Dot2Slash

(defun c:ЗаменитьВОсяхТочкиНаДробь () (c:Dot2Slash))

(defun c:Dot2Slash ( / regex-replace-pattern process-string doc old-txt new-txt
                       set-width-factor)
  (vl-load-com)

  ;; --- Вспомогательная функция для замены по шаблону (без RegExp, вручную) ---
  ;; Замена применяется ТОЛЬКО если строка состоит ровно из 3 символов
  ;; и средний символ — точка (шаблон: X.Y, где X и Y — любые символы, кроме пробела).
  ;; Остальные строки возвращаются без изменений.
  (defun regex-replace-pattern (str / len char1 char2 char3)
    (setq len (strlen str))
    (if (and (= len 3)
             (= (substr str 2 1) ".")
             (/= (substr str 1 1) " ")
             (/= (substr str 3 1) " ")
             (/= (substr str 1 1) ".")
             (/= (substr str 3 1) ".")
        )
      ;; Ровно 3 символа, средний — точка, крайние — не пробелы и не точки
      (strcat (substr str 1 1) "/" (substr str 3 1))
      ;; Иначе — без изменений
      str
    )
  )

  ;; --- Функция обработки одной строки ---
  (defun process-string (str / new-str)
    (if (and str (/= str ""))
      (progn
        (setq new-str (regex-replace-pattern str))
        (if (/= new-str str)
          new-str ; Возвращаем измененную строку
          nil     ; Изменений нет
        )
      )
      nil
    )
  )

  ;; --- Установка коэффициента сжатия 0.7 для объекта TEXT ---
  ;; Применяется только к AcDbText (не MTEXT, не атрибуты).
  (defun set-width-factor (ent / res)
    (if (eq (vla-get-objectname ent) "AcDbText")
      (progn
        ;; Способ 1: через vlax-put-property (имя свойства строкой)
        (setq res (vl-catch-all-apply
                    'vlax-put-property
                    (list ent 'WidthFactor 0.7)
                  )
        )
        (if (vl-catch-all-error-p res)
          (progn
            ;; Способ 2: резервно — через entmod, DXF-код 41 (width factor)
            (setq res (vl-catch-all-apply
                        '(lambda (e)
                           (setq ed (entget e))
                           (if (assoc 41 ed)
                             (setq ed (subst (cons 41 0.7) (assoc 41 ed) ed))
                             (setq ed (append ed (list (cons 41 0.7))))
                           )
                           (entmod ed)
                         )
                        (list (vlax-vla-object->ename ent))
                      )
            )
            (if (vl-catch-all-error-p res)
              (princ (strcat "\n  ! Не удалось установить коэффициент сжатия: "
                             (vl-catch-all-error-message res)))
              (princ "\n  Коэффициент сжатия установлен: 0.7 (через entmod)")
            )
          )
          (princ "\n  Коэффициент сжатия установлен: 0.7")
        )
      )
    )
    ent
  )

  ;; --- Замена параметра "Axis name" у SPDSCONSTRUCTIONLINE через entmod ---
  ;; Ищет пару (301 . "Axis name") и заменяет следующий за ней (300 . "...")
  ;; на новое значение. Возвращает T, если замена выполнена, иначе nil.
  (defun replace-spds-axis-name (ent new-value / ed found result)
    (setq ed (entget ent '("*")))
    (setq found nil)
    (setq result nil)
    ;; Проходим по списку; как только встретили (301 . "Axis name"),
    ;; следующий элемент должен быть (300 . <значение>)
    (while (and ed (not found))
      (if (and (eq (caar ed) 301)
               (= (cdr (car ed)) "Axis name"))
        (progn
          (setq found T)
          ;; Следующий элемент списка — значение (300 . "...")
          (if (and (cdr ed) (eq (caadr ed) 300))
            (progn
              ;; Заменяем значение
              (setq ed (subst (cons 300 new-value) (cadr ed) ed))
              ;; Записываем обратно
              (if (entmod ed)
                (progn
                  (entupd ent)
                  (setq result T)
                )
                (setq result nil)
              )
            )
          )
        )
        (setq ed (cdr ed))
      )
    )
    result
  )

  ;; --- Обработка прокси-объектов СПДС с типом SPDSCONSTRUCTIONLINE ---
  ;; Заменяет параметр "Axis name" через entmod.
  ;; Коэффициент сжатия не применяется.
  (defun process-spds-proxy (ent / ed cur-val new-val pos found)
    (setq ed (entget ent '("*")))
    (setq found nil)
    (setq cur-val nil)
    ;; Ищем (301 . "Axis name") и берём следующий (300 . "...")
    (while (and ed (not found))
      (if (and (eq (caar ed) 301)
               (= (cdr (car ed)) "Axis name"))
        (progn
          (setq found T)
          (if (and (cdr ed) (eq (caadr ed) 300))
            (setq cur-val (cdr (cadr ed)))
          )
        )
        (setq ed (cdr ed))
      )
    )
    (if cur-val
      (progn
        (setq new-val (process-string cur-val))
        (if new-val
          (progn
            (if (replace-spds-axis-name ent new-val)
              (princ (strcat "\nОбновлено имя оси СПДС: " cur-val " -> " new-val))
              (princ (strcat "\n  ! Не удалось записать имя оси: " cur-val))
            )
          )
        )
      )
      (princ "\n  ! СПДС-объект: параметр \"Axis name\" не найден")
    )
    ent
  )

  (setq doc (vla-get-activedocument (vlax-get-acad-object)))

  ;; --- 1. Обработка TEXT и MTEXT в пространстве модели и листах ---
  (vlax-for layout (vla-get-layouts doc)
    (vlax-for ent (vla-get-block layout)
      (if (or (eq (vla-get-objectname ent) "AcDbText")
              (eq (vla-get-objectname ent) "AcDbMText"))
        (progn
          (setq old-txt (vla-get-textstring ent))
          (setq new-txt (process-string old-txt))
          (if new-txt
            (progn
              (vla-put-textstring ent new-txt)
              (princ (strcat "\nОбновлен текст: " old-txt " -> " new-txt))
              ;; Коэффициент сжатия — только для TEXT (AcDbText)
              (set-width-factor ent)
            )
          )
        )
      )
    )
  )

  ;; --- 2. Обработка блоков (включая вложенные) ---
  ;; Рекурсивная функция для обхода определений блоков
  (defun process-block-def (blk-def / )
    (vlax-for sub-ent blk-def
      (cond
        ;; Если это TEXT или MTEXT внутри блока
        ((or (eq (vla-get-objectname sub-ent) "AcDbText")
             (eq (vla-get-objectname sub-ent) "AcDbMText"))
         (progn
           (setq old-txt (vla-get-textstring sub-ent))
           (setq new-txt (process-string old-txt))
           (if new-txt
             (progn
               (vla-put-textstring sub-ent new-txt)
               (princ (strcat "\nОбновлен текст в блоке: " old-txt " -> " new-txt))
               ;; Коэффициент сжатия — только для TEXT (AcDbText)
               (set-width-factor sub-ent)
             )
           )
         )
        )
        ;; Если это вложенный блок (Block Reference) - идем вглубь
        ((eq (vla-get-objectname sub-ent) "AcDbBlockReference")
         (process-block-def (vla-item (vla-get-blocks doc) (vla-get-name sub-ent)))
        )
        ;; Если это атрибут (Attribute) в определении блока
        ((eq (vla-get-objectname sub-ent) "AcDbAttributeDefinition")
         (progn
           (setq old-txt (vla-get-textstring sub-ent))
           (setq new-txt (process-string old-txt))
           (if new-txt
             (progn
               (vla-put-textstring sub-ent new-txt)
               (princ (strcat "\nОбновлен атрибут (def): " old-txt " -> " new-txt))
             )
           )
         )
        )
      )
    )
  )

  ;; Запускаем обход всех блоков в документе
  (vlax-for blk (vla-get-blocks doc)
    ;; Пропускаем пространства модели и листов (они уже обработаны выше)
    (if (not (wcmatch (vla-get-name blk) "*Model_Space, *Paper_Space"))
      (process-block-def blk)
    )
  )

  ;; --- 3. Обработка атрибутов вставленных блоков (значения на чертеже) ---
  ;; Коэффициент сжатия здесь НЕ применяется — по условию только для TEXT.
  (vlax-for layout (vla-get-layouts doc)
    (vlax-for ent (vla-get-block layout)
      (if (eq (vla-get-objectname ent) "AcDbBlockReference")
        (if (eq (vla-get-hasattributes ent) :vlax-true)
          (foreach att (vlax-invoke ent 'GetAttributes)
            (setq old-txt (vla-get-textstring att))
            (setq new-txt (process-string old-txt))
            (if new-txt
              (progn
                (vla-put-textstring att new-txt)
                (princ (strcat "\nОбновлен атрибут вставки: " old-txt " -> " new-txt))
              )
            )
          )
        )
      )
    )
  )

  ;; --- 4. Обработка объектов СПДС SPDSCONSTRUCTIONLINE ---
  (princ "\n--- Поиск объектов СПДС (SPDSCONSTRUCTIONLINE) ---")
  (vlax-for layout (vla-get-layouts doc)
    (vlax-for ent (vla-get-block layout)
      (if (eq (vla-get-objectname ent) "mcsDbObjectConstructionLine")
        (process-spds-proxy (vlax-vla-object->ename ent))
      )
    )
  )

  ;; --- Регенерация всех видовых экранов (модель + листы) ---
  (vla-regen doc acAllViewports)

  (princ "\nГотово. Поиск и замена выполнены. Модель регенерирована.")
  (princ)
)