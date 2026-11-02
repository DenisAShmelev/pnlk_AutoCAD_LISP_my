;; Способ 2. Самый быстрый — готовый скрипт AutoLISP
;; 
;; Если чертеж огромный, эффективнее всего применить короткий LISP-скрипт. Он мгновенно выберет все фальшивые размеры на чертеже.
;; 1. Скопируйте этот код:lisp
;; (sssetfirst nil (ssget "X" '((0 . "DIMENSION") (-4 . "<NOT") (1 . "") (-4 . "NOT>"))))
;; Используйте код с осторожностью.
;; 2. Вставьте его прямо в командную строку AutoCAD и нажмите Enter.
;; 3. Все перебитые размеры на чертеже сразу окажутся выделенными. Теперь вы можете покрасить их в другой цвет через панель свойств или перенести на отдельный слой для проверки.

;; ^C^C(if (not c:FindOverwrittenDimentions)(load "FindOverwrittenDimentions.lsp"));FindOverwrittenDimentions


(defun c:FindOverwrittenDimentions ( / ss i ent pt ans)
  (if (setq ss (ssget "X" '((0 . "DIMENSION")
                            (-4 . "<NOT") (1 . "") (-4 . "NOT>"))))
    (progn
      ;; --- запрос пользователю ---
      (initget "Да Нет _Yes No")
      (setq ans (getkword "\nПостроить линии от точки (0,0,0) к найденным размерам на слое Defpoints? [Да/Нет] <Нет>: "))

      (if (or (= ans "Да") (= ans "Yes"))
        (progn
          ;; создаём слой Defpoints, если его нет
          (if (not (tblsearch "LAYER" "Defpoints"))
            (entmake '((0 . "LAYER")
                       (100 . "AcDbSymbolTableRecord")
                       (100 . "AcDbLayerTableRecord")
                       (2 . "Defpoints")
                       (70 . 0)
                       (62 . 7)
                       (6 . "Continuous")))
          )

          (setq i 0)
          (repeat (sslength ss)
            (setq ent (ssname ss i))
            (setq pt  (cdr (assoc 10 (entget ent))))   ; точка вставки размера (WCS)

            (entmake (list '(0 . "LINE")
                           '(100 . "AcDbEntity")
                           '(8 . "Defpoints")
                           '(100 . "AcDbLine")
                           (cons 10 '(0.0 0.0 0.0))
                           (cons 11 pt)))

            (setq i (1+ i))
          )
          (princ (strcat "\nПостроено линий: " (itoa (sslength ss))))
        )
        (princ "\nЛинии не строились.")
      )
      ;; --- конец запроса ---

      (sssetfirst nil ss)
      (princ (strcat "\nНайдено перебитых размеров: " (itoa (sslength ss))))
    )
    (princ "\nПеребитых размеров не найдено.")
  )
  (princ)
)

(defun c:НайтиПеребитыеРазмеры () (c:FindOverwrittenDimentions))