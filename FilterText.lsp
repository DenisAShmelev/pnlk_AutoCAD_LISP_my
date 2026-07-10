(defun c:FilterText (/ selection textObjects)
  ;; Запрос у пользователя выбрать объекты
  (setq selection (ssget '((0 . "TEXT,MTEXT")))) ; Выбор только текстовых объектов
  (if selection
    (progn
      ;; Создаем пустой список для текстовых объектов
      (setq textObjects '())
      
      ;; Проходим по всем выбранным объектам
      (repeat (sslength selection)
        (setq entity (ssname selection 0)) ; Получаем первый объект из набора
        (setq entData (entget entity))     ; Получаем данные объекта
        
        ;; Проверяем тип объекта
        (cond
          ((or (= (cdr (assoc 0 entData)) "TEXT")
               (= (cdr (assoc 0 entData)) "MTEXT"))
           ;; Если объект является текстом, добавляем его в список
           (setq textObjects (cons entity textObjects)))
        )
        
        ;; Удаляем текущий объект из набора выбора
        (ssdel entity selection)
      )
      
      ;; Если найдены текстовые объекты, создаем новый набор выбора
      (if textObjects
        (progn
          (setq newTextSelection (ssadd)) ; Создаем новый набор выбора
          (foreach obj textObjects
            (ssadd obj newTextSelection) ; Добавляем текстовые объекты в набор
          )
          (sssetfirst nil newTextSelection) ; Выделяем только текстовые объекты
          (princ "\nТолько текстовые объекты оставлены в наборе выбора.")
        )
        (princ "\nТекстовые объекты не найдены в выборе.")
      )
    )
    (princ "\nНет выбранных объектов или текстовые объекты отсутствуют.")
  )
  (princ)
)

;; ^C^C(if (not c:FilterText)(load "FilterText.lsp"));FilterText