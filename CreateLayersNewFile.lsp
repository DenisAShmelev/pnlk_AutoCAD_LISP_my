;; ^C^C(if (not c:CreateLayers)(load "CreateLayersNewFile.lsp"));CreateLayers


(defun c:CreateLayers (/ linetypeName linetypeFile)
;; Проверяем, загружен ли тип линии "GOST2.303 5"
  (setq linetypeName "GOST2.303 5")
  (if (not (tblsearch "LTYPE" linetypeName)) ; Если тип линии не найден
    (progn
      (setq linetypeFile (findfile "GOST2.303.lin")) ; Ищем файл GOST2.303.lin
      (if linetypeFile
        (progn
          (command "_.LINETYPE" "_LOAD" linetypeName linetypeFile "") ; Загружаем тип линии
          (princ (strcat "\nТип линии '" linetypeName "' загружен из файла GOST2.303.lin."))
        )
		(progn
        (princ "\nФайл GOST2.303.lin не найден. Убедитесь, что файл доступен.")
		)
      )
    )
	;; Если тип линии уже загружен, выводим соответствующее сообщение
    (princ (strcat "\nТип линии '" linetypeName "' уже загружен."))
  )
  (princ) ;; Очищаем командную строку
  
  
  
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
  (princ) ;; Очищаем командную строку

;; Проверяем существует ли слой. Если существует, то изменяем свойства на заданные, если не существует, то создаём слой с заданными свойствами.

;; Изменяем свойства слоя "Существующий"
(if (tblsearch "LAYER" "Существующий") ; Проверяем, существует ли слой "Существующий"
  (progn
    (setq layerDef (tblobjname "LAYER" "Существующий")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 123) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии на ACAD_ISO04W100
    (entmod (subst '(6 . "ACAD_ISO04W100") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 0) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.09
    (entmod (subst '(370 . 9) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Существующий' изменён: цвет = 123, тип линии = ACAD_ISO04W100, вес линии = 0.09, слой не печатаемый.")
  )
  (princ "\nСлой 'Существующий' не найден.")
)
(princ) ;; Очищаем командную строку

;; Изменяем свойства слоя "Пунктир"
(if (tblsearch "LAYER" "Пунктир") ; Проверяем, существует ли слой "Пунктир"
  (progn
    (setq layerDef (tblobjname "LAYER" "Пунктир")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 125) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии на ГОСТ 2.303 4
    (entmod (subst '(6 . "ГОСТ 2.303 4") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.09
    (entmod (subst '(370 . 9) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Пунктир' изменён: цвет = 123, тип линии = ГОСТ 2.303 4, вес линии = 0.09.")
  )
  (progn
    (princ "\nСлой 'Пунктир' не найден.")
    (command "_.LAYER" "_M" "Пунктир" "_C" "81" "Пунктир" "_L" "ГОСТ 2.303 4" "Пунктир" "_LW" "0.09" "Пунктир" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'Пунктир' создан: цвет = 81, тип линии = ГОСТ 2.303 4, вес линии = 0.09.")
  )
)
(princ) ;; Очищаем командную строку

;; Изменяем свойства слоя "Оси"
(if (tblsearch "LAYER" "Оси") ; Проверяем, существует ли слой "Оси"
  (progn
    (setq layerDef (tblobjname "LAYER" "Оси")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 187) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "ГОСТ 2.303 5") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.09
    (entmod (subst '(370 . 9) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Оси' изменён: цвет = 187, тип линии = ГОСТ 2.303 5, вес линии = 0.09.")
  )
  (progn
    (princ "\nСлой 'Оси' не найден.")
    (command "_.LAYER" "_M" "Оси" "_C" "187" "Оси" "_L" "ГОСТ 2.303 5" "Оси" "_LW" "0.09" "Оси" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'Оси' создан: цвет = 187, тип линии = ГОСТ 2.303 5, вес линии = 0.09.")
  )
)
(princ) ;; Очищаем командную строку

;; Изменяем свойства слоя "Основная"
(if (tblsearch "LAYER" "Основная") ; Проверяем, существует ли слой "Основная"
  (progn
    (setq layerDef (tblobjname "LAYER" "Основная")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 150) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.3
    (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Основная' изменён: цвет = 150, тип линии = Continuous, вес линии = 0.09.")
  )
  (progn
    (princ "\nСлой 'Основная' не найден.")
    (command "_.LAYER" "_M" "Основная" "_C" "150" "Основная" "_LW" "0.3" "Основная" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'Основная' создан: цвет = 150, тип линии = Continuous, вес линии = 0.3.")
  )
)
(princ) ;; Очищаем командную строку

;; Изменяем свойства слоя "Основная 2"
(if (tblsearch "LAYER" "Основная 2") ; Проверяем, существует ли слой "Основная 2"
  (progn
    (setq layerDef (tblobjname "LAYER" "Основная 2")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 11) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.3
    (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Основная 2' изменён: цвет = 11, тип линии = Continuous, вес линии = 0.3.")
  )
  (progn
    (princ "\nСлой 'Основная 2' не найден.")
    (command "_.LAYER" "_M" "Основная 2" "_C" "11" "Основная 2" "_LW" "0.3" "Основная 2" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'Основная 2' создан: цвет = 11, тип линии = Continuous, вес линии = 0.3.")
  )
)
(princ) ;; Очищаем командную строку

;; Изменяем свойства слоя "Оформление"
(if (tblsearch "LAYER" "Оформление") ; Проверяем, существует ли слой "Оформление"
  (progn
    (setq layerDef (tblobjname "LAYER" "Оформление")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 241) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.13
    (entmod (subst '(370 . 13) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Оформление' изменён: цвет = 241, тип линии = Continuous, вес линии = 0.13.")
  )
  (progn
    (princ "\nСлой 'Оформление' не найден.")
    (command "_.LAYER" "_M" "Оформление" "_C" "241" "Оформление" "_LW" "0.13" "Оформление" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'Оформление' создан: цвет = 241, вес линии = 0.13.")
  )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "ОформлениеБлокБлок"
(if (tblsearch "LAYER" "ОформлениеБлок") ; Проверяем, существует ли слой "ОформлениеБлок"
  (progn
    (setq layerDef (tblobjname "LAYER" "ОформлениеБлок")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 245) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.13
    (entmod (subst '(370 . 13) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'ОформлениеБлок' изменён: цвет = 245, тип линии = Continuous, вес линии = 0.13.")
  )
  (progn
    (princ "\nСлой 'ОформлениеБлок' не найден.")
    (command "_.LAYER" "_M" "ОформлениеБлок" "_C" "245" "ОформлениеБлок" "_LW" "0.13" "ОформлениеБлок" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'ОформлениеБлок' создан: цвет = 245, вес линии = 0.13.")
  )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "Размеры"
(if (tblsearch "LAYER" "Размеры") ; Проверяем, существует ли слой "Размеры"
  (progn
    (setq layerDef (tblobjname "LAYER" "Размеры")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 40) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.13
    (entmod (subst '(370 . 13) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Размеры' изменён: цвет = 40, тип линии = Continuous, вес линии = 0.13.")
  )
  (progn
    (princ "\nСлой 'Размеры' не найден.")
    (command "_.LAYER" "_M" "Размеры" "_C" "40" "Размеры" "_LW" "0.13" "Размеры" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'м' создан: цвет = 40, вес линии = 0.13.")
  )
)
(princ) ;; Очищаем командную строку

;; Изменяем свойства слоя "Текст"
(if (tblsearch "LAYER" "Текст") ; Проверяем, существует ли слой "Текст"
  (progn
    (setq layerDef (tblobjname "LAYER" "Текст")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 140) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.13
    (entmod (subst '(370 . 15) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Текст' изменён: цвет = 40, тип линии = Continuous, вес линии = 0.15.")
  )
  (progn
    (princ "\nСлой 'Текст' не найден.")
    (command "_.LAYER" "_M" "Текст" "_C" "140" "Текст" "_LW" "0.15" "Текст" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'Текст' создан: цвет = 140, вес линии = 0.15.")
  )
)
(princ) ;; Очищаем командную строку

;; Изменяем свойства слоя "Тонкая"
(if (tblsearch "LAYER" "Тонкая") ; Проверяем, существует ли слой "Тонкая"
  (progn
    (setq layerDef (tblobjname "LAYER" "Тонкая")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 140) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.13
    (entmod (subst '(370 . 15) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Тонкая' изменён: цвет = 40, тип линии = Continuous, вес линии = 0.15.")
  )
  (progn
    (princ "\nСлой 'Тонкая' не найден.")
    (command "_.LAYER" "_M" "Тонкая" "_C" "140" "Тонкая" "_LW" "0.15" "Тонкая" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'Тонкая' создан: цвет = 140, вес линии = 0.15.")
  )
)
(princ) ;; Очищаем командную строку

;; Изменяем свойства слоя "Штриховка"
(if (tblsearch "LAYER" "Штриховка") ; Проверяем, существует ли слой "Штриховка"
  (progn
    (setq layerDef (tblobjname "LAYER" "Штриховка")) ; Получаем объект слоя
    ;; Меняем цвет на 123
    (entmod (subst '(62 . 17) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.13
    (entmod (subst '(370 . 9) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
    (princ "\nСлой 'Штриховка' изменён: цвет = 17, тип линии = Continuous, вес линии = 0.09.")
  )
  (progn
    (princ "\nСлой 'Штриховка' не найден.")
    (command "_.LAYER" "_M" "Штриховка" "_C" "17" "Штриховка" "_LW" "0.09" "Штриховка" "") ; Создаём слой и задаём свойства
    (princ "\nСлой 'Штриховка' создан: цвет = 17, вес линии = 0.09.")
  )
)
(princ) ;; Очищаем командную строку  

;; Изменяем свойства слоя "Вспомогательные"
(if (tblsearch "LAYER" "Вспомогательные") ; Проверяем, существует ли слой "Вспомогательные"
    (progn
      (setq layerDef (tblobjname "LAYER" "Вспомогательные")) ; Получаем объект слоя
      ;; Меняем цвет на 30
      (entmod (subst '(62 . 30) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 0) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.15
      (entmod (subst '(370 . 15) (assoc 370 (entget layerDef)) (entget layerDef))) ; 15 = 0.15 мм
      (princ "\nСлой 'Вспомогательные' изменён: цвет = 30, тип линии = Continuous, вес линии = 0.15, слой не печатаемый.")
    )
    (progn
	  (princ "\nСлой 'Вспомогательные' не найден.")
      (command "_.LAYER" "_M" "Вспомогательные" "_C" "30" "Вспомогательные" "_LW" "0.15" "Вспомогательные" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'Вспомогательные' создан: цвет = 30, вес линии = 0.15.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "Швы"
(if (tblsearch "LAYER" "Швы") ; Проверяем, существует ли слой "Швы"
    (progn
      (setq layerDef (tblobjname "LAYER" "Швы")) ; Получаем объект слоя
      ;; Меняем цвет на 97
      (entmod (subst '(62 . 97) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 13) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'Швы' изменён: цвет = 97, тип линии = Continuous, вес линии = 0.13.")
    )
    (progn
	  (princ "\nСлой 'Швы' не найден.")
      (command "_.LAYER" "_M" "Швы" "_C" "97" "Швы" "_LW" "0.13" "Швы" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'Швы' создан: цвет = 97, вес линии = 0.13.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "Defpoints"
(if (tblsearch "LAYER" "Defpoints") ; Проверяем, существует ли слой "Defpoints"
  (progn
    (setq layerDef (tblobjname "LAYER" "Defpoints")) ; Получаем объект слоя
    ;; Меняем цвет на 251
    (entmod (subst '(62 . 251) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.15 мм (15)
    (entmod (subst '(370 . 15) (assoc 370 (entget layerDef)) (entget layerDef)))
    (princ "\nСлой 'Defpoints' изменён: цвет = 251, тип линии = Continuous, вес линии = 0.15, слой печатаемый.")
  )
  (progn
    ;; Создаём слой и задаём свойства
    (command "_.LAYER" "_M" "Defpoints" "_C" "251" "Defpoints" "_LW" "15" "Defpoints" "")
    ;; Устанавливаем тип линии "Continuous" для нового слоя
    (setq layerDef (tblobjname "LAYER" "Defpoints"))
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	;; Устанавливаем вес линии на 0.15 мм (15)
    (entmod (subst '(370 . 15) (assoc 370 (entget layerDef)) (entget layerDef)))
    (princ "\nСлой 'Defpoints' создан: цвет = 251, вес линии = 0.15, тип линии = Continuous, слой печатаемый.")
  )
)
(princ) ;; Очищаем командную строку 





;; Начало описания слоёв для диаметров

;; Изменяем свойства слоя "диам 6"
(if (tblsearch "LAYER" "диам 6") ; Проверяем, существует ли слой "диам 6"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 6")) ; Получаем объект слоя
      ;; Меняем цвет на 21
      (entmod (subst '(62 . 21) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 6' изменён: цвет = 21, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 6' не найден.")
      (command "_.LAYER" "_M" "диам 6" "_C" "21" "диам 6" "_LW" "0.30" "диам 6" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 6' создан: цвет = 21, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 8"
(if (tblsearch "LAYER" "диам 8") ; Проверяем, существует ли слой "диам 8"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 8")) ; Получаем объект слоя
      ;; Меняем цвет на 108
      (entmod (subst '(62 . 108) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 8' изменён: цвет = 108, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 8' не найден.")
      (command "_.LAYER" "_M" "диам 8" "_C" "108" "диам 8" "_LW" "0.30" "диам 8" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 8' создан: цвет = 108, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 10"
(if (tblsearch "LAYER" "диам 10") ; Проверяем, существует ли слой "диам 10"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 10")) ; Получаем объект слоя
      ;; Меняем цвет на 210
      (entmod (subst '(62 . 210) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 10' изменён: цвет = 210, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 10' не найден.")
      (command "_.LAYER" "_M" "диам 10" "_C" "210" "диам 10" "_LW" "0.30" "диам 10" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 10' создан: цвет = 210, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 12"
(if (tblsearch "LAYER" "диам 12") ; Проверяем, существует ли слой "диам 12"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 12")) ; Получаем объект слоя
      ;; Меняем цвет на 112
      (entmod (subst '(62 . 112) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 12' изменён: цвет = 112, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 12' не найден.")
      (command "_.LAYER" "_M" "диам 12" "_C" "112" "диам 12" "_LW" "0.30" "диам 12" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 12' создан: цвет = 112, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 14"
(if (tblsearch "LAYER" "диам 14") ; Проверяем, существует ли слой "диам 14"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 14")) ; Получаем объект слоя
      ;; Меняем цвет на 114
      (entmod (subst '(62 . 114) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 14' изменён: цвет = 114, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 14' не найден.")
      (command "_.LAYER" "_M" "диам 14" "_C" "114" "диам 14" "_LW" "0.30" "диам 14" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 14' создан: цвет = 114, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 16"
(if (tblsearch "LAYER" "диам 16") ; Проверяем, существует ли слой "диам 16"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 16")) ; Получаем объект слоя
      ;; Меняем цвет на 16
      (entmod (subst '(62 . 16) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 16' изменён: цвет = 16, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 16' не найден.")
      (command "_.LAYER" "_M" "диам 16" "_C" "16" "диам 16" "_LW" "0.30" "диам 16" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 16' создан: цвет = 16, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 18"
(if (tblsearch "LAYER" "диам 18") ; Проверяем, существует ли слой "диам 18"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 18")) ; Получаем объект слоя
      ;; Меняем цвет на 18
      (entmod (subst '(62 . 18) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 18' изменён: цвет = 18, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 18' не найден.")
      (command "_.LAYER" "_M" "диам 18" "_C" "18" "диам 18" "_LW" "0.30" "диам 18" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 18' создан: цвет = 18, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 20"
(if (tblsearch "LAYER" "диам 20") ; Проверяем, существует ли слой "диам 20"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 20")) ; Получаем объект слоя
      ;; Меняем цвет на 120
      (entmod (subst '(62 . 120) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 20' изменён: цвет = 120, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 20' не найден.")
      (command "_.LAYER" "_M" "диам 20" "_C" "120" "диам 20" "_LW" "0.30" "диам 20" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 20' создан: цвет = 120, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 22"
(if (tblsearch "LAYER" "диам 22") ; Проверяем, существует ли слой "диам 22"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 22")) ; Получаем объект слоя
      ;; Меняем цвет на 222
      (entmod (subst '(62 . 222) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 22' изменён: цвет = 222, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 22' не найден.")
      (command "_.LAYER" "_M" "диам 22" "_C" "222" "диам 22" "_LW" "0.30" "диам 22" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 22' создан: цвет = 222, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 25"
(if (tblsearch "LAYER" "диам 25") ; Проверяем, существует ли слой "диам 25"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 25")) ; Получаем объект слоя
      ;; Меняем цвет на 25
      (entmod (subst '(62 . 25) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 25' изменён: цвет = 25, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 25' не найден.")
      (command "_.LAYER" "_M" "диам 25" "_C" "25" "диам 25" "_LW" "0.30" "диам 25" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 25' создан: цвет = 25, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 28"
(if (tblsearch "LAYER" "диам 28") ; Проверяем, существует ли слой "диам 28"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 28")) ; Получаем объект слоя
      ;; Меняем цвет на 128
      (entmod (subst '(62 . 128) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 28' изменён: цвет = 128, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 28' не найден.")
      (command "_.LAYER" "_M" "диам 28" "_C" "128" "диам 28" "_LW" "0.30" "диам 28" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 28' создан: цвет = 128, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 32"
(if (tblsearch "LAYER" "диам 32") ; Проверяем, существует ли слой "диам 32"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 32")) ; Получаем объект слоя
      ;; Меняем цвет на 32
      (entmod (subst '(62 . 32) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 32' изменён: цвет = 32, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 32' не найден.")
      (command "_.LAYER" "_M" "диам 32" "_C" "32" "диам 32" "_LW" "0.30" "диам 32" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 32' создан: цвет = 32, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 36"
(if (tblsearch "LAYER" "диам 36") ; Проверяем, существует ли слой "диам 36"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 36")) ; Получаем объект слоя
      ;; Меняем цвет на 136
      (entmod (subst '(62 . 136) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 36' изменён: цвет = 136, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 36' не найден.")
      (command "_.LAYER" "_M" "диам 36" "_C" "136" "диам 36" "_LW" "0.30" "диам 36" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 36' создан: цвет = 136, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 40"
(if (tblsearch "LAYER" "диам 40") ; Проверяем, существует ли слой "диам 40"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 40")) ; Получаем объект слоя
      ;; Меняем цвет на 40
      (entmod (subst '(62 . 40) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 40' изменён: цвет = 40, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 40' не найден.")
      (command "_.LAYER" "_M" "диам 40" "_C" "40" "диам 40" "_LW" "0.30" "диам 40" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 40' создан: цвет = 40, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "диам 45"
(if (tblsearch "LAYER" "диам 45") ; Проверяем, существует ли слой "диам 45"
    (progn
      (setq layerDef (tblobjname "LAYER" "диам 45")) ; Получаем объект слоя
      ;; Меняем цвет на 45
      (entmod (subst '(62 . 45) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 30) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'диам 45' изменён: цвет = 45, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'диам 45' не найден.")
      (command "_.LAYER" "_M" "диам 45" "_C" "45" "диам 45" "_LW" "0.30" "диам 45" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'диам 45' создан: цвет = 45, вес линии = 0.30.")
    )
)
(princ) ;; Очищаем командную строку 

;; Изменяем свойства слоя "Изменения"
(if (tblsearch "LAYER" "Изменения") ; Проверяем, существует ли слой "Изменения"
    (progn
      (setq layerDef (tblobjname "LAYER" "Изменения")) ; Получаем объект слоя
      ;; Меняем цвет на 10
      (entmod (subst '(62 . 10) (assoc 62 (entget layerDef)) (entget layerDef)))
      ;; Меняем тип линии
      (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
      ;; Устанавливаем слой как "не печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
      (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
	  ;; Устанавливаем вес линии на 0.13
      (entmod (subst '(370 . 15) (assoc 370 (entget layerDef)) (entget layerDef))) ; 9 = 0.09 мм
      (princ "\nСлой 'Изменения' изменён: цвет = 10, тип линии = Continuous, вес линии = 0.30.")
    )
    (progn
	  (princ "\nСлой 'Изменения' не найден.")
      (command "_.LAYER" "_M" "Изменения" "_C" "10" "Изменения" "_LW" "0.15" "Изменения" "") ; Создаём слой и задаём свойства
      (princ "\nСлой 'Изменения' создан: цвет = 10, вес линии = 0.15.")
    )
)
(princ) ;; Очищаем командную строку 



;; Последний созданный слой будет отмечен как текущий.
;; Изменяем свойства слоя "0" 
(if (tblsearch "LAYER" "0") ; Проверяем, существует ли слой "0"
  (progn
    (setq layerDef (tblobjname "LAYER" "0")) ; Получаем объект слоя
    ;; Меняем цвет на белый (7)
    (entmod (subst '(62 . 7) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 1) (assoc 290 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем вес линии на 0.15 мм (15)
    (entmod (subst '(370 . 15) (assoc 370 (entget layerDef)) (entget layerDef)))
    (princ "\nСлой '0' изменён: цвет = белый, тип линии = Continuous, вес линии = 0.15.")
  )
  (progn
    (command "_.LAYER" "_M" "0" "_C" "7" "0" "_LW" "15" "0" "") ; Создаём слой и задаём свойства
    ;; Устанавливаем тип линии "Continuous" для нового слоя
    (setq layerDef (tblobjname "LAYER" "0"))
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    (princ "\nСлой '0' создан: цвет = белый, вес линии = 0.15, тип линии = Continuous.")
  )
)
(princ) ;; Очищаем командную строку



;; Окончание описания слоёв для диаметров

  (setvar "DIMLAYER" "Размеры")
  (setvar "HPLAYER" "Штриховка")
  (CreateLayers)
  
  (command "_.REGEN") ; Регенерация чертежа

  (princ)
)

;; Добавляем еще одну команду на кириллице
(defun c:СоздатьСлои () ;;Название которое хотим вводить на кириллице
  (c:CreateLayers) ;; Какую функцию (обособленную часть программы) будет выполнять программа при вводе названия на кириллице.
)