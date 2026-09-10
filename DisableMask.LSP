(defun c:DisableMask (/ ss i ent obj)
  ;; Отключение маскировки всех объектов Wipeout в чертеже
  (setq ss (ssget "X" '((0 . "WIPEOUT"))))
  
  (if ss
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (setq ent (ssname ss i))
        (setq obj (vlax-ename->vla-object ent))
        
        ;; Отключаем видимость wipeout
        (vla-put-visible obj :vlax-false)
        
        (setq i (1+ i))
      )
      (princ "\nМаскировка Wipeout отключена.")
    )
    (princ "\nОбъекты Wipeout не найдены.")
  )
  
  ;; Отключение фона у текста MText
  (setq ss (ssget "X" '((0 . "MTEXT"))))
  
  (if ss
    (progn
      (setq i 0)
      (repeat (sslength ss)
        (setq ent (ssname ss i))
        (setq obj (vlax-ename->vla-object ent))
        
        ;; Проверяем наличие фона и отключаем его
        (if (= (vla-get-backgroundfill obj) :vlax-true)
          (vla-put-backgroundfill obj :vlax-false)
        )
        
        (setq i (1+ i))
      )
      (princ "\nФон у MText отключен.")
    )
  )
  
  (princ)
)

;; Загрузка Visual LISP расширений
(vl-load-com)

(princ "\nКоманда DisableMask загружена. Введите DisableMask для отключения маскировки.")
(princ)