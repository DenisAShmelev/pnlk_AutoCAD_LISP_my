(defun c:DrawRectAroundText3 (/ textEnt textData textHeight textWidth textInsertion 
                            textAngle LL UR textBox padding rotMatrix)
  (vl-load-com)
  
  (setq textEnt (car (entsel "\nВыберите текст: ")))
  (if textEnt
    (progn
      (setq textData (entget textEnt))
      
      (if (or (= (cdr (assoc 0 textData)) "TEXT")
              (= (cdr (assoc 0 textData)) "MTEXT"))
        (progn
          (setq textHeight (cdr (assoc 40 textData)))
          (if (null textHeight)
            (setq textHeight (getvar "TEXTSIZE"))
          )
          
          (setq textInsertion (cdr (assoc 10 textData)))
          (setq textAngle (cdr (assoc 50 textData))) ; Угол поворота текста (радианы)
          (if (null textAngle) (setq textAngle 0.0)) ; Если угол не задан, считаем 0
          
          ; Создаем матрицу поворота
          (setq rotMatrix (list (cos textAngle) (- (sin textAngle)) 
                               (sin textAngle) (cos textAngle)))
          
          ; Для обычного текста (TEXT)
          (if (= (cdr (assoc 0 textData)) "TEXT")
            (progn
              (setq textWidth (* (strlen (cdr (assoc 1 textData))) textHeight 0.6))
              (setq LL (list (- (* textHeight 0.2)) (- (* textHeight 0.2))))
              (setq UR (list (+ textWidth (* textHeight 0.2)) (+ textHeight (* textHeight 0.2))))
              
              ; Применяем поворот к точкам прямоугольника
              (setq LL (list (+ (car textInsertion) 
                            (+ (* (car rotMatrix) (car LL)) (* (cadr rotMatrix) (cadr LL)))
                            (+ (cadr textInsertion)
                            (+ (* (caddr rotMatrix) (car LL)) (* (cadddr rotMatrix) (cadr LL))))
                            (caddr textInsertion)))
              (setq UR (list (+ (car textInsertion) 
                            (+ (* (car rotMatrix) (car UR)) (* (cadr rotMatrix) (cadr UR)))
                            (+ (cadr textInsertion)
                            (+ (* (caddr rotMatrix) (car UR)) (* (cadddr rotMatrix) (cadr UR))))
                            (caddr textInsertion)))
            )
          )
          
          ; Для многострочного текста (MTEXT)
          (if (= (cdr (assoc 0 textData)) "MTEXT")
            (progn
              (setq textBox (textbox textData))
              (setq LL (list (caar textBox) (cadar textBox)))
              (setq UR (list (caadr textBox) (cadadr textBox)))
              
              ; Применяем поворот к точкам прямоугольника
              (setq LL (list (+ (car textInsertion) 
                            (+ (* (car rotMatrix) (car LL)) (* (cadr rotMatrix) (cadr LL)))
                            (+ (cadr textInsertion)
                            (+ (* (caddr rotMatrix) (car LL)) (* (cadddr rotMatrix) (cadr LL))))
                            (caddr textInsertion)))
              (setq UR (list (+ (car textInsertion) 
                            (+ (* (car rotMatrix) (car UR)) (* (cadr rotMatrix) (cadr UR)))
                            (+ (cadr textInsertion)
                            (+ (* (caddr rotMatrix) (car UR)) (* (cadddr rotMatrix) (cadr UR))))
                            (caddr textInsertion)))
            )
          )
          
          ; Рисуем прямоугольник
          (command "RECTANG" "_non" LL "_non" UR)
          (princ "\nПрямоугольник создан вокруг текста.")
        )
        (princ "\nВыбранный объект не является текстом!")
      )
    )
    (princ "\nНичего не выбрано!")
  )
  (princ)
)