(defun c:GetCentroid (/ ent entData geomCenter area)
  ;; Запрос выбора объекта
  (setq ent (car (entsel "\nВыберите замкнутый объект: ")))
  
  ;; Проверка, что объект выбран
  (if ent
    (progn
      ;; Получение данных об объекте
      (setq entData (entget ent))
      
      ;; Проверка, является ли объект замкнутым (полилиния или другой замкнутый объект)
      (cond
        ;; Для полилиний
        ((= (cdr (assoc 0 entData)) "LWPOLYLINE")
         (if (vlax-curve-isClosed ent)
           (progn
             (setq geomCenter (vlax-get-property (vlax-ename->vla-object ent) 'Centroid))
             (princ (strcat "\nГеометрический центр: (" 
                            (rtos (car geomCenter) 2 4) 
                            ", " 
                            (rtos (cadr geomCenter) 2 4) 
                            ")"))
           )
           (princ "\nВыбранный объект не является замкнутым.")
         )
        )
        
        ;; Для кругов
        ((= (cdr (assoc 0 entData)) "CIRCLE")
         (setq geomCenter (cdr (assoc 10 entData))) ; Центр круга
         (princ (strcat "\nГеометрический центр: (" 
                        (rtos (car geomCenter) 2 4) 
                        ", " 
                        (rtos (cadr geomCenter) 2 4) 
                        ")"))
        )
        
        ;; Для эллипсов
        ((= (cdr (assoc 0 entData)) "ELLIPSE")
         (setq geomCenter (cdr (assoc 10 entData))) ; Центр эллипса
         (princ (strcat "\nГеометрический центр: (" 
                        (rtos (car geomCenter) 2 4) 
                        ", " 
                        (rtos (cadr geomCenter) 2 4) 
                        ")"))
        )
        
        ;; Для других типов объектов
        (t
         (princ "\nВыбранный объект не поддерживается.")
        )
      )
    )
    (princ "\nОбъект не выбран.")
  )
  (princ)
)
