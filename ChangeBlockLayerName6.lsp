(defun c:ChangeBlockLayerName6 (/ ss index blk ent blk_def blk_ent blk_ent_data)
  (setq ss (ssget '((0 . "INSERT")))) ; Выбор только блоков
  (if ss
    (progn
      (setq index 0)
      (repeat (sslength ss)
        (setq blk (ssname ss index)) ; Получаем блок
        (setq blk_def (tblsearch "BLOCK" (cdr (assoc 2 (entget blk))))) ; Ищем определение блока
        (if blk_def
          (progn
            (setq blk_ent (tblobjname "BLOCK" (cdr (assoc 2 blk_def)))) ; Получаем первую сущность в блоке
            (while blk_ent
              (setq blk_ent_data (entget blk_ent)) ; Получаем данные сущности
              (if (assoc 8 blk_ent_data) ; Проверяем наличие слоя
                (progn
                  (setq blk_ent_data (subst '(8 . "6") (assoc 8 blk_ent_data) blk_ent_data)) ; Меняем слой
                  (entmod blk_ent_data) ; Применяем изменения
                )
              )
              (setq blk_ent (entnext blk_ent)) ; Переходим к следующей сущности в блоке
            )
          )
        )
        (setq index (1+ index))
      )
      (princ "\nСлой изменен на '6' во всех примитивах выбранных блоков.")
    )
    (princ "\nБлоки не выбраны.")
  )
  (command "_.REGEN") ; Регенерация чертежа
  (princ)
)