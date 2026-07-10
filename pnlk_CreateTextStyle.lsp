(defun c:CreateTextStyle (/ styleName)
    ;; Создание текстового стиля
    (setq styleName "pnlkMyTextStyle_CreateTextStyle")
    
    ;; Проверка существования стиля
    (if (tblsearch "STYLE" styleName)
        (princ (strcat "\nТекстовый стиль \"" styleName "\" уже существует."))
        (progn
            ;; Создание нового текстового стиля с помощью command
            (command "STYLE" 
                     styleName      ; Имя стиля
                     "Arial"        ; Имя шрифта
                     "0.0"          ; Высота текста
                     "1.0"          ; Коэффициент ширины
                     "0"            ; Угол наклона
                     "N"            ; Генерация в обратном порядке?
                     "N"            ; Генерация вверх ногами?
                     "N"            ; Вертикальная ориентация?
            )
            
            (princ (strcat "\nТекстовый стиль \"" styleName "\" успешно создан."))
        )
    )
    (princ)
)

;; Альтернативный способ через словарь и vla-функции
(defun c:CreateTextStyleVLA (/ acadApp acadDoc textStyles newStyle)
    (vl-load-com) ; Загрузка COM-функций
    
    (setq styleName "pnlkMyTextStyle_CreateTextStyleVLA")
    
    ;; Проверка существования стиля
    (if (tblsearch "STYLE" styleName)
        (princ (strcat "\nТекстовый стиль \"" styleName "\" уже существует."))
        (progn
            ;; Получаем доступ к объектам AutoCAD
            (setq acadApp (vlax-get-acad-object))
            (setq acadDoc (vla-get-activedocument acadApp))
            (setq textStyles (vla-get-textstyles acadDoc))
            
            ;; Создаем новый текстовый стиль
            (setq newStyle (vla-add textStyles styleName))
            
            ;; Устанавливаем свойства стиля
            (vla-put-fontfile newStyle "arial.ttf")    ; Шрифт
            (vla-put-height newStyle 0.0)              ; 0.0 - переменная высота
            (vla-put-width newStyle 1.0)               ; Коэффициент ширины
            (vla-put-obliqueangle newStyle 0.0)        ; Угол наклона в радианах
            (vla-put-backwards newStyle :vlax-false)   ; Не отражать
            (vla-put-upsidedown newStyle :vlax-false)  ; Не переворачивать
            
            (princ (strcat "\nТекстовый стиль \"" styleName "\" успешно создан через VLA."))
        )
    )
    (princ)
)

;; Создание стиля с SHX шрифтом
(defun c:CreateTextStyleSHX (/ styleName)
    (setq styleName "pnlkMyTextStyle_CreateTextStyleSHX")
    
    (if (tblsearch "STYLE" styleName)
        (princ (strcat "\nТекстовый стиль \"" styleName "\" уже существует."))
        (progn
            ;; Создание стиля с SHX шрифтом
            (command "STYLE"
                     styleName
                     "romans"       ; SHX шрифт (без расширения .shx)
                     "2.5"          ; Высота текста
                     "0.8"          ; Коэффициент ширины
                     "0"            ; Угол наклона
                     "N"            ; Не отражать
                     "N"            ; Не переворачивать
                     "N"            ; Горизонтальная ориентация
            )
            (princ (strcat "\nТекстовый стиль \"" styleName "\" создан с SHX шрифтом romans."))
        )
    )
    (princ)
)

