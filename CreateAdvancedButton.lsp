(defun c:CreateMyButton2 ()
    (vl-load-com)
    
    (setq acad (vlax-get-acad-object))
    (setq menuGroup (vla-Item (vla-get-MenuGroups acad) 0))
    (setq toolbars (vla-get-Toolbars menuGroup))
    
    ; Создаем панель
    (if (not (vl-catch-all-error-p (vl-catch-all-apply 'vla-Item (list toolbars "MyToolbar"))))
        (progn
            (vla-Delete (vla-Item toolbars "MyToolbar"))
            (princ "\nСтарая панель удалена!")
        )
    )
    
    (setq myToolbar (vla-Add toolbars "MyToolbar"))
    
    ; Добавляем кнопку
    (vla-AddToolbarButton myToolbar 
        "" 
        "MyButton" 
        "Моя кнопка" 
        "Моя пользовательская кнопка" 
        "(c:MyCommand)^C^C"
    )
    
    (vla-put-Visible myToolbar :vlax-true)
    (princ "\nКнопка создана успешно!")
    (princ)
)

(defun c:MyCommand2 ()
    (alert "Моя кнопка работает!")
    (princ)
)





(defun c:CreateMyButton ()
    (vl-load-com)
    
    (setq acad (vlax-get-acad-object))
    (setq menuGroup (vla-Item (vla-get-MenuGroups acad) 0))
    (setq toolbars (vla-get-Toolbars menuGroup))
    
    ; Удаляем старую панель если существует
    (if (not (vl-catch-all-error-p 
                (setq oldToolbar (vl-catch-all-apply 'vla-Item (list toolbars "MyToolbar")))))
        (progn
            (vla-Delete oldToolbar)
            (princ "\nСтарая панель удалена!")
        )
    )
    
    ; Создаем новую панель
    (setq myToolbar (vla-Add toolbars "MyToolbar"))
    
    ; Добавляем кнопку - ПРАВИЛЬНЫЙ СИНТАКСИС
    (setq newButton (vla-AddToolbarButton 
        myToolbar          ; Панель инструментов
        ""                 ; Позиция (пусто - в конец)
        "MyButton"         ; Внутреннее имя
        "Моя кнопка"       ; Отображаемое имя
        "Моя пользовательская кнопка" ; Описание
        "^C^C(c:MyCommand)" ; Макрос (^C^C для отмены текущих команд)
    ))
    
    ; Делаем панель видимой
    (vla-put-Visible myToolbar :vlax-true)
    
    (princ "\nКнопка создана успешно!")
    (princ)
)

(defun c:MyCommand ()
    (alert "Моя кнопка работает! Команда выполнена успешно.")
    (princ)
)




(defun c:CreateSimpleToolbar ()
    ; Создаем панель через CUI команды
    (command "_.CUI")
    
    (princ "\nВручную создайте панель в диалоговом окне CUI:")
    (princ "\n1. Правая кнопка на 'Панели инструментов'")
    (princ "\n2. Выберите 'Новая панель инструментов'")
    (princ "\n3. Назовите 'MyToolbar'")
    (princ "\n4. Перетащите команды на панель")
    (princ "\n5. Нажмите OK")
    
    (princ)
)


(defun c:CreateToolbarViaCUI ()
    ; Этот код создает CUIx файл который можно загрузить
    (setq cuiFile (strcat (getvar "ROAMABLEROOTPREFIX") "Support\\MyToolbar.cuix"))
    
    (setq fp (open cuiFile "w"))
    (if fp
        (progn
            (write-line "<?xml version=\"1.0\" encoding=\"utf-8\"?>" fp)
            (write-line "<CUI>" fp)
            (write-line "  <CUIData>" fp)
            (write-line "    <Toolbars>" fp)
            (write-line "      <Toolbar name=\"MyToolbar\">" fp)
            (write-line "        <Button name=\"MyButton\">" fp)
            (write-line "          <Label>Моя кнопка</Label>" fp)
            (write-line "          <Command>^C^C(c:MyCommand)</Command>" fp)
            (write-line "        </Button>" fp)
            (write-line "      </Toolbar>" fp)
            (write-line "    </Toolbars>" fp)
            (write-line "  </CUIData>" fp)
            (write-line "</CUI>" fp)
            (close fp)
            (princ (strcat "\nФайл CUI создан: " cuiFile))
        )
        (princ "\nОшибка создания файла!")
    )
    (princ)
)




(defun c:CreateToolbarV3 ()
    (vl-load-com)
    
    (setq acad (vlax-get-acad-object))
    
    ; Пытаемся создать через разные методы
    (if (setq menuGroup (vl-catch-all-apply 'vla-Item (list (vla-get-MenuGroups acad) 0)))
        (progn
            (setq toolbars (vla-get-Toolbars menuGroup))
            
            ; Создаем пустую панель
            (setq newToolbar (vla-Add toolbars "MyAutoToolbar"))
            
            ; Пытаемся добавить кнопку разными способами
            (if (vl-catch-all-error-p 
                 (vl-catch-all-apply 'vla-AddToolbarButton 
                    (list newToolbar "" "TestButton" "Тест" "Тестовая кнопка" "_.LINE ")))
                (princ "\nНе удалось добавить кнопку, но панель создана")
                (princ "\nКнопка добавлена!")
            )
            
            (vla-put-Visible newToolbar :vlax-true)
            (princ "\nПанель создана и показана!")
        )
        (princ "\nНе удалось получить доступ к меню!")
    )
    (princ)
)






(defun c:CreateCUIFile ()
    ; Создаем CUI файл который можно загрузить
    (setq supportPath (getvar "ROAMABLEROOTPREFIX"))
    (setq cuiPath (strcat supportPath "Support\\MyCustomTools.cuix"))
    
    ; Создаем простой CUI файл
    (setq fp (open cuiPath "w"))
    (if fp
        (progn
            (write-line "<?xml version=\"1.0\" encoding=\"utf-8\"?>" fp)
            (write-line "<CUI xmlns=\"http://www.autodesk.com/schemas/AutoCAD/2010/CUI\">" fp)
            (write-line "  <CUIData>" fp)
            (write-line "    <Toolbars>" fp)
            (write-line "      <Toolbar name=\"MyToolbar\">" fp)
            (write-line "        <ToolbarButton name=\"MyLineButton\">" fp)
            (write-line "          <Name>Моя линия</Name>" fp)
            (write-line "          <Command>MyLineCommand</Command>" fp)
            (write-line "        </ToolbarButton>" fp)
            (write-line "        <ToolbarButton name=\"MyCircleButton\">" fp)
            (write-line "          <Name>Мой круг</Name>" fp)
            (write-line "          <Command>MyCircleCommand</Command>" fp)
            (write-line "        </ToolbarButton>" fp)
            (write-line "      </Toolbar>" fp)
            (write-line "    </Toolbars>" fp)
            (write-line "  </CUIData>" fp)
            (write-line "</CUI>" fp)
            (close fp)
            
            (princ (strcat "\nCUI файл создан: " cuiPath))
            (princ "\nЗагрузите его через команду CUI -> Загрузить частичный файл")
        )
        (princ "\nОшибка создания файла!")
    )
    (princ)
)