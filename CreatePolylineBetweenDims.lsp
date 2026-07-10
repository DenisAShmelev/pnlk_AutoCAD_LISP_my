(defun c:CreatePolylineBetweenDims2 (/ dim1 dim2 textPt1 textPt2 dir1 dir2 pline)
  ;; Функция для определения направления размера (горизонтальный или вертикальный)
  (defun get-dim-direction (dim / entData pt1 pt2)
    (setq entData (entget dim)) ; Получаем данные об объекте размера
    (setq pt1 (cdr (assoc 13 entData))) ; Первая точка размера
    (setq pt2 (cdr (assoc 14 entData))) ; Вторая точка размера

    ;; Определяем направление размера
    (if (= (car pt1) (car pt2))
      'vertical ; Вертикальный размер
      'horizontal ; Горизонтальный размер
    )
  )

  ;; Функция для получения координат точки текста размера
  (defun get-dim-text-point (dim / entData)
    (setq entData (entget dim)) ; Получаем данные об объекте размера
    (cdr (assoc 10 entData)) ; Точка текста размера (числовое значение)
  )

  ;; Запрашиваем у пользователя выделение двух размеров
  (setq dim1 (car (entsel "\nВыберите первый размер: ")))
  (setq dim2 (car (entsel "\nВыберите второй размер: ")))

  ;; Проверяем, что выбраны два объекта
  (if (and dim1 dim2)
    (progn
      ;; Получаем точки текста размеров
      (setq textPt1 (get-dim-text-point dim1))
      (setq textPt2 (get-dim-text-point dim2))

      ;; Определяем направление размеров
      (setq dir1 (get-dim-direction dim1))
      (setq dir2 (get-dim-direction dim2))

      ;; Создаем полилинию
      (cond
        ;; Оба размера горизонтальные
        ((and (eq dir1 'horizontal) (eq dir2 'horizontal))
         (command "_.PLINE"
                  textPt1 ; Начало полилинии
                  textPt2 ; Конец полилинии
                  ""
         )
        )

        ;; Оба размера вертикальные
        ((and (eq dir1 'vertical) (eq dir2 'vertical))
         (command "_.PLINE"
                  textPt1 ; Начало полилинии
                  textPt2 ; Конец полилинии
                  ""
         )
        )

        ;; Первый размер горизонтальный, второй вертикальный
        ((and (eq dir1 'horizontal) (eq dir2 'vertical))
         (command "_.PLINE"
                  textPt1 ; Начало полилинии
                  (list (car textPt1) (cadr textPt2)) ; Изгиб под прямым углом
                  textPt2 ; Конец полилинии
                  ""
         )
        )

        ;; Первый размер вертикальный, второй горизонтальный
        ((and (eq dir1 'vertical) (eq dir2 'horizontal))
         (command "_.PLINE"
                  textPt1 ; Начало полилинии
                  (list (car textPt2) (cadr textPt1)) ; Изгиб под прямым углом
                  textPt2 ; Конец полилинии
                  ""
         )
        )
      )
    )
    (princ "\nНеобходимо выбрать два размера.")
  )
  (princ)
)