(defun c:ParallelDimension ()
  (setq ss (ssget '((0 . "LINE")))) ; Запрашиваем три отрезка у пользователя
  
  (if (and ss (= (sslength ss) 3))
    (progn
      ;; Извлечение данных отрезков
      (setq line1 (entget (ssname ss 0)))
      (setq line2 (entget (ssname ss 1)))
      (setq line3 (entget (ssname ss 2)))
      
      ;; Извлечение координат концов отрезков
      (setq pt1-1 (cdr (assoc 10 line1)))
      (setq pt1-2 (cdr (assoc 11 line1)))
      (setq pt2-1 (cdr (assoc 10 line2)))
      (setq pt2-2 (cdr (assoc 11 line2)))
      (setq pt3-1 (cdr (assoc 10 line3)))
      (setq pt3-2 (cdr (assoc 11 line3)))
      
      ;; Функция проверки параллельности
      (defun parallel-p (p1 p2 q1 q2)
        (equal (angle p1 p2) (angle q1 q2) 1e-6))
      
      ;; Определяем параллельные отрезки и пересекающий отрезок
      (if (parallel-p pt1-1 pt1-2 pt2-1 pt2-2)
        (progn
          (setq AB (list pt1-1 pt1-2))
          (setq CD (list pt2-1 pt2-2))
          (setq EF (list pt3-1 pt3-2))
        )
        (if (parallel-p pt1-1 pt1-2 pt3-1 pt3-2)
          (progn
            (setq AB (list pt1-1 pt1-2))
            (setq CD (list pt3-1 pt3-2))
            (setq EF (list pt2-1 pt2-2))
          )
          (progn
            (setq AB (list pt2-1 pt2-2))
            (setq CD (list pt3-1 pt3-2))
            (setq EF (list pt1-1 pt1-2))
          )
        )
      )
      
      ;; Функция для расчета расстояния от точки до отрезка
      (defun distance-to-segment (pt seg-start seg-end)
        (setq vec-seg (mapcar '- seg-end seg-start))
        (setq vec-pt (mapcar '- pt seg-start))
        (setq proj-len (/ (dotproduct vec-pt vec-seg) (dotproduct vec-seg vec-seg)))
        (if (< proj-len 0)
          (distance pt seg-start)
          (if (> proj-len 1)
            (distance pt seg-end)
            (distance pt (mapcar '+ seg-start (mapcar '* proj-len vec-seg)))
          )
        )
      )
      
      ;; Функция для вычисления скалярного произведения
      (defun dotproduct (v1 v2)
        (+ (* (nth 0 v1) (nth 0 v2))
           (* (nth 1 v1) (nth 1 v2))
           (* (nth 2 v1) (nth 2 v2))))
      
      ;; Функция для вычисления расстояния между двумя точками
      (defun distance (pt1 pt2)
        (sqrt (+ (expt (- (nth 0 pt1) (nth 0 pt2)) 2)
                 (expt (- (nth 1 pt1) (nth 1 pt2)) 2)
                 (expt (- (nth 2 pt1) (nth 2 pt2)) 2))))
      
      ;; Находим точки на AB и CD, наиболее удаленные от EF
      (setq maxDistAB nil)
      (setq maxDistCD nil)
      
      (foreach pt (list (car AB) (cadr AB))
        (setq dist (distance-to-segment pt (car EF) (cadr EF)))
        (if (or (not maxDistAB) (> dist (nth 1 maxDistAB)))
          (setq maxDistAB (list pt dist))
        )
      )
      
      (foreach pt (list (car CD) (cadr CD))
        (setq dist (distance-to-segment pt (car EF) (cadr EF)))
        (if (or (not maxDistCD) (> dist (nth 1 maxDistCD)))
          (setq maxDistCD (list pt dist))
        )
      )
      
      ;; Сохраняем точки в переменные
      (setq pointA (car maxDistAB))
      (setq pointD (car maxDistCD))
      
      ;; Построение размера
      (command "DIMLINEAR" pointA pointD (car EF))
      
      (princ "\nРазмер построен.")
    )
    (princ "\nВыберите ровно три отрезка.")
  )
  
  (princ)
)

;; Регистрируем команду в AutoCAD
(vl-acad-defun 'c:ParallelDimension)