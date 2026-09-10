;; ^C^C(if (not c:DimStepReplace)(load "DimStepReplace.lsp"));DimStepReplace

;; Инициализация переменной для хранения последнего значения шага
(if (null *LastStepVal*)
  (setq *LastStepVal* 200.0) ; Значение по умолчанию при первом запуске
)

(defun c:DimStepReplace (/ ss i ent dimVal stepsStr stepVal newText promptStr)
  (vl-load-com)
  
  ;; Формируем строку запроса с последним значением или значением по умолчанию
  (setq promptStr (strcat "\nВведите длину шага <" (rtos *LastStepVal* 2 3) ">: "))
  
  ;; Запрашиваем у пользователя значение шага
  (setq stepVal (getreal promptStr))
  
  ;; Если пользователь нажал Enter, используем последнее значение
  (if (null stepVal)
    (setq stepVal *LastStepVal*)
  )
  
  ;; Проверяем, что шаг больше нуля
  (if (<= stepVal 0)
    (progn
      (princ "\nОшибка: шаг должен быть больше нуля.")
      (princ)
      (exit)
    )
  )
  
  ;; Сохраняем введенное значение как последнее использованное
  (setq *LastStepVal* stepVal)
  
  ;; Получаем уже выделенные объекты (если ничего не выделено — просим выбрать)
  (setq ss (ssget '((0 . "DIMENSION"))))
  (if (null ss)
    (progn
      (princ "\nНе найдено предварительно выделенных размеров. Выберите размеры для обработки: ")
      (setq ss (ssget '((0 . "DIMENSION"))))
      (if (null ss)
        (progn
          (princ "\nНе выбрано ни одного размера.")
          (princ)
          (exit)
        )
      )
    )
  )
  
  ;; Обработка каждого размера
  (setq i 0)
  (repeat (sslength ss)
    (setq ent (ssname ss i))
    (if (and ent (= "DIMENSION" (cdr (assoc 0 (entget ent)))))
      (progn
        ;; Получаем значение размера (DXF 42 — для линейных размеров)
        (setq dimVal (cdr (assoc 42 (entget ent))))
        ;; Защита от деления на ноль или некорректного значения
        (if (and dimVal (> dimVal 0))
          (progn
            ;; Вычисляем количество шагов как вещественное число (без округления)
            (setq steps (/ dimVal stepVal))
            ;; Формируем строку количества шагов: используем rtos, чтобы получить дробное значение
            (setq stepsStr (rtos steps 2 3))
            ;; Убираем лишние нули в конце, если число целое
            (setq stepsStr (vl-string-trim " " stepsStr))
            (if (wcmatch stepsStr "*.*000")
              (setq stepsStr (substr stepsStr 1 (- (strlen stepsStr) 3))) ; убираем ".000"
            )
            (while (or (wcmatch stepsStr "*.0") (wcmatch stepsStr "*."))
              (if (eq (substr stepsStr (strlen stepsStr) 1) ".")
                (setq stepsStr (substr stepsStr 1 (- (strlen stepsStr) 1)))
                (if (eq (substr stepsStr (strlen stepsStr) 1) "0")
                  (setq stepsStr (substr stepsStr 1 (- (strlen stepsStr) 1)))
                )
              )
            )
            ;; Заменяем точку на запятую для русского формата
            (setq stepsStr (vl-string-subst "," "." stepsStr))
            ;; Формируем новый текст: <кол-во>x<шаг>=<>
            (setq newText (strcat stepsStr "x" (rtos stepVal 2 3) "=<>"))
            ;; Записываем новый текст в размер
            (entmod (subst (cons 1 newText) (assoc 1 (entget ent)) (entget ent)))
          )
          (princ (strcat "\nПропущен размер без корректного значения (объект " (itoa i) ")."))
        )
      )
    )
    (setq i (1+ i))
  )
  (princ (strcat "\nОбработано " (itoa (sslength ss)) " размеров с шагом " (rtos stepVal 2 3) "."))
  (princ)
)

;; Добавляем еще одну команду на кириллице
(defun c:РазмерШаг ()
  (c:DimStepReplace)
)

;; Добавляем еще одну команду на кириллице
(defun c:РШ ()
  (c:DimStepReplace)
)