(defun c:MergeBlocksA (/ blk1 blk2 newBlkName newBlkDef pt1 objList allPoints minX minY basePoint)
  ;; Функция для объединения двух блоков в один
  (vl-load-com) ; Загрузка библиотеки Visual LISP

  ;; Выбор первого блока
  (setq blk1 (car (entsel "\nВыберите первый блок: ")))
  (if (and blk1 (= (cdr (assoc 0 (entget blk1))) "INSERT"))
    (progn
      ;; Выбор второго блока
      (setq blk2 (car (entsel "\nВыберите второй блок: ")))
      (if (and blk2 (= (cdr (assoc 0 (entget blk2))) "INSERT"))
        (progn
          ;; Запрос имени нового блока
          (setq newBlkName (getstring "\nВведите имя нового блока: "))
          (if (and newBlkName (/= newBlkName ""))
            (progn
              ;; Создание определения нового блока
              (setq newBlkDef (vla-Add (vla-get-Blocks (vla-get-ActiveDocument (vlax-get-acad-object)))
                                       (vlax-3D-point '(0 0 0))
                                       newBlkName))

              ;; Список для хранения объектов и точек
              (setq objList (list))
              (setq allPoints (list))

              ;; Добавление объектов из первого блока
              (foreach obj (vlax-invoke (vlax-ename->vla-object blk1) 'Explode)
                (setq objList (append objList (list obj)))
                (setq bounds (vla-getboundingbox obj 'minPt 'maxPt))
                (setq allPoints (append allPoints (list (vlax-safearray->list minPt))))
                (setq allPoints (append allPoints (list (vlax-safearray->list maxPt)))))

              ;; Добавление объектов из второго блока
              (foreach obj (vlax-invoke (vlax-ename->vla-object blk2) 'Explode)
                (setq objList (append objList (list obj)))
                (setq bounds (vla-getboundingbox obj 'minPt 'maxPt))
                (setq allPoints (append allPoints (list (vlax-safearray->list minPt))))
                (setq allPoints (append allPoints (list (vlax-safearray->list maxPt)))))

              ;; Нахождение минимальных координат (нижняя левая точка)
              (setq minX (apply 'min (mapcar 'car allPoints)))
              (setq minY (apply 'min (mapcar 'cadr allPoints)))
              (setq basePoint (list minX minY 0))

              ;; Смещение объектов относительно новой базовой точки
              (foreach obj objList
                (vla-Move obj (vlax-3D-point basePoint) (vlax-3D-point '(0 0 0))))

              ;; Копирование всех объектов в новое определение блока
              (vla-CopyObjects (vla-get-ActiveDocument (vlax-get-acad-object))
                               (vlax-make-variant
                                 (vlax-safearray-fill
                                   (vlax-make-safearray vlax-vbObject (cons 0 (1- (length objList))))
                                   objList))
                               newBlkDef)

              ;; Вставка нового блока в чертеж
              (setq pt1 (getpoint "\nУкажите точку вставки нового блока: "))
              (vla-InsertBlock (vla-get-ModelSpace (vla-get-ActiveDocument (vlax-get-acad-object)))
                               (vlax-3D-point pt1)
                               newBlkName
                               1.0 1.0 1.0 0.0)

              (princ (strcat "\nНовый блок \"" newBlkName "\" успешно создан и вставлен."))
            )
            (princ "\nИмя блока не может быть пустым.")
          )
        )
        (princ "\nВторой выбранный объект не является блоком.")
      )
    )
    (princ "\nПервый выбранный объект не является блоком.")
  )
  (princ)
)

(princ "\nКоманда MergeBlocks загружена. Используйте команду MERGEBLOCKS в командной строке.")