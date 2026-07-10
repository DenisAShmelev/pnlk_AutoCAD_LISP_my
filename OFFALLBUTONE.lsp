(defun c:OFFALLBUTONE (/ ent layername)
  (vl-load-com)
  
  ;; Запрос выбора объекта для определения целевого слоя
  (setq ent (entsel "\nВыберите объект на слое, который нужно оставить включённым: "))
  
  (if ent
    (progn
      ;; Получаем имя слоя выбранного объекта
      (setq layername (cdr (assoc 8 (entget (car ent)))))
      
      ;; Проходим по всем слоям в чертеже
      (foreach lay (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object)))
        (if (not (equal (vla-get-Name lay) layername 1e-6))
          (vla-put-LayerOn lay :vlax-false)  ; Выключаем слой
        )
      )
      
      (princ (strcat "\nВсе слои выключены, кроме слоя \"" layername "\"."))
    )
    (princ "\nВыбор не выполнен.")
  )
  
  (princ)
)
