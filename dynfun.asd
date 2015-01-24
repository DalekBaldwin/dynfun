;;;; dynfun.asd

(defpackage :dynfun-system
  (:use :cl :asdf))
(in-package :dynfun-system)

(defsystem :dynfun
  :name "dynfun"
  :serial t
  :components
  ((:static-file "dynfun.asd")
   (:module :src
            :components ((:file "package")
                         (:file "dynfun" :depends-on ("package")))))
  :depends-on (:alexandria))

(defsystem :dynfun-test
  :name "dynfun-test"
  :serial t
  :components
  ((:module :test
            :components ((:file "package")
                         (:file "dynfun-test" :depends-on ("package")))))
  :depends-on (:dynfun :stefil :lisp-unit))
