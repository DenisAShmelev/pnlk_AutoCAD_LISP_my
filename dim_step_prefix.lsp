(defun c:DimStepPrefix (/ stepVal ss i ent dimVal steps prefix)
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
        ;; Получаем значение размера (через DXF 42 для линейных размеров)
        (setq dimVal (cdr (assoc 42 (entget ent))))
        
        ;; Вычисляем количество шагов (целое число)
        (setq steps (fix (/ dimVal stepVal)))

        ;; Формируем префикс: "<кол-во>x<шаг>="
        (setq prefix (strcat (itoa steps) "x" (rtos stepVal 2 3) "="))

        ;; Получаем текущий префикс (DXF 3) и добавляем новый
        ;; Если префикса нет — просто ставим новый, если есть — добавляем перед ним
        (setq oldPrefix (cdr (assoc 3 (entget ent))))
        (if (or (null oldPrefix) (= oldPrefix ""))
          (setq newPrefix prefix)
          (setq newPrefix (strcat prefix oldPrefix))
        )

        ;; Обновляем размерный объект
        (entmod (subst (cons 3 newPrefix) (assoc 3 (entget ent)) (entget ent)))
      )
    )
    (setq i (1+ i))
  )

  (princ (strcat "\nОбработано " (itoa (sslength ss)) " размеров."))
  (princ)
)
