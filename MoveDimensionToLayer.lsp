(defun c:MoveDimensionsToLayer (/ layerName ss i ent)
  ;; Имя слоя, на который нужно перенести размеры
  (setq layerName "Размеры")

  ;; Проверяем, существует ли слой "Размеры". Если нет, создаем его.
  (if (not (tblsearch "LAYER" layerName))
    (command "_.LAYER" "_M" layerName "") ; Создаем слой "Размеры"
  )

  ;; Выбираем все размерные объекты в чертеже
  (setq ss (ssget "X" '((0 . "DIMENSION")))) ; Фильтр для выбора только размерных объектов

  ;; Если размеры найдены, переносим их на слой "Размеры"
  (if ss
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (setq ent (ssname ss i)) ; Получаем имя текущего объекта
        (vla-put-Layer (vlax-ename->vla-object ent) layerName) ; Переносим объект на слой "Размеры"
        (setq i (1+ i))
      )
      (princ (strcat "\nПеренесено " (itoa (sslength ss)) " размерных объектов на слой \"" layerName "\"."))
    )
    (princ "\nРазмерные объекты не найдены.")
  )

  ;; Завершение программы
  (princ)
)