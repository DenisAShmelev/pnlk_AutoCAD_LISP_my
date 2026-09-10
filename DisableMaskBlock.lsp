(defun c:DisableMaskBlock (/ ss i ent obj)
  ;; Отключение маскировки всех объектов Wipeout в чертеже (включая блоки)
  
  ;; Функция для обработки объектов в пространстве модели/листа
  (defun process-objects (ss / i ent obj)
    (if ss
      (progn
        (setq i 0)
        (repeat (sslength ss)
          (setq ent (ssname ss i))
          (setq obj (vlax-ename->vla-object ent))
          
          ;; Обработка Wipeout
          (if (= (vla-get-objectname obj) "AcDbWipeout")
            (vla-put-visible obj :vlax-false)
          )
          
          ;; Обработка MText с фоном
          (if (= (vla-get-objectname obj) "AcDbMText")
            (if (= (vla-get-backgroundfill obj) :vlax-true)
              (vla-put-backgroundfill obj :vlax-false)
            )
          )
          
          (setq i (1+ i))
        )
      )
    )
  )
  
  ;; Функция для рекурсивной обработки блоков
  (defun process-blocks (block-name / block-def ent obj)
    (setq block-def (tblsearch "BLOCK" block-name))
    (if block-def
      (progn
        ;; Получаем определение блока
        (setq block-def (vla-item (vla-get-blocks (vla-get-activedocument (vlax-get-acad-object))) block-name))
        
        ;; Проходим по всем объектам в определении блока
        (vlax-for ent block-def
          (setq obj ent)
          
          ;; Обработка Wipeout в блоке
          (if (= (vla-get-objectname obj) "AcDbWipeout")
            (vla-put-visible obj :vlax-false)
          )
          
          ;; Обработка MText с фоном в блоке
          (if (= (vla-get-objectname obj) "AcDbMText")
            (if (= (vla-get-backgroundfill obj) :vlax-true)
              (vla-put-backgroundfill obj :vlax-false)
            )
          )
        )
      )
    )
  )
  
  ;; Загрузка Visual LISP расширений
  (vl-load-com)
  
  ;; Обрабатываем объекты в пространстве модели
  (princ "\nОбработка объектов в пространстве модели...")
  (setq ss (ssget "X" '((0 . "WIPEOUT,MTEXT"))))
  (process-objects ss)
  
  ;; Обрабатываем все блоки в чертеже
  (princ "\nОбработка блоков...")
  (setq blk-table (tblnext "BLOCK" T))
  (while blk-table
    (setq blk-name (cdr (assoc 2 blk-table)))
    ;; Пропускаем внешние ссылки и специальные блоки
    (if (and blk-name 
             (/= (substr blk-name 1 1) "*")
             (/= (substr blk-name 1 4) "XREF"))
      (process-blocks blk-name)
    )
    (setq blk-table (tblnext "BLOCK"))
  )
  
  (princ "\nМаскировка Wipeout и фон MText отключены (включая блоки).")
  (princ)
)

(princ "\nКоманда DisableMask загружена. Введите DisableMask для отключения маскировки.")
(princ)