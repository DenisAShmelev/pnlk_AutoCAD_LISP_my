(defun c:GetBlockNames (/ selectionSet blockNames i entityData)
  ;; Запрос выбора объектов с фильтром только для блоков (INSERT)
  (setq selectionSet (ssget '((0 . "INSERT")))) ; Выбираем только блоки

  ;; Проверяем, есть ли выбранные объекты
  (if selectionSet
    (progn
      (setq blockNames '()) ; Создаем пустой список для хранения названий блоков

      ;; Проходим по всем выбранным объектам
      (repeat (sslength selectionSet)
        (setq i (1- (sslength selectionSet))) ; Индекс текущего объекта
        (setq entityData (entget (ssname selectionSet i))) ; Получаем данные объекта

        ;; Проверяем, что объект действительно является блоком
        (if (and entityData (assoc 2 entityData))
          (progn
            (setq blockName (cdr (assoc 2 entityData))) ; Извлекаем имя блока
            (setq blockNames (cons blockName blockNames)) ; Добавляем имя в список
            )
          )
        )
      
      ;; Удаляем дубликаты из списка
      (setq blockNames (remove-duplicates blockNames))

      ;; Выводим результат в командную строку
      (princ "\nСписок названий выбранных блоков:")
      (foreach name blockNames
        (princ (strcat "\n" name))
        )
      )
    (princ "\nНет выбранных блоков.")
    )

  ;; Очищаем вывод
  (princ)
)