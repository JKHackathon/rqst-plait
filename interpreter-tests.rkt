#lang racket

;; =============================================================================
;; Interpreter: interpreter-tests.rkt
;; =============================================================================

(require (only-in "interpreter.rkt" eval)
         "support.rkt"
         "test-support.rkt")

; Here, we provide some examples of how to use the testing forms provided in
; "test-support.rkt". You should not use any external testing library other
; than those specifically provided; otherwise, we will not be able to grade
; your code.
(define/provide-test-suite sample-tests
  ;; DO NOT ADD TESTS HERE
  (test-equal? "Works with Num primitive"
               (eval `2) (v-num 2))
  (test-raises-error? "Passing Str to + results in error"
                             (eval `{+ "bad" 1}))
  (test-pred "Equivalent to the test case above, but with test-pred"
             v-fun? (eval `{lam x 5})))

;; DO NOT EDIT ABOVE THIS LINE =================================================

(define/provide-test-suite student-tests ;; DO NOT EDIT THIS LINE ==========
  ; TODO: Add your own tests below!
  (test-equal? "Simple String Test"
               (eval `"Hello world!") (v-str "Hello world!"))
  (test-equal? "Simple Bool Test"
               (eval `true) (v-bool true))
  (test-equal? "Simple Bool false Test"
               (eval `false) (v-bool false))
  )

;; DO NOT EDIT BELOW THIS LINE =================================================

(module+ main
  (run-tests sample-tests)
  (run-tests student-tests))