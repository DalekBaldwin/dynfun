(in-package :cl-user)

(defpackage :dynfun-test
  (:use :cl :dynfun :stefil :lisp-unit)
  (:export
   #:test-all
   #:run-all-tests
   ))

(in-package :dynfun-test)

(defparameter *system-directory*
  (make-pathname
   :directory 
   (pathname-directory
    (asdf:system-definition-pathname :dynfun))))
