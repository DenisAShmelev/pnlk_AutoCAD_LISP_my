(defun c:JoinToPolyline ( / ss)
  ;; Загрузка команды, если она еще не загружена
  (if (not (member "PEDIT" (list "PEDIT"))) (arxload "acad" nil))
  
  ;; Запрос выбора объектов у пользователя
  (prompt "\nВыберите линии/дуги/полилинии для объединения: ")
  (if (setq ss (ssget '((0 . "LINE,ARC,LWPOLYLINE"))))
    (progn
      ;; Вызов команды PEDIT в режиме "Multiple"
      (command "_.PEDIT" "_M" ss "" "_Y" "_J" "" "")
      
      ;; Опционально: попытка замкнуть полилинию
      ;; (если она уже является единой полилинией после объединения)
      (command "_.PEDIT" "_L" "_C" "")
      
      (princ "\nГотово. Создана единая полилиния.")
    )
    (princ "\nОбъекты не выбраны.")
  )
  (princ)
)

;; Альтернативный, более надежный вариант с использованием ActiveX
(defun c:JoinToPolyline2 ( / ss obj)
  (prompt "\nВыберите объекты для объединения: ")
  (if (setq ss (ssget '((0 . "LINE,ARC,LWPOLYLINE"))))
    (progn
      ;; Используем команду JOIN, которая в современных версиях работает стабильнее
      (command "_.JOIN" ss "")
      (princ "\nОбъекты объединены.")
    )
  )
  (princ)
)