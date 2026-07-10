;;;----------------------------------->BREAK1<-------------------------------------;;;
;;;                       Команда разбиения отрезка на два                         ;;;
;;;                           BREAK1.lsp Version 1.1                               ;;;
;;;                          Автор: Протасов Георгий                               ;;;
;;; Программа разбивает отрезок на два в заданной точке                            ;;;
;;;--------------------------------------------------------------------------------;;;

(DEFUN BREAK1 ( / en ed1 ed2 pnt
      cmdecho-save error-save)
   (SETQ error-save *error*
      cmdecho-save (GETVAR "CMDECHO")
      );SETQ
   (DEFUN *error* (msg)
      (IF  error-save (SETQ *error* error-save))
      (IF msg (PRINC "\nВыполнение функции прервано "))
      ;; Восстановление значений системных переменных
      (SETVAR "CMDECHO" cmdecho-save)
      (IF (BOUNDP 'en) (REDRAW en 4))
      (PRINC)
      );DEFUN
   (SETVAR "CMDECHO" 0)
   (COMMAND "_.undo" "_begin")
   (SETQ en (CAR (ENTSEL "\nВыберите объект")))
   (WHILE (NULL en)
      (SETQ en (CAR (ENTSEL "\nВыберите объект")))
      );WHILE
   (REDRAW en 3)
   (INITGET 1)
   (SETQ pnt (GETPOINT "\nВыберите точку"))
   (COMMAND "_.break" en pnt pnt)
   (COMMAND "_.undo" "_end")
   (SETVAR "CMDECHO" cmdecho-save)
   (SETQ *error* error-save)
   (PRINC)
   );DEFUN

(IF (OR (NULL C:BREAK1)
      (NOT (LISTP C:BREAK1))
      );OR
   (DEFUN C:BREAK1 ()
      (BREAK1)
      );DEFUN
   );IF
(PRINC "\nBREAK1.lsp загружен... ")
(PRINC "\nДобавлена команда BREAK1...")
(PRINC)