;; Создание стиля с детальными настройками через VLA
(defun c:CreateTextStyleDetailed (/ acadApp acadDoc textStyles newStyle)
    (vl-load-com)
    
    (setq styleName "pnlkMyTextStyle_CreateTextStyleDetailed")
    
    (if (tblsearch "STYLE" styleName)
        (princ (strcat "\nТекстовый стиль \"" styleName "\" уже существует."))
        (progn
            ;; Получаем доступ к объектам AutoCAD
            (setq acadApp (vlax-get-acad-object))
            (setq acadDoc (vla-get-activedocument acadApp))
            (setq textStyles (vla-get-textstyles acadDoc))
            
            ;; Создаем новый текстовый стиль
            (setq newStyle (vla-add textStyles styleName))
            
            ;; Устанавливаем свойства стиля
            (vla-put-fontfile newStyle "romans.shx")   ; SHX шрифт
            (vla-put-bigfontfile newStyle "")          ; Big font file (для русских шрифтов)
            (vla-put-height newStyle 2.5)              ; Фиксированная высота
            (vla-put-width newStyle 0.8)               ; Коэффициент ширины 0.8
            (vla-put-obliqueangle newStyle 0.0)        ; Угол наклона 0 градусов
            (vla-put-backwards newStyle :vlax-false)   ; Не отражать
            (vla-put-upsidedown newStyle :vlax-false)  ; Не переворачивать
            
            ;; Делаем стиль текущим
            (vla-put-activetextstyle acadDoc newStyle)
            
            (princ (strcat "\nТекстовый стиль \"" styleName "\" создан с детальными настройками."))
            (princ (strcat "\n- Шрифт: romans.shx"))
            (princ (strcat "\n- Высота: 2.5"))
            (princ (strcat "\n- Ширина: 0.8"))
            (princ (strcat "\n- Наклон: 0 градусов"))
        )
    )
    (princ)
)

;; Функция для просмотра свойств созданного стиля
(defun c:CheckTextStyle (/ acadApp acadDoc textStyles styleObj found)
    (vl-load-com)
    
    (setq styleName "pnlkMyTextStyle_CheckTextStyle")
    
    (setq acadApp (vlax-get-acad-object))
    (setq acadDoc (vla-get-activedocument acadApp))
    (setq textStyles (vla-get-textstyles acadDoc))
    
    (setq found :vlax-false)
    (vlax-for style textStyles
        (if (= (vla-get-name style) styleName)
            (progn
                (setq styleObj style)
                (setq found :vlax-true)
            )
        )
    )
    
    (if found
        (progn
            (princ (strcat "\nСвойства стиля \"" styleName "\":"))
            (princ (strcat "\n- Имя шрифта: " (vla-get-fontfile styleObj)))
            (princ (strcat "\n- Высота: " (rtos (vla-get-height styleObj))))
            (princ (strcat "\n- Коэффициент ширины: " (rtos (vla-get-width styleObj))))
            (princ (strcat "\n- Угол наклона: " (rtos (* (/ (vla-get-obliqueangle styleObj) pi) 180)) " градусов"))
            (princ (strcat "\n- Отражен: " (if (vla-get-backwards styleObj) "Да" "Нет")))
            (princ (strcat "\n- Перевернут: " (if (vla-get-upsidedown styleObj) "Да" "Нет")))
        )
        (princ (strcat "\nТекстовый стиль \"" styleName "\" не найден."))
    )
    (princ)
)

;; Универсальная функция создания стиля
(defun c:CreateMyTextStyle ()
    (princ "\nВыберите метод создания стиля:")
    (princ "\n1 - Простой метод (команда STYLE)")
    (princ "\n2 - VLA метод (рекомендуется)")
    (princ "\n3 - С SHX шрифтом")
    (princ "\n4 - С детальными настройками")
    
    (initget 1 "1 2 3 4")
    (setq choice (getkword "\nВыберите метод [1/2/3/4]: "))
    
    (cond
        ((= choice "1") (c:CreateTextStyle))
        ((= choice "2") (c:CreateTextStyleVLA))
        ((= choice "3") (c:CreateTextStyleSHX))
        ((= choice "4") (c:CreateTextStyleDetailed))
    )
    (princ)
)

;; Загрузка и выполнение
(princ "\nКоманды для создания текстового стиля:")
(princ "\n- CreateMyTextStyle - универсальная команда")
(princ "\n- CreateTextStyle - простой метод")
(princ "\n- CreateTextStyleVLA - VLA метод (рекомендуется)")
(princ "\n- CreateTextStyleSHX - с SHX шрифтом")
(princ "\n- CreateTextStyleDetailed - детальные настройки")
(princ "\n- CheckTextStyle - проверка свойств стиля")
(princ)