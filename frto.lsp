;|=============================================================================
*    Функция копирования настроек примитивов
*    Программа меняет набор примитивов на выбранный примитив.
*    Примеры применения:
*    Замена одних блоков другими.
*    Замена точек блоками или окружностями.
*    Замена одних надписей другими.
*    
*    Сначала надо выбрать заменяемые объекты и нажать Enter, затем указать заменяющий объект.
*    Вставка производится в центр ограничевающего (габаритного) прямоугольника старых объектов.
*    Новые объекты вставляются в слои которые к которым пренадлежали старые объекты.
*    Поддерживается предварительный выбор.
=============================================================================|;
(defun c:frto(/ ACTDOC COPOBJ ERRCOUNT EXTLST
       EXTSET FROMCEN LAYCOL MAXPT CURLAY
       MINPT OBJLAY OKCOUNT OLAYST
       SCLAY TOCEN TOOBJ VLAOBJ *ERROR*)

  (vl-load-com)

  (defun *ERROR*(msg)
    (if olaySt
      (vla-put-Lock objLay olaySt)
      ); end if
    (vla-EndUndoMark actDoc)
    (princ)
    ); end of *ERROR*


  (defun GetBoundingCenter(vlaObj / blPt trPt cnPt)
  (vla-GetBoundingBox vlaObj 'minPt 'maxPt)
      (setq blPt(vlax-safearray->list minPt)
      trPt(vlax-safearray->list maxPt)
      cnPt(vlax-3D-point
      (list
            (+(car blPt)(/(-(car trPt)(car blPt))2))
            (+(cadr blPt)(/(-(cadr trPt)(cadr blPt))2))
         0.0
            ); end list
     ); end vlax-3D-point
    ); end setq
  ); end of GetBoundingCenter

  (if(not(setq extSet(ssget "_I")))
    (progn
      (princ "\n+++ Select distination objects and press Enter <- ")
      (setq extSet(ssget))
      ); end progn
    ); end if
  (if(not extSet)
    (princ "\nDistination objects isn't selected!")
    ); end if
  (if
    (and
    extSet
    (setq toObj(entsel "\n+++ Select source object -> "))
    ); and and
    (progn
      (setq actDoc
       (vla-get-ActiveDocument
         (vlax-get-Acad-object))
      layCol
       (vla-get-Layers actDoc)
      extLst
       (mapcar 'vlax-ename->vla-object
                    (vl-remove-if 'listp
                     (mapcar 'cadr(ssnamex extSet))))
      vlaObj(vlax-ename->vla-object(car toObj))
      objLay(vla-Item layCol
          (vla-get-Layer vlaObj))
      olaySt(vla-get-Lock objLay)
      fromCen(GetBoundingCenter vlaObj)
      errCount 0
      okCount 0
      ); end setq
      (vla-StartUndoMark actDoc)
      (foreach obj extLst
  (setq toCen(GetBoundingCenter obj)
        scLay(vla-Item layCol
           (vla-get-Layer obj))
           );end setq
  (if(/= :vlax-true(vla-get-Lock scLay))
    (progn
    (setq curLay(vla-get-Layer obj))
    (vla-put-Lock objLay :vlax-false)
    (setq copObj(vla-copy vlaObj))
    (vla-Move copObj fromCen toCen)
;;;==> Исключили    (vla-put-Layer copObj curLay)
;;;==> Добавили
    (_kpblc-ent-properties-copy obj copObj)
    (vla-put-Lock objLay olaySt)
    (vla-Delete obj)
    (setq okCount(1+ okCount))
    ); end progn
    (setq errCount(1+ errCount))
    ); end if
  ); end foreach
      (princ
  (strcat "\n" (itoa okCount) " were changed. "
    (if(/= 0 errCount)
      (strcat (itoa errCount) " were on locked layer! ")
      ""
      ); end if
    ); end strcat
  ); end princ
      (vla-EndUndoMark actDoc)
      ); end progn
    (princ "\nSource object isn't selected! ")
    ); end if
  (princ)
  ); end of c:frto


;|=============================================================================
*    Функция копирования настроек примитивов
*    Параметры вызова:
*   source   примитив-источник (vla)
*   dest   примитив-получатель (vla)
*    Выполняется копирование всех настроек (кроме точек, координат и т.п.), если
* это возможно. Копирование радиусов дуг и окружностей не выполняется.
*    Контроль и преобразование параметров не выполняется.
*    Примеры вызова:
(_kpblc-ent-properties-copy (vlax-ename->vla-object (car (entsel))) (vlax-ename->vla-object (car (entsel))))
*    URL http://www.arcada.com.ua/forum/viewtopic.php?t=504&start=15
=============================================================================|;
(defun _kpblc-ent-properties-copy (source dest)
  (foreach prop   '("Angle"         "Layer"        "Linetype"
        "LinetypeScale"     "Lineweight"     "Normal"
        "PlotStyleName"     "Thickness"     "Color"
        "Visible"         "Closed"
                  ;|"ConstantWidth" ; не копируется|;
        "Elevation"         "LinetypeGeneration"
        "LinetypeScale" ;|"StartAngle" "EndAngle" ; не копируются|;
        "Alignment"         "Backward"     "Height"
        "ObliqueAngle"      "Rotation"     "ScaleFactor"
        "StyleName"         "TextGenerationFlag"
        "TextHeight"         "UpsideDown"     "AttachmentPoint"
        "BackgroundFill"    "DrawingDirection"  "LineSpacingDistance"
        "LineSpacingFactor" "LineSpacingStyle"  "Width"
        "XScaleFactor"      "YScaleFactor"     "ZScaleFactor"
     ; Viewport
        "ArcSmoothness"     "CustomScale"     "Direction"
        "DisplayLocked"     "GridOn"        "LensLength"
        "ModelView"         "ShadePlot"     "SheetView"
        "SnapBasePoint"     "SnapOn"        "SnapRotationAngle"
        "StandardScale"     "Target"        "TwistAngle"
        "UCSIconAtOrigin"   "UCSIconOn"     "UCSPerViewport"
        "ViewportOn"
        )
    (if   (and (vlax-property-available-p source prop)
        (vlax-property-available-p dest prop t)
        ) ;_ end of and
      (_kpblc-error-catch
   '(lambda ()
      (vlax-put-property dest prop (vlax-get-property source prop))
      ) ;_ end of LAMBDA
   nil
   ) ;_ end of _KPBLC-ERROR-CATCH
      ) ;_ end of if
    ) ;_ end of foreach
  ) ;_ end of defun
;|=============================================================================
*    Оболочка отлова ошибок.
*    Параметры вызова:
*   protected-function   — "защищаемая" функция
*   on-error-function   — функция, выполняемая в случае ошибки
*    URL http://www.arcada.com.ua/forum/viewtopic.php?t=504&start=15
=============================================================================|;
(defun _kpblc-error-catch
       (protected-function on-error-function / catch_error_result)
  (setq catch_error_result (vl-catch-all-apply protected-function))
  (if (and (vl-catch-all-error-p catch_error_result)
      on-error-function
      ) ;_ end of and
    (apply on-error-function
      (list (vl-catch-all-error-message catch_error_result))
      ) ;_ end of APPLY
    catch_error_result
    ) ;_ end of if
  ) ;_ end of defun