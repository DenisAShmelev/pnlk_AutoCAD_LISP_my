(defun c:RotateText90Select (/ ent entData entType rotationAngle)
  ;; Устанавливаем угол поворота равным 90 градусам
  (setq rotationAngle 180)

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
          ;; Применяем поворот на заданный угол (rotationAngle)
          (command "_.ROTATE" ent "" "_non" (cdr (assoc 10 entData)) rotationAngle)
          
          ;; Выделяем объект после поворота
          (sssetfirst nil (ssadd ent))
          (princ (strcat "\nТекст успешно повернут на " (itoa rotationAngle) " градусов и оставлен выделенным."))
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

;; ^C^C(if (not c:RotateText90Select)(load "RotateText90Select.lsp"));RotateText90Select