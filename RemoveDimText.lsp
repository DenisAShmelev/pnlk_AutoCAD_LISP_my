;; ^C^C(if (not c:RemoveDimText)(load "RemoveDimText.lsp"));RemoveDimText

(defun c:RemoveDimText (/ ss i ent edata new_edata count)
  "Удаляет переопределенный текст из выбранных размеров"
  
  (princ "\nВыберите размеры для очистки текста: ")
  (setq ss (ssget '((0 . "*DIMENSION"))))
  
  (if ss
    (progn
      (setq i 0)
      (setq count 0)
      
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (setq edata (entget ent))
        
        ;; Проверяем наличие переопределенного текста (код 1)
        (if (assoc 1 edata)
          (progn
            ;; Заменяем текст на пустую строку
            (setq new_edata (subst '(1 . "") (assoc 1 edata) edata))
            (entmod new_edata)
            (setq count (+ count 1))
          )
        )
        
        (setq i (+ i 1))
      )
      
      (princ (strcat "\nОбработано размеров: " (itoa count)))
    )
    (princ "\nНичего не выбрано.")
  )
  
  (princ)
)

;; Добавляем еще одну команду на кириллице
(defun c:РазмерТекстУдалить ()
  (c:RemoveDimText)
)

;; Добавляем еще одну команду на кириллице
(defun c:РТУ ()
  (c:RemoveDimText)
)