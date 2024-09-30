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
  
  (test-equal? "Basic binary addition"
               (eval `{+ 1 2}) (v-num 3))
  (test-raises-error? "Invalid binary addition input: left str"
               (eval `{+ "woah" 2}))
  (test-raises-error? "Invalid binary addition input: left bool"
               (eval `{+ true 2}))

  (test-equal? "Basic num equality"
               (eval `{num= 14 14}) (v-bool true))
  (test-equal? "Basic num inequality"
               (eval `{num= 1 2}) (v-bool false))
  (test-raises-error? "Invalid num equality input: left str"
               (eval `{num= "woah" 2}))
  (test-raises-error? "Invalid num equality input: right bool"
               (eval `{num= 2 false}))

  (test-equal? "Basic string appending"
               (eval `{++ "hello" "world"}) (v-str "helloworld"))
  (test-raises-error? "Invalid string appending input: int"
               (eval `{++ "woah" 2}))
  (test-raises-error? "Invalid string appending input: bool"
               (eval `{++ true "test"}))

  (test-equal? "Basic str equality"
               (eval `{str= "hello" "hello"}) (v-bool true))
  (test-equal? "Basic str inequality"
               (eval `{str= "hello" "world"}) (v-bool false))
  (test-raises-error? "Invalid str equality input: num"
               (eval `{str= 2 2}))
  (test-raises-error? "Invalid str equality input: bool"
               (eval `{str= "Hello" false}))
  ; TODO: need nested tests
  ; TODO: test if-statements

  (test-pred "My predicate test"
           v-fun? (eval `{lam x {+ x 1}}))


  ; Basic function calls
  (test-equal? "Basic lambda"
              (eval `{`{lam x x} 10})
              (v-num 10))

  ; TODO: test dynamic scope
  ; (test-equal? "Dynamic scope"
  ;             (let* ([f (eval `{lam x {+ x y}})]
  ;                    [g (eval `{lam y {f y}})])
  ;               (eval `{g 10}))
  ;             (v-num 20))
  ; (test-raises-error? "Dynamic scope"
  ;             (let* ([f (eval `{lam x {+ x y}})]
  ;                    [g (eval `{lam y {f y}})])
  ;               (eval `{g 10})))

  ; (test-equal? "Nested function calls"
  ;             (let* ([f (eval `{lam x {+ x 1}})]
  ;                    [g (eval `{lam y {f y}})])
  ;               (eval `{g 10}))
  ;             (v-num 11))
  )

;; DO NOT EDIT BELOW THIS LINE =================================================

(module+ main
  (run-tests sample-tests)
  (run-tests student-tests))