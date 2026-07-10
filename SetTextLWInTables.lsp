(defun c:SetTextLWInSPDSTABLE2 (/ ss blk ent obj txtlw cnt pt minx maxx miny maxy)
  (setq txtlw 0.15) ; требуемый вес линии в мм
  (setq cnt 0)

  ;; Выбираем все экземпляры блока с именем SPDSTABLE2 (регистр важен)
  (if (setq ss (ssget "_X" '((0 . "INSERT") (2 . "SPDSTABLE2"))))
      (progn
        ;; Для каждого блока получаем его габариты (extents)
        (repeat (setq i (sslength ss))
          (setq blk (ssname ss (setq i (1- i))))
          (setq obj (vlax-ename->vla-object blk))

          ;; Получаем координаты границ блока
          (setq minx (car (vlax-get obj 'Min))
                maxx (car (vlax-get obj 'Max))
                miny (cadr (vlax-get obj 'Min))
                maxy (cadr (vlax-get obj 'Max))
          )

          ;; Теперь пройдём по всем TEXT и MTEXT на чертеже и проверим,
          ;; попадает ли их точка вставки внутрь этого блока
          (if (setq ss-txt (ssget "_X" '((0 . "TEXT,MTEXT"))))
              (repeat (setq j (sslength ss-txt))
                (setq ent (ssname ss-txt (setq j (1- j))))
                (setq obj-txt (vlax-ename->vla-object ent))

                ;; Точка вставки: для TEXT это InsertionPoint, для MTEXT — Location
                (if (= (vla-get-ObjectName obj-txt) "AcDbText")
                    (setq pt (vlax-get-property obj-txt 'InsertionPoint))
                  (setq pt (vlax-get-property obj-txt 'Location))
                )

                ;; Проверка попадания точки внутрь прямоугольника блока
                (if (and (>= (car pt) minx) (<= (car pt) maxx)
                         (>= (cadr pt) miny) (<= (cadr pt) maxy))
                    (progn
                      ;; Меняем вес линии
                      (vla-put-Lineweight obj-txt txtlw)
                      (setq cnt (1+ cnt))
                    )
                )
              )
          )
        )
        (princ (strcat "\nИзменён вес линии у " (itoa cnt) " текстовых объектов внутри блоков SPDSTABLE2."))
      )
    (princ "\nЭкземпляры блока SPDSTABLE2 не найдены.")
  )
  (princ)
)
