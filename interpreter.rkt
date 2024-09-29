#lang plait

;; =============================================================================
;; Interpreter: interpreter.rkt
;; =============================================================================

(require "support.rkt")

(define (eval [str : S-Exp]): Value
  (interp (parse str)))

;; DO NOT EDIT ABOVE THIS LINE =================================================
;(trace eval)
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
          ; TODO: wait, expr could be another op
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

      [(e-if? expr)
        (cond 
          [(not (v-bool? (interp (e-if-condition expr)))) (error 'type-error "Condition did not evaluate to a boolean")]
          [(v-bool? (interp (e-if-condition expr))) (interp (e-if-consq expr))]
          [else (interp (e-if-altern expr))])]
    )
  )