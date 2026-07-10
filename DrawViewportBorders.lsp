(defun c:OutlineViewports (/ ss vp vpList vpExtents)
  ;; Выбор всех видовых экранов на текущем листе
  (setq ss (ssget "_X" '((0 . "VIEWPORT"))))
  
  (if ss
    (progn
      ;; Перебор всех видовых экранов
      (setq vpList (vl-remove-if 'listp (mapcar 'cadr (ssnamex ss))))
      (foreach vp vpList
        ;; Получение границ видового экрана
        (setq vpExtents (vla-get-displaylocked (vlax-ename->vla-object vp)))
        (if (not vpExtents)
          (progn
            ;; Создание прямоугольника вокруг видового экрана
            (command "_.RECTANG" "_non" (vlax-curve-getStartPoint vp) "_non" (vlax-curve-getEndPoint vp))
          )
        )
      )
      (princ (strcat "\nОбработано видовых экранов: " (itoa (length vpList))))
    )
    (princ "\nВидовые экраны не найдены.")
  )
  (princ)
)