;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(require "q1.rkt")

(provide 
 lit 
 literal-value
 var 
 variable-name
 op 
 operation-name
 call 
 call-operator
 call-operands
 block 
 block-var
 block-rhs
 block-body
 literal?
 variable?
 operation?
 call?
 block?
 undefined-variables
 well-typed?)
(check-location "07" "q2.rkt")
; a Type is one of
; --"Int" 
; --"Op0"
; --"op1"
; --"Error"

; a VarTypes is
; --empty
; --(cons var (cons type var-types)
; Where: 
; var is a Variable
; type is a Type, the type of the var
; var-types is a VarTypes 
;; OBSERVER TEMPLATE:

;; ts-fn : VarTypes -> ??
#;
(define (ts-fn ts)
  (cond
    [(empty? ts) ...]
    [(variable? (first ts)) ...(first ts) (second ts)
                            (ts-fn (rest (rest ts)))]
    [else ...(first ts) (second ts)
          (ts-fn (rest (rest ts)))]))

;;; well-typed? : ArithmeticExpression -> Boolean
;;; GIVEN: an arbitrary arithmetic expression
;;; RETURNS: true if and only if the expression is well-typed
;;; EXAMPLES:
;;;     (well-typed? (lit 17))  =>  true
;;;     (well-typed? (var "x"))  =>  false
;;;
;;;     (well-typed?
;;;      (block (var "f")
;;;             (op "+")
;;;             (block (var "x")
;;;                    (call (var "f") (list))
;;;                    (call (op "*")
;;;                          (list (var "x"))))) => true
;;;
;;;     (well-typed?
;;;      (block (var "f")
;;;             (op "+")
;;;             (block (var "f")
;;;                    (call (var "f") (list))
;;;                    (call (op "*")
;;;                          (list (var "f"))))) => true
;;;
;;;     (well-typed?
;;;      (block (var "f")
;;;             (op "+")
;;;             (block (var "x")
;;;                    (call (var "f") (list))
;;;                    (call (op "*")
;;;                          (list (var "f"))))) => false
;;; Strategy: combine simpler functions
(define (well-typed? exp)
  (if (empty? (undefined-variables exp))
      (not (string=? "Error" (type-of-exp exp empty)))
      false))
; Test
(begin-for-test
  (check-equal? (well-typed? (lit 17)) true)
  (check-equal? (well-typed? (var "x")) false)
  (check-equal? (well-typed?
                 (block (var "f")
                        (op "+")
                        (block (var "x")
                               (call (var "f") (list))
                               (call (op "*")
                                     (list (var "x")))))) true)
  (check-equal? (well-typed?
                 (block (var "f")
                        (op "+")
                        (block (var "f")
                               (call (var "f") (list))
                               (call (op "*")
                                     (list (var "f")))))) true)
  (check-equal? (well-typed?
                 (block (var "f")
                        (op "+")
                        (block (var "x")
                               (call (var "f") (list))
                               (call (op "*")
                                     (list (var "f")))))) false)
  (check-equal? (well-typed?
                 (block (var "f")
                        (op "-")
                        (block (var "x")
                               (call (var "f") (list))
                               (call (op "/")
                                     (list (var "f")))))) false))

; type-of-exp: ArithmeticExpression VarTypes -> Type
; GIVEN: a ArithmeticExpression exp and a VarTypes var-types
; Where: var-types is a list of all variables and their types 
; defined by some larger expression and vars are available for exp
; variables in exp must be defined or in var-types
; RETURNS: the type of exp 
; STrategy: use observer template of ArithmeticExpression on exp 
; EXAMPLES: (type-of-exp (lit 5) empty) => "Int"
; (type-of-exp (op "+") empty) => "Op0"
(define (type-of-exp exp var-types)
  (cond
    [(literal? exp) "Int"]
    [(operation? exp) (type-of-op exp)]
    [(block? exp) (type-of-block exp var-types)]
    [(call? exp) (type-of-call exp var-types)]
    [(variable? exp) (list-ref var-types (add1 (index-of exp var-types)))]))
; Test
(begin-for-test
  (check-equal? (type-of-exp (lit 5) empty) "Int")
  (check-equal? (type-of-exp (op "+") empty) "Op0"))

; type-of-call: Call VarTypes -> Type
; GIVEN: a Call c and a VarTypes var-types
; Where: var-types is a list of all variables and their types 
; defined by some larger expression which are available for c
; and all variables in c must be defined or in var-types
; RETURNS: the type of c
; STrategy: "Int" if c is well-defined otherwise "Error"  
; EXAMPLES: (type-of-call (call (var "f") (list)) (list (var "f") "Op0")) => "Int"
(define (type-of-call c var-types)
  (if (well-typed-call? c var-types)
      "Int"
      "Error"))
; Test
(begin-for-test
  (check-equal? (type-of-call (call (var "f") (list)) (list (var "f") "Op0"))
                "Int" "it should return \"Int\""))

; well-typed-call?: Call VarTypes => Boolean
; GIVEN: a call C and a VarTypes var-types
; Where: var-types is a list of all variables and their types 
; defined by some larger expression which are available for c
; all variables in c must be defined or in var-types
; RETURNS: true if c is well-defined
; Examples: (well-typed-call? 
; (call (var "f") (list)) (list (var "f") "Int")) => false
(define (well-typed-call? c var-types)
  (or (and (equal? "Op0" (type-of-exp (call-operator c) var-types))
           (well-typed-exps? (call-operands c) var-types))
      (and (equal? "Op1" (type-of-exp (call-operator c) var-types))
           (well-typed-exps? (call-operands c) var-types) 
           (not (empty? (call-operands c))))))
; Test
(begin-for-test
  (check-equal? (well-typed-call? (call (var "f") (list))
                                  (list (var "f") "Int"))
                false "it should return false")
  (check-equal? (well-typed-call? (call (var "f") (list))
                                  (list (var "f") "Op0"))
                true "it should return true"))

; well-typed-exps?: ArithmeticExpressionList VarTypes -> Boolean
; GIVEN: a ArithmeticExpressionList exps and a VarTypes var-types
; Where: exps is the operands of a call 
; and var-types is a list of all variables and their types 
; defined by some larger expression which are available for every exp in exps
; variables in every exp in exps must be defined or in var-types
; Returns: true if every type of exp in exps is Int
; Strategy: use HOF map on exps followed by andmap
; EXAMPLES: (well-typed-exps? (list (lit 1)) empty) => true
(define (well-typed-exps? exps var-types)
  ; String -> Boolean
  ; Returns ture if t is equal to "Int"
  (andmap (lambda (t) (equal? "Int" t))
  ; ArithmeticExpression -> Type
  ; Returns: the type of the given expression 
          (map (lambda (x) (type-of-exp x var-types)) exps)))
; Test
(begin-for-test
  (check-equal? (well-typed-exps? (list (lit 1)) empty) true)
  "it should return true")

; type-of-block: Block VarTypes -> Type
; GIVEN: a Block b and a VarTypes var-types
; Where: var-types is a list of all variables and their types 
; defined by some larger expression which are available for b
; all variables in b must be defined or in var-types
; Returns: "Error" if the type of rhs of b is "Error" 
; otherwise return the type of body of b
; Strategy: use observer template of Block on b
; Examples:  (block (var "f")
; (op "+")
; (block (var "x")
;        (call (var "f") (list))
;        (call (op "*")
;              (list (var "x")))))) => "Int"
(define (type-of-block b var-types)
  (if (equal? "Error" (type-of-exp (block-rhs b) var-types))
      "Error"
      (type-of-exp (block-body b) (types-update b var-types))))
; Test
(begin-for-test
  (check-equal? (type-of-block  (block (var "f")
                                       (op "+")
                                       (block (var "x")
                                              (call (var "f") (list))
                                              (call (op "*")
                                                    (list (var "x"))))) empty) "Int"
  "it should return Int"))

; types-update: Block VarTypes -> VarTypes
; GIVEN: a Block b and a VarTypes var-types
; Where: variables in b must be defined or in var-types
; Returns: a list like var-types except with
; updating the the type of the var defined by b 
; or adding var and the type if not existing
; Strategy: use observer template on VarTypes
; Examples: (types-update (block (var "f")
;                      (op "+")
;                      (block (var "x")
;                             (call (var "f") (list))
;                             (call (op "*")
;                                   (list (var "x"))))) empty)
; => (list (variable "f") "Op0")
(define (types-update b var-types)
  (let ([var (block-var b)]
        [type (type-of-exp (block-rhs b) var-types)])
    ; helper: VarTypes -> VarTypes
    ; Given: a VarTypes lst
    ; Returns: a list like 1st except with updating 
    ; the the type of the var defined by b or adding them at the end
    (local [(define (helper lst)
              (cond
                [(empty? lst) (list var type)]
                [(equal? var (first lst))
                 (cons var (cons type (rest (rest lst))))]
                [else (cons (first lst)
                            (cons (second lst) (helper (rest (rest lst)))))]))]
      (helper var-types))))
; Test
(begin-for-test
  (check-equal? (types-update (block (var "f")
                                     (op "+")
                                     (block (var "x")
                                            (call (var "f") (list))
                                            (call (op "*")
                                                  (list (var "x"))))) empty)
                (list (var "f") "Op0")
                                                                            
                                          "it returns wrong"))

; index-of: X XList -> Integer
; GIVEN: a x which is any type and a list of x
; Where: the list must contain x and is not empty
; Returns: the index of x in l when first occuring
; Strategy: use observer template on XList
; EXAMPLES: (index-of 1 (list 1 2)) => 0
(define (index-of x l)
  (local [(define (helper lst counter)
            (cond 
              [(equal? x (first lst)) counter]
              [else (helper (rest lst) (add1 counter))]))]
    (helper l 0)))
; Test
(begin-for-test
  (check-equal? (index-of 1 (list 1 2)) 0))

; type-of-op: Operation -> Type
; GIVEN: a Operation op 
; Returns: the type of op
; Strategy: the type is "Op0" if op is "+" or "*" otherwise "Op1"
; EXAMPLES: (type-of-op (op "+")) => "Op0"
(define (type-of-op op)
  (let ([op (operation-name op)])
    (if (or (string=? op "+") (string=? op "*"))
        "Op0" "Op1")))
; Test
(begin-for-test
  (check-equal?  (type-of-op (op "+"))"Op0" "it should return Op0"))
 
