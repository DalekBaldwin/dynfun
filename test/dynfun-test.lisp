(in-package #:dynfun-test)

(in-root-suite)

(defsuite* test-all)

(defun run-all-tests ()
  (format t "|~%") ;; "|" needed to avoid screwing up colors in SLIME REPL
  (test-all)
  (let ((results
         (run-tests :all :dynfun-test)))
    (print-errors results)
    (print-failures results)))

(define-test test-blah
  ;; need to have at least one lisp-unit test to not barf in REPL
  (assert-expands
   (blarf)
   (blarf)))

(defgeneric fib (x)
  (:method ((x (eql 0))) 1)
  (:method ((x (eql 1))) 1)
  (:method (x) (+ (fib (- x 1))
                  (fib (- x 2)))))

(redefdynfun fib)

(deftest test-fib-memo ()
  (let (memo)
    (dflet ((fib (x) (let ((result (cdr (assoc x memo))))
                       (or result
                           (prog1
                               (setf result (call-next-function))
                             (setf memo (acons x result memo)))))))
      (is (= (fib 4) 5))
      (is (equal memo '((4 . 5) (3 . 3) (2 . 2) (0 . 1) (1 . 1)))))))
