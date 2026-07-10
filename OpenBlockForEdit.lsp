(defun c:OpenBlockForEdit (/ selected-objects block-ref)
  ;; Получаем набор предварительно выделенных объектов
  (setq selected-objects (ssget "_I")) ; "_I" означает "использовать текущее выделение"
  
  ;; Проверяем, что что-то выделено
  (if (null selected-objects)
    (progn
      (princ "\nНет выделенных объектов. Сначала выделите блоки.")
      (exit))
  )
  
  ;; Проходим по всем выделенным объектам
  (setq i 0)
  (repeat (sslength selected-objects)
    (setq block-ref (ssname selected-objects i)) ; Получаем имя объекта
    (setq block-type (cdr (assoc 0 (entget block-ref)))) ; Получаем тип объекта
    
    ;; Проверяем, является ли объект блоком
    (if (= block-type "INSERT")
      (progn
        ;; Открываем блок для контекстного редактирования
        (command "_.REFEDIT" block-ref "")
        (exit) ; Выходим после обработки первого блока
      )
    )
    
    ;; Увеличиваем счетчик
    (setq i (1+ i))
  )
  
  ;; Если ни один из выделенных объектов не является блоком
  (princ "\nСреди выделенных объектов нет блоков.")
  (princ)
)

;;; Для удобства использования создаем кнопку
;;(defun c:CreateButton ()
;;  (vlax-invoke
;;    (vla-get-MenuBar (vla-get-ActiveDocument (vlax-get-acad-object)))
;;    'AddMenu "Редактирование блока"
;;    (list
;;      (list "Открыть блок для редактирования" "c:OpenBlockForEdit")
;;    )
;;  )
;;  (princ "\nКнопка добавлена в меню.")
;;  (princ)
;;)

;;^C^C(if (not c:OpenBlockForEdit)(load "OpenBlockForEdit.lsp"));OpenBlockForEdit