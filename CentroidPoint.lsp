(defun c:CentroidPoint (/ ent entData coords area cx cy totalArea)
  ;; Функция для вычисления центра тяжести многоугольника
  (defun calculate-centroid (coords / x y area cx cy i n)
    (setq n (length coords)
          area 0.0
          cx 0.0
          cy 0.0
          i 0)
    (while (< i n)
      (setq x1 (car (nth i coords))
            y1 (cadr (nth i coords))
            x2 (car (nth (if (< i (- n 1)) (+ i 1) 0) coords))
            y2 (cadr (nth (if (< i (- n 1)) (+ i 1) 0) coords))
            tempArea (* x1 y2 (- x2 y1))
            area (+ area tempArea)
            cx (+ cx (* (+ x1 x2) tempArea))
            cy (+ cy (* (+ y1 y2) tempArea))
            i (1+ i)))
    (setq area (/ area 2.0)
          cx (/ cx (* 6.0 area))
          cy (/ cy (* 6.0 area)))
    (list cx cy))

  ;; Выбор объекта
  (setq ent (car (entsel "\nВыберите замкнутый многоугольник (полилинию): ")))
  (if ent
    (progn
      (setq entData (entget ent))
      ;; Проверка, что объект является полилинией
      (if (= (cdr (assoc 0 entData)) "LWPOLYLINE")
        (progn
          ;; Получение координат вершин полилинии
          (setq coords (mapcar 'cdr (vl-remove-if-not '(lambda (x) (= (car x) 10)) entData)))
          ;; Проверка, что полилиния замкнута
          (if (equal (car coords) (last coords) 1e-8)
            (progn
              ;; Вычисление центра тяжести
              (setq centroid (calculate-centroid coords))
              ;; Рисование точки в центре тяжести
              (command "._POINT" (list (car centroid) (cadr centroid)))
              (princ (strcat "\nЦентр тяжести: X = " (rtos (car centroid)) ", Y = " (rtos (cadr centroid)))))
            (princ "\nПолилиния не замкнута."))
          )
        (princ "\nВыбранный объект не является полилинией."))
      )
    (princ "\nОбъект не выбран.")
    )
  (princ)
)