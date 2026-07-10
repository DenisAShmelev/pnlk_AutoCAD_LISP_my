(defun c:ScaleBlockLinetypes (/ ss i blkDef blkName)
  (vl-load-com)
  
  ; Запрос выбора блоков
  (prompt "\nВыберите блоки для обработки: ")
  (setq ss (ssget '((0 . "INSERT"))))
  
  (if ss
    (progn
      (repeat (setq i (sslength ss))
        (setq blkDef (vla-item (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object)))
                               (cdr (assoc 2 (entget (ssname ss (setq i (1- i))))))))
        
        ; Обработка каждого примитива в определении блока
        (vlax-for obj blkDef
          (if (and (not (vlax-property-available-p obj 'linetype)) ; Исключаем блоки внутри блока
                 (vlax-property-available-p obj 'color))
            (progn
              ; Установка масштаба типа линии = 5
              (if (vlax-property-available-p obj 'linetypescale)
                (vla-put-linetypescale obj 5.0)
              )
              
              ; Установка цвета = зеленый (цвет 3)
              (vla-put-color obj 3)
            )
          )
        )
        (princ (strcat "\nОбработан блок: " (vla-get-name blkDef)))
      )
      (princ "\nОбработка блоков завершена.")
    )
    (princ "\nБлоки не выбраны.")
  )
  (princ)
)