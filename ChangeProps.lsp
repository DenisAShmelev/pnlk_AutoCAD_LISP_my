(defun c:ChangeProps (/ ss index ent ent_data)
  (setq ss (ssget)) ; Выбор объектов
  (if ss
    (progn
      (setq index 0)
      (repeat (sslength ss)
        (setq ent (ssname ss index))
        (setq ent_data (entget ent))
        ; Изменение цвета на зеленый (индекс 3)
        (if (assoc 62 ent_data)
          (setq ent_data (subst '(62 . 3) (assoc 62 ent_data) ent_data))
          (setq ent_data (append ent_data (list '(62 . 3))))
        )
        ; Изменение масштаба типа линии на 5
        (if (assoc 48 ent_data)
          (setq ent_data (subst '(48 . 5.0) (assoc 48 ent_data) ent_data))
          (setq ent_data (append ent_data (list '(48 . 5.0))))
        )
        (entmod ent_data) ; Применить изменения
        (setq index (1+ index))
      )
      (princ "\nСвойства изменены: цвет = зеленый, масштаб типа линии = 5.")
    )
    (princ "\nОбъекты не выбраны.")
  )
  (princ)
)