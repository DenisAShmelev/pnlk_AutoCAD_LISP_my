(defun c:DrawCirclesOnLayers (/ doc layers-list layer-name radius)
  (vl-load-com)
  
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  
  ;; Получаем список всех слоев
  (setq layers-list (vla-get-layers doc))
  
  ;; Начальный радиус
  (setq radius 1000.0)
  
  ;; Перебираем все слои
  (vlax-for layer layers-list
    (setq layer-name (vla-get-name layer))
    
    ;; Создаем круг на текущем слое
    (command "._CIRCLE" "0,0,0" radius)
    
    ;; Перемещаем круг на соответствующий слой
    (setq last-ent (entlast))
    (entmod (subst (cons 8 layer-name) (assoc 8 (entget last-ent)) (entget last-ent)))
    
    ;; Увеличиваем радиус для следующего слоя
    (setq radius (+ radius 100.0))
  )
  
  (princ (strcat "\nСоздано кругов на " (itoa (vla-get-count layers-list)) " слоях"))
  (princ)
)

;; Функция для создания текста для каждого текстового стиля
(defun c:CreateTextForStyles (/ doc styles-list style-name text-y-pos)
  (vl-load-com)
  
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  
  ;; Получаем список всех текстовых стилей
  (setq styles-list (vla-get-textstyles doc))
  
  ;; Начальная позиция Y для текста - начинаем с 0
  (setq text-y-pos 0.0)
  
  ;; Перебираем все текстовые стили
  (vlax-for style styles-list
    (setq style-name (vla-get-name style))
    
    ;; Устанавливаем текущий текстовый стиль
    (command "._STYLE" style-name "" "" "" "" "" "")
    
    ;; Создаем текст с названием стиля в координатах (0,text-y-pos,0)
    (command "._TEXT" 
             (strcat "0," (rtos text-y-pos 2 0))  ;; Координаты 0,Y с отключением десятичных
             "50"          ;; Высота текста
             "0"           ;; Угол поворота
             style-name    ;; Текст (название стиля)
    )
    
    ;; Увеличиваем позицию Y на 100 мм для следующего текста
    (setq text-y-pos (+ text-y-pos 100.0))
  )
  
  (princ (strcat "\nСоздано текстов для " 
                 (itoa (vla-get-count styles-list)) 
                 " текстовых стилей (включая Standard)"))
  (princ)
)

;; Объединенная функция, которая создает и круги и текст
(defun c:CreateAllObjects (/ doc layers-list styles-list layer-name style-name 
                           radius text-y-pos)
  (vl-load-com)
  
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  
  ;; --- Часть 1: Создание кругов для каждого слоя ---
  (princ "\nСоздание кругов для каждого слоя...")
  
  ;; Получаем список всех слоев
  (setq layers-list (vla-get-layers doc))
  
  ;; Начальный радиус
  (setq radius 1000.0)
  
  ;; Перебираем все слои
  (vlax-for layer layers-list
    (setq layer-name (vla-get-name layer))
    
    ;; Создаем круг на текущем слое
    (command "._CIRCLE" "0,0,0" radius)
    
    ;; Перемещаем круг на соответствующий слой
    (setq last-ent (entlast))
    (entmod (subst (cons 8 layer-name) (assoc 8 (entget last-ent)) (entget last-ent)))
    
    ;; Увеличиваем радиус для следующего слоя
    (setq radius (+ radius 100.0))
  )
  
  (princ (strcat "\nСоздано кругов на " (itoa (vla-get-count layers-list)) " слоях"))
  
  ;; --- Часть 2: Создание текста для каждого текстового стиля ---
  (princ "\nСоздание текста для каждого текстового стиля...")
  
  ;; Получаем список всех текстовых стилей
  (setq styles-list (vla-get-textstyles doc))
  
  ;; Начальная позиция Y для текста - начинаем с 0
  (setq text-y-pos 0.0)
  
  (setq style-count 0)
  
  ;; Перебираем все текстовые стили
  (vlax-for style styles-list
    (setq style-name (vla-get-name style))
    
    ;; Устанавливаем текущий текстовый стиль
    (command "._STYLE" style-name "" "" "" "" "" "")
    
    ;; Создаем текст с названием стиля в координатах (0,text-y-pos,0)
    (command "._TEXT" 
             (strcat "0," (rtos text-y-pos 2 0))  ;; Координаты 0,Y с отключением десятичных
             "50"          ;; Высота текста
             "0"           ;; Угол поворота
             style-name    ;; Текст (название стиля)
    )
    
    ;; Увеличиваем позицию Y на 100 мм для следующего текста
    (setq text-y-pos (+ text-y-pos 100.0))
    (setq style-count (1+ style-count))
  )
  
  (princ (strcat "\nСоздано текстов для " 
                 (itoa style-count) 
                 " текстовых стилей (включая Standard)"))
  
  (princ "\nГотово! Все объекты созданы.")
  (princ)
)