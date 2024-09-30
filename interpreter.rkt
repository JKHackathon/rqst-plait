#lang plait

;; =============================================================================
;; Interpreter: interpreter.rkt
;; =============================================================================

(require "support.rkt")

(define (eval [str : S-Exp]): Value
  (interp (parse str)))

;; DO NOT EDIT ABOVE THIS LINE =================================================
(define initial-env (hash empty))

(define (lookup (s : Symbol) (n : Env))
  (type-case (Optionof Value) (hash-ref n s)
    [(none) (error s "not bound")]
    [(some v) v]))

(define (interp [expr : Expr]): Value
  ; TODO: Implement me!
  (cond
    [(e-num? expr) (v-num (e-num-value expr))]
    [(e-str? expr) (v-str (e-str-value expr))]
    [(e-bool? expr) (v-bool (e-bool-value expr))]
    [(e-op? expr)
      (let ([interped-left (interp (e-op-left expr))]
            [interped-right (interp (e-op-right expr))])
      (cond
        [(op-plus? (e-op-op expr)) 
          (if (and (v-num? interped-left) (v-num? interped-right)) 
            (v-num (+ (v-num-value interped-left) (v-num-value interped-right)))
            (error 'type-error "Parameters were not numbers"))]

        [(op-num-eq? (e-op-op expr)) 
          (if (and (v-num? interped-left) (v-num? interped-right)) 
            (v-bool (= (v-num-value interped-left) (v-num-value interped-right)))
            (error 'type-error "Parameters were not numbers")
          )
        ]
        
        [(op-append? (e-op-op expr)) 
          (if (and (v-str? interped-left) (v-str? interped-right)) 
            (v-str (string-append (v-str-value interped-left) (v-str-value interped-right)))
            (error 'type-error "Parameters were not strings")
          )
        ]
        
        [(op-str-eq? (e-op-op expr)) 
          (if (and (v-str? interped-left) (v-str? interped-right)) 
            (v-bool (string=? (v-str-value interped-left) (v-str-value interped-right)))
            (error 'type-error "Parameters were not strings")
          )
        ]))]

      [(e-if? expr) ; Can only be bools right?
        (cond 
          [(not (v-bool? (interp (e-if-condition expr)))) (error 'type-error "Condition did not evaluate to a boolean")]
          [(v-bool? (interp (e-if-condition expr))) (interp (e-if-consq expr))]
          [else (interp (e-if-altern expr))])]
      ; [(e-var? expr) (lookup (e-var-name expr) )] ; TODO: what env???

      ; TODO: Check input types?
      [(e-lam? expr) 
        (let ([new-env initial-env]) ; TODO: cannot always use initial
          (v-fun (e-lam-param expr) (e-lam-body expr) new-env))]
      
      [(e-app? expr) ; TODO: check stacker for behavior
        ; (if (e-lam? (e-app-func expr))
          (let ([f (interp (e-app-func expr))]
                [a (interp (e-app-arg expr))])
            ; Check that f is a correctly formed v-fun
            (type-case Value f
              [(v-fun param body env)
                (let ([new-env (hash-set env param a)])
                  (interp body))] ; How do I use the new env?
              
              [else (error 'interp-error "Provided function did not evaluate to a function")]))]
          ; (error 'type-error "First parameter was not a lambda expression"))]
      [else (error 'interp-error "Invalid expression")]
    )
  )