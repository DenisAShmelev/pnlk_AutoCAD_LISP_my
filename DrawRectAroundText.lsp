(defun c:DrawRectAroundText (/ textEnt textData textHeight textWidth 
                            textInsertion LL UR textBox)
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
          
          ; Для обычного текста (TEXT)
          (if (= (cdr (assoc 0 textData)) "TEXT")
            (progn
              (setq textWidth (* (strlen (cdr (assoc 1 textData))) textHeight 0.6))
              (setq LL (list (- (car textInsertion) (* textHeight 0.2))
                            (- (cadr textInsertion) (* textHeight 0.2))
                            (caddr textInsertion)))
              (setq UR (list (+ (car textInsertion) textWidth (* textHeight 0.6))
                            (+ (cadr textInsertion) textHeight (* textHeight 0.2))
                            (caddr textInsertion)))
            )
          )
          
          ; Для многострочного текста (MTEXT)
          (if (= (cdr (assoc 0 textData)) "MTEXT")
            (progn
              (setq textBox (textbox textData))
              (setq LL (list (+ (car textInsertion) (caar textBox))
                            (+ (cadr textInsertion) (cadar textBox))
                            (caddr textInsertion)))
              (setq UR (list (+ (car textInsertion) (caadr textBox))
                            (+ (cadr textInsertion) (cadadr textBox))
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