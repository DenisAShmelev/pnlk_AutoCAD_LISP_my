(defun c:RotateText90 (/ ent entData entType)
  ;; Запрашиваем у пользователя выбор объекта
  (setq ent (car (entsel "\nВыберите текстовый объект для поворота: ")))
  
  ;; Проверяем, что объект выбран
  (if ent
    (progn
      ;; Получаем данные об объекте
      (setq entData (entget ent))
      (setq entType (cdr (assoc 0 entData))) ; Тип объекта
      
      ;; Проверяем, является ли объект текстом (TEXT, MTEXT или ATTDEF)
      (if (or (= entType "TEXT") (= entType "MTEXT") (= entType "ATTDEF"))
        (progn
          ;; Применяем поворот на 90 градусов
          (command "_.ROTATE" ent "" "_non" (cdr (assoc 10 entData)) 180)
          ;; Сбрасываем выделение объекта
          (redraw ent 4)
          (princ "\nТекст успешно повернут на 90 градусов.")
        )
        ;; Если объект не является текстом
        (princ "\nВыбранный объект не является текстовым.")
      )
    )
    ;; Если объект не выбран
    (princ "\nОбъект не выбран.")
  )
  ;; Завершаем выполнение без вывода лишних сообщений
  (princ)
)

;; ^C^C(if (not c:RotateText90)(load "RotateText90.lsp"));RotateText90