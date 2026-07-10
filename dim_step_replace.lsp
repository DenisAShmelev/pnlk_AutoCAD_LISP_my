(defun c:DimStepReplace (/ stepVal ss i ent dimVal steps newText)
  (vl-load-com)

  ;; Запрос у пользователя числового значения шага
  (setq stepVal (getreal "\nВведите значение шага: "))
  (if (or (null stepVal) (<= stepVal 0))
    (progn
      (princ "\nОшибка: значение шага должно быть положительным числом.")
      (princ)
      (exit)
    )
  )

  ;; Выбор объектов (размеров)
  (princ "\nВыберите размеры для обработки: ")
  (setq ss (ssget '((0 . "DIMENSION"))))
  (if (null ss)
    (progn
      (princ "\nНе выбрано ни одного размера.")
      (princ)
      (exit)
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
        
        ;; Вычисляем количество шагов (целое число, округление вниз)
        (setq steps (fix (/ dimVal stepVal)))

        ;; Формируем новый текст: <кол-во>x<шаг>=<>
        (setq newText (strcat (itoa steps) "x" (rtos stepVal 2 3) "=<>"))

        ;; Записываем новый текст в размер (DXF 1 — основной текст размера)
        (entmod (subst (cons 1 newText) (assoc 1 (entget ent)) (entget ent)))
      )
    )
    (setq i (1+ i))
  )

  (princ (strcat "\nОбработано " (itoa (sslength ss)) " размеров."))
  (princ)
)
