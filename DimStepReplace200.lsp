;; ^C^C(if (not c:DimStepReplace200)(load "DimStepReplace200.lsp"));DimStepReplace200

(defun c:DimStepReplace200 (/ ss i ent dimVal stepsStr stepVal newText)
  (vl-load-com)

  ;; Устанавливаем фиксированное значение шага
  (setq stepVal 200.0)

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

  (princ (strcat "\nОбработано " (itoa (sslength ss)) " размеров."))
  (princ)
)


;; Добавляем еще одну команду на кириллице
(defun c:РазмерШаг200 () ;;Название которое хотим вводить на кириллице
  (c:DimStepReplace200) ;; Какую функцию (обособленную часть программы) будет выполнять программа при вводе названия на кириллице.
)

;; Добавляем еще одну команду на кириллице
(defun c:РШ200 () ;;Название которое хотим вводить на кириллице
  (c:DimStepReplace200) ;; Какую функцию (обособленную часть программы) будет выполнять программа при вводе названия на кириллице.
)
