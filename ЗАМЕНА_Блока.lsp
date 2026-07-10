(defun c:ЗАМЕНА(/ ACTDOC COPOBJ ERRCOUNT EXTLST
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
      (princ "\nВыберите объекты, которые нужно заменить ")
      (setq extSet(ssget))
      ); end progn
    ); end if
  (if(not extSet)
    (princ "\nDistination objects isn't selected!")
    ); end if
  (if
    (and
    extSet
    (setq toObj(entsel "\nУкажите объект-образец "))
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
     (vla-put-Layer copObj curLay)
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
  ); end of c:ЗАМЕНА