; ChangeBlockLTScaleCircleLine.lsp
(defun c:ChangeBlockLTScaleCircleLine (/ ss index blk ent blk_def blk_ent blk_ent_data)
  (setq ss (ssget '((0 . "INSERT")))) ; Выбор только блоков
  (if ss
    (progn
      (setq index 0)
      (repeat (sslength ss)
        (setq blk (ssname ss index)) ; Получаем блок
        (setq blk_def (tblsearch "BLOCK" (cdr (assoc 2 (entget blk))))) ; Ищем определение блока
        (if blk_def
          (progn
            (setq blk_ent (tblobjname "BLOCK" (cdr (assoc 2 blk_def)))) ; Получаем первую сущность в блоке
            (while blk_ent
              (setq blk_ent_data (entget blk_ent)) ; Получаем данные сущности
              (cond
                ; Если это окружность (CIRCLE)
                ((= (cdr (assoc 0 blk_ent_data)) "CIRCLE")
                  (if (assoc 48 blk_ent_data) ; Проверяем наличие масштаба типа линии
                    (setq blk_ent_data (subst '(48 . 0.0) (assoc 48 blk_ent_data) blk_ent_data)) ; Меняем масштаб на 0
                    (setq blk_ent_data (append blk_ent_data (list '(48 . 0.0)))) ; Добавляем масштаб, если его нет
                  )
                )
                ; Если это линия (LINE) или полилиния (LWPOLYLINE)
                ((or (= (cdr (assoc 0 blk_ent_data)) "LINE")
                     (= (cdr (assoc 0 blk_ent_data)) "LWPOLYLINE"))
                  (if (assoc 48 blk_ent_data) ; Проверяем наличие масштаба типа линии
                    (setq blk_ent_data (subst '(48 . 1.0) (assoc 48 blk_ent_data) blk_ent_data)) ; Меняем масштаб на 0.5
                    (setq blk_ent_data (append blk_ent_data (list '(48 . 1.0)))) ; Добавляем масштаб, если его нет
                  )
                )
              )
              (entmod blk_ent_data) ; Применяем изменения
              (setq blk_ent (entnext blk_ent)) ; Переходим к следующей сущности в блоке
            )
          )
        )
        (setq index (1+ index))
      )
      (princ "\nМасштаб типа линии изменен: окружности = 0, линии и полилинии = 0.5.")
    )
    (princ "\nБлоки не выбраны.")
  )
  (command "_.REGEN") ; Регенерация чертежа
  (princ)
)


; макрос для AutoCAD который будет запускаться при нажатии кнопки. Открывать по очереди выделенные блоки. Внутри каждого блока применять окружностям масштаб типа линии = 0, к линиям и полилиниям применять масштаб типа линии = 0.5

;1. Создайте LISP-скрипт
;Сохраните следующий код в файле с расширением .lsp (например, ChangeBlockLTScaleCircleLine.lsp):

;2. Настройте кнопку в AutoCAD
;    Откройте CUI (через команду CUI).
;    Создайте новую команду:
;        В разделе Customize выберите вашу панель.
;        Нажмите New Command.
;    Укажите параметры:
;        Name: Изменить масштаб типа линии в блоках.
;        Macro (вставьте строку):
;        Copy
;        ^C^C(if (not c:ChangeBlockLTScaleCircleLine)(load "ChangeBlockLTScaleCircleLine.lsp"));ChangeBlockLTScaleCircleLine
;        Убедитесь, что путь к ChangeBlockLTScaleCircleLine.lsp указан правильно (или поместите файл в папку поддержки AutoCAD (support)).
;    Перетащите новую команду на панель инструментов.

;3. Использование
;    1. Нажмите созданную кнопку.
;    2. Выделите блоки, которые хотите изменить.
;    3. Нажмите Enter — внутри каждого блока:
;        У окружностей масштаб типа линии будет изменён на 0.
;        У линий и полилиний масштаб типа линии будет изменён на 0.5.
;    4. Чертеж автоматически регенерируется.
;
;Примечания:
;    Масштаб типа линии задаётся свойством "48" в данных примитива.
;    Если у примитива не было явно заданного масштаба типа линии, он будет добавлен.
;    Макрос работает только с блоками (объектами типа INSERT).
;Теперь вы можете быстро изменять масштаб типа линии для окружностей, линий и полилиний внутри выбранных блоков! 🛠️