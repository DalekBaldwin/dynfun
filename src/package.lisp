(in-package #:cl-user)

(defpackage #:dynfun
  (:use #:cl #:alexandria)
  (:export #:defdynfun
           #:redefdynfun
           #:call-next-function
           #:dflet
           #:multidflet))

(in-package #:dynfun)

(defparameter *system-directory*
  (make-pathname
   :directory 
   (pathname-directory
    (asdf:system-definition-pathname "dynfun"))))
