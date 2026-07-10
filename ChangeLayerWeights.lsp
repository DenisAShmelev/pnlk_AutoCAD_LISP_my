(defun c:ChangeLayerWeights (/ lay2 lay6)
    ; Проверка и изменение слоя 1
    (if (tblsearch "LAYER" "1")
        (progn
            (setq lay1 (tblobjname "LAYER" "1"))
            (if lay1
                (progn
                    (vla-put-LineWeight (vlax-ename->vla-object lay1) acLnWt020)
                    (princ "\nСлой '1': вес линии установлен на 0.20 мм")
                )
            )
        )
        (princ "\nСлой '1' не найден")
    )
    
    ; Проверка и изменение слоя 6
    (if (tblsearch "LAYER" "6")
        (progn
            (setq lay6 (tblobjname "LAYER" "6"))
            (if lay6
                (progn
                    (vla-put-LineWeight (vlax-ename->vla-object lay6) acLnWt009)
                    (princ "\nСлой '6': вес линии установлен на 0.09 мм")
                )
            )
        )
        (princ "\nСлой '6' не найден")
    )
    
    (princ)
)