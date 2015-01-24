(in-package #:dynfun)

(defvar *dynsyms* (make-hash-table :test #'equal))

(defmacro get-dynsym (fname) `(gethash ,fname *dynsyms*))

(defun make-dynsym (fname)
  (setf (get-dynsym fname) (make-symbol (format nil "*~A*" fname))))

(defmacro ensure-dynsym (fname default)
  (with-gensyms (sym)
    `(let ((,sym (get-dynsym ,fname)))
       (if ,sym ,sym ,default))))

(defun ensure-dynfun-form (fname &rest rest)
  (let ((dynsym (ensure-dynsym fname (make-dynsym fname))))
    `(progn (setf (get-dynsym ',fname) ',dynsym)
            (defparameter ,dynsym
              ,(if rest
                   `(lambda ,@rest)
                   `(if (fboundp ',fname)
                        (fdefinition ',fname)
                        (lambda (&rest args)
                          (cerror "Retry applying ~A to ~A."
                                  "Undefined dynamic function ~A called with arguments ~A."
                                  ',fname args)
                          (apply ',fname args)))))
            (defun ,fname (&rest args) (apply ,dynsym args)))))

(defmacro defdynfun (fname args &body body)
  (apply #'ensure-dynfun-form fname args body))

(defmacro redefdynfun (fname) (ensure-dynfun-form fname))


(defun get-defined-dynsym (fname)
  (ensure-dynsym fname (progn (cerror "Make ~A a dynamic function."
                                      "Function ~A is not dynamic."
                                      fname)
                              (eval `(redefdynfun ,fname))
                              (get-dynsym fname))))

(defmacro dflet1 ((fname (&rest args) &body funbody) &body dflbody)
  (let ((dynsym (get-defined-dynsym fname)))
    (with-gensyms (orgfun orgargs newargs)
      `(let* ((,orgfun ,dynsym)
              (,dynsym (lambda (&rest ,orgargs)
                         (flet ((call-next-function (&rest ,newargs)
                                  (apply ,orgfun (if ,newargs ,newargs ,orgargs))))
                           (destructuring-bind ,args ,orgargs ,@funbody)))))
         (declare (ignorable ,orgfun))
         ,@dflbody))))

(defmacro dflet ((&rest decls) &body body)
  (reduce (lambda (decl result) `(dflet1 ,decl ,result)) decls
          :initial-value `(progn ,@body) :from-end t))

(defmacro multidflet ((functions args-sym &body def)
                      &body body)
  `(dflet ,(mapcar
            (lambda (function)
              `(,function (&rest ,args-sym) ,@def))
            functions)
     ,@body))
