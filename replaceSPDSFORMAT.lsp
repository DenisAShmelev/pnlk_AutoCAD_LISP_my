(defun c:replaceSPDSFORMAT (/ ss ent entdata newtext)
  (setq ss (ssget "_X" '((0 . "MTEXT,TEXT,SPDSFORMAT")))) ; Выбор всех текстовых объектов в чертеже
  (if ss
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (setq ent (ssname ss i))
        (setq entdata (entget ent))
        (setq oldtext (cdr (assoc 1 entdata))) ; Получение текущего текста
        (if (wcmatch oldtext "*Многоквартирный жилой дом со встроенными и пристроенными*") ; Проверка на наличие нужного текста
          (progn
            (setq newtext (vl-string-subst "Проверка" "Многоквартирный жилой дом со встроенными и пристроенными" oldtext)) ; Замена текста
            (setq entdata (subst (cons 1 newtext) (assoc 1 entdata) entdata)) ; Обновление данных объекта
            (entmod entdata) ; Применение изменений к объекту
          )
        )
        (setq i (1+ i))
      )
      (princ "\nЗамена завершена.")
    )
    (princ "\nНе найдено текстовых объектов для замены.")
  )
  (princ)
)