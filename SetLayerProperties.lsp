; SetLayerProperties.lsp
(defun c:SetLayerProperties (/ layerTable layerDef linetypeName linetypeFile)
  ;; Проверяем, загружен ли тип линии ACAD_ISO04W100
  (setq linetypeName "ACAD_ISO04W100")
  (if (not (tblsearch "LTYPE" linetypeName)) ; Если тип линии не найден
    (progn
      (setq linetypeFile (findfile "acad.lin")) ; Ищем файл acad.lin
      (if linetypeFile
        (progn
          (command "_.LINETYPE" "_LOAD" linetypeName linetypeFile "") ; Загружаем тип линии
          (princ (strcat "\nТип линии '" linetypeName "' загружен из файла acad.lin."))
        )
        (princ "\nФайл acad.lin не найден. Убедитесь, что стандартная библиотека AutoCAD доступна.")
      )
    )
  )

  ;; Устанавливаем свойства для слоя 2
  (setq layerTable (tblnext "LAYER" T)) ; Начинаем поиск в таблице слоёв
  (while layerTable
    (if (= (cdr (assoc 2 layerTable)) "2") ; Проверяем, является ли слой "2"
      (progn
        ; Устанавливаем цвет слоя 2 = 140
        (setq layerDef (tblobjname "LAYER" "2")) ; Получаем объект слоя
        (entmod (subst '(62 . 140) (assoc 62 (entget layerDef)) (entget layerDef))) ; Меняем цвет
        ; Устанавливаем тип линии ACAD_ISO04W100
        (entmod (subst '(6 . "ACAD_ISO04W100") (assoc 6 (entget layerDef)) (entget layerDef))) ; Меняем тип линии
        (princ "\nСвойства слоя '2' изменены: цвет = 140, тип линии = ACAD_ISO04W100.")
      )
    )
    (setq layerTable (tblnext "LAYER")) ; Переходим к следующему слою
  )
  (command "_.REGEN") ; Регенерация чертежа
  (princ)
)


; макрос для AutoCAD который будет запускаться при нажатии кнопки. Задавать цвет слоя 2 равным номеру 140. Применять для слоя 2 Тип линии ACAD_ISO04W100

;1. Создайте LISP-скрипт
;Сохраните следующий код в файле с расширением .lsp (например, SetLayerProperties.lsp):

;2. Настройте кнопку в AutoCAD
;    Откройте CUI (через команду CUI).
;    Создайте новую команду:
;        В разделе Customize выберите вашу панель.
;        Нажмите New Command.
;    Укажите параметры:
;        Name: Изменить свойства слоя 2.
;        Macro (вставьте строку):
;        ^C^C(if (not c:SetLayerProperties)(load "SetLayerProperties.lsp"));SetLayerProperties
;        Убедитесь, что путь к SetLayerProperties.lsp указан правильно (или поместите файл в папку поддержки AutoCAD).
;    Перетащите новую команду на панель инструментов.
;
;3. Использование
;    1. Нажмите созданную кнопку.
;    2. Программа автоматически:
;        Установит цвет слоя 2 равным 140.
;        Применит тип линии ACAD_ISO04W100 для слоя 2.
;    3. Чертеж автоматически регенерируется.
;
;Примечания:
;    Убедитесь, что тип линии ACAD_ISO04W100 загружен в чертёж. Если его нет, загрузите его через диалог "Менеджер типов линий" (LINETYPE).
;    Цвет 140 соответствует определённому цвету в AutoCAD (обычно это оттенок серого). Если цвет 140 отсутствует в вашей палитре, AutoCAD автоматически подберёт ближайший доступный цвет.
;Теперь вы можете быстро изменять свойства слоя 2 с помощью одной кнопки! 🛠️