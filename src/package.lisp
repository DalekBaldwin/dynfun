(in-package :cl)

(defpackage :dynfun
  (:use :cl :alexandria)
  (:export #:defdynfun
           #:redefdynfun
           #:call-next-function
           #:dflet
           #:multidflet))

(in-package :dynfun)

(defparameter *system-directory*
  (make-pathname
   :directory 
   (slot-value
    (asdf:system-definition-pathname :dynfun)
    'directory)))
