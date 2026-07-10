;; Изменяем свойства слоя "0"
(if (tblsearch "LAYER" "0") ; Проверяем, существует ли слой "0"
  (progn
    (setq layerDef (tblobjname "LAYER" "0")) ; Получаем объект слоя
    ;; Меняем цвет на белый (7)
    (entmod (subst '(62 . 256) (assoc 62 (entget layerDef)) (entget layerDef)))
    ;; Меняем тип линии
    (entmod (subst '(6 . "Continuous") (assoc 6 (entget layerDef)) (entget layerDef)))
    ;; Устанавливаем слой как "печатаемый" (флаг 290: 0 = не печатаемый, 1 = печатаемый)
    (entmod (subst '(290 . 0) (assoc 290 (entget layerDef)) (entget layerDef)))
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