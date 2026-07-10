
; Тут создается текстовый стиль при необходимости спасибо VVA http://forum.dwg.ru
(defun c:pnlk_text-style-make (text-style-name text-font-file / text_style)
	(if (not (tblsearch "pnlkSTYLE" text-style-name))
		(progn
			(setq text_style  (vla-add (vla-get-textstyles (vla-get-activedocument (vlax-get-acad-object))) text-style-name))
			(setq currFontFile (findfile (strcat (getenv "WinDir") "\\Fonts\\" text-font-file)))
			(vla-put-fontfile text_style currFontFile) ; Файл шрифта текстового стиля
			(vla-put-height text_style 0.0) ;Высота шрифта
			(vla-put-width text_style 1.0);Степень сжатия/растяжения
		) ;end of progn
	) ;end of if
) ;end of defun text-style-make








(defun c:CreateTextStyle (/ styleName)
    ;; Создание текстового стиля
    (setq styleName "pnlkMyTextStyle")
    
    ;; Проверка существования стиля
    (if (tblsearch "STYLE" styleName)
        (princ (strcat "\nТекстовый стиль \"" styleName "\" уже существует."))
        (progn
            ;; Создание нового текстового стиля
            (command ".-STYLE"
                     styleName      ; Имя стиля
                     "Arial"        ; Имя шрифта (можно изменить на нужный)
                     "0.0"          ; Высота текста (0.0 - переменная высота)
                     "1.0"          ; Коэффициент ширины
                     "0"            ; Угол наклона (obliquing angle)
                     "N"            ; Генерация в обратном порядке? (N - нет)
                     "N"            ; Генерация вверх ногами? (N - нет)
                     "N"            ; Вертикальная ориентация? (N - нет)
            )
            
            ;; Дополнительные настройки стиля (опционально)
            (setvar "TEXTSTYLE" styleName)  ; Установка созданного стиля текущим
            
            (princ (strcat "\nТекстовый стиль \"" styleName "\" успешно создан."))
        )
    )
    (princ)
)

;; Альтернативная версия с более детальными настройками
(defun c:CreateTextStyleDetailed (/ styleName)
    (setq styleName "pnlkMyTextStyle")
    
    (if (tblsearch "STYLE" styleName)
        (princ (strcat "\nТекстовый стиль \"" styleName "\" уже существует."))
        (progn
            ;; Создание стиля с разными параметрами
            (command ".-STYLE"
                     styleName
                     "romans.shx"   ; SHX шрифт (компактный)
                     "2.5"          ; Фиксированная высота 2.5
                     "0.8"          ; Коэффициент ширины (уже обычного)
                     "15"           ; Угол наклона 15 градусов
                     "N"            ; Не отражать
                     "N"            ; Не переворачивать
                     "N"            ; Горизонтальная ориентация
            )
            (princ (strcat "\nТекстовый стиль \"" styleName "\" создан с фиксированной высотой 2.5."))
        )
    )
    (princ)
)

;; Функция для создания стиля с TrueType шрифтом
(defun c:CreateTTFTextStyle (/ styleName)
    (setq styleName "pnlkMyTextStyle")
    
    (if (tblsearch "STYLE" styleName)
        (princ (strcat "\nТекстовый стиль \"" styleName "\" уже существует."))
        (progn
            ;; Создание стиля с TrueType шрифтом
            (command ".-STYLE"
                     styleName
                     "Arial.ttf"    ; TrueType шрифт
                     "0.0"          ; Переменная высота
                     "1.0"          ; Нормальная ширина
                     "0"            ; Без наклона
                     "N"            ; Нормальное направление
                     "N"            ; Нормальная ориентация
                     "N"            ; Горизонтально
            )
            (princ (strcat "\nТекстовый стиль \"" styleName "\" создан с TrueType шрифтом Arial."))
        )
    )
    (princ)
)

;; Функция для просмотра свойств созданного стиля
(defun c:CheckTextStyle (/ styleName styleData)
    (setq styleName "pnlkMyTextStyle")
    (setq styleData (tblsearch "STYLE" styleName))
    
    (if styleData
        (progn
            (princ (strcat "\nСвойства стиля \"" styleName "\":"))
            (princ (strcat "\n- Имя шрифта: " (cdr (assoc 3 styleData))))
            (princ (strcat "\n- Высота: " (rtos (cdr (assoc 40 styleData)))))
            (princ (strcat "\n- Коэффициент ширины: " (rtos (cdr (assoc 41 styleData)))))
            (princ (strcat "\n- Угол наклона: " (rtos (cdr (assoc 51 styleData)))))
            (princ (strcat "\n- Генерация: " (if (= (cdr (assoc 71 styleData)) 0) "Обычная" "Специальная")))
        )
        (princ (strcat "\nТекстовый стиль \"" styleName "\" не найден."))
    )
    (princ)
)

;; Основная функция создания с выбором параметров
(defun c:CreateMyTextStyle (/ styleName fontName textHeight widthFactor obliquing)
    (setq styleName "pnlkMyTextStyle")
    
    ;; Параметры стиля (можно изменить по необходимости)
    (setq fontName "Arial")          ; Шрифт
    (setq textHeight 0.0)           ; 0.0 - переменная высота
    (setq widthFactor 1.0)          ; Коэффициент ширины
    (setq obliquing 0)              ; Угол наклона в градусах
    
    (if (tblsearch "STYLE" styleName)
        (princ (strcat "\nТекстовый стиль \"" styleName "\" уже существует."))
        (progn
            (command ".-STYLE"
                     styleName
                     fontName
                     (rtos textHeight)    ; Преобразование в строку
                     (rtos widthFactor)   ; Преобразование в строку
                     (rtos obliquing)     ; Преобразование в строку
                     "N"
                     "N"
                     "N"
            )
            
            ;; Установка дополнительных свойств через системные переменные
            (setvar "TEXTSTYLE" styleName)
            
            (princ (strcat "\nТекстовый стиль \"" styleName "\" успешно создан со следующими параметрами:"))
            (princ (strcat "\n- Шрифт: " fontName))
            (princ (strcat "\n- Высота: " (if (= textHeight 0.0) "Переменная" (rtos textHeight))))
            (princ (strcat "\n- Коэффициент ширины: " (rtos widthFactor)))
            (princ (strcat "\n- Угол наклона: " (rtos obliquing) " градусов"))
        )
    )
    (princ)
)

;; Загрузка и выполнение
(princ "\nКоманды для создания текстового стиля:")
(princ "\n- CreateTextStyle - базовая версия")
(princ "\n- CreateMyTextStyle - основная версия с настройками")
(princ "\n- CreateTextStyleDetailed - с фиксированной высотой")
(princ "\n- CreateTTFTextStyle - с TrueType шрифтом")
(princ "\n- CheckTextStyle - проверка свойств стиля")
(princ)