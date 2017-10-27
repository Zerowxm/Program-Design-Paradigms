;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

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
     block?)
(check-location "07" "q1.rkt")

; A Literal is represented as a struct (make-literal value)
; - value Real   is a real number Literal represents
(define-struct literal (value))
; Constructor template
; (make-literal Real)
; Observer template
; literal-fn : lit -> ??
(define (literal-fn lit)
  (...(literal-value)))

; A Variable is represented as a struct (make-variable name)
; name : String (any string will do) the name of variable
(define-struct variable (name))
; Constructor template
; (make-variable String)
; Observer teamplate
; variable-fn : Variable -> ??
(define (variable-fn var)
  (...(variable-name var)))

;;; An OperationName is represented as one of the following strings:
;;;     -- "+"      (indicating addition)
;;;     -- "-"      (indicating subtraction)
;;;     -- "*"      (indicating multiplication)
;;;     -- "/"      (indicating division)
;;;
;;; OBSERVER TEMPLATE:
;;; operation-name-fn : OperationName -> ??
#;
(define (operation-name-fn op)
  (cond ((string=? op "+") ...)
        ((string=? op "-") ...)
        ((string=? op "*") ...)
        ((string=? op "/") ...)))
; Examples:
(define addition "+")

; A Operation is represented as a struct (make-operation name)
; name : OperationName  is the name of the operation
(define-struct operation (name))
; Constructor template
; (make-operation OperationName)
; Observer tamplate
; operation-fn : Operation -> ??
(define (operation-fn op)
  (...(operation-name op)))


; A Call is represented as a struct (make-call-exp operator operands)
; - operator : ArithmeticExpression  is the operator expression of that call
; - operands :   is the operand expressions of that call
(define-struct call-exp (operator operands))
; Constructor template
; (make-call-exp ArithmeticExpression ArithmeticExpressionList)
; Observer template
; call-exp-fn : Call => ??
(define (call-exp-fn call)
  (...(call-exp-operator call)
      (call-exp-operands call)))
; Examples
; (define call-add-100 (make-call-exp op-addition (list literal-100 literal-100)))

; A Block is represented as a struct (make-block-exp var rhs body)
; - var :  Variable               is the variable of the block
; - rhs :  ArithmeticExpression   is the expression whose value will become 
;          the value of the variable defined by that block
; - body : ArithmeticExpression   is the expression whose value will become 
;          the value of the block expression
(define-struct block-exp (var rhs body))
; Constructor template
; (make-block Variable ArithmeticExpression ArithmeticExpression)
; Observer template
; block-fn : Block -> ??
(define (block-exp-fn block)
  (...(block-exp-var block)
      (block-exp-rhs block)
      (block-exp-body block)))
; Examples
;(define block-x5 (make-block-exp (var "x5")  (lit 5) 
;                                 (call (op "*") (list (var "x6") (var "x7")))))

;;; An ArithmeticExpression is one of
;;;     -- a Literal
;;;     -- a Variable
;;;     -- an Operation
;;;     -- a Call
;;;     -- a Block
;;;
;;; OBSERVER TEMPLATE:
;;; arithmetic-expression-fn : ArithmeticExpression -> ??
#;
(define (arithmetic-expression-fn exp)
  (cond ((literal? exp) ...)
        ((variable? exp) ...)
        ((operation? exp) ...)
        ((call? exp) ...)
        ((block? exp) ...))) 

; ArithmeticExpressionList is one of
; -- empty
; -- (cons ArithmeticExpression ArithmeticExpressionList)
; Observer Template: 
;; elist-fn : ArithmeticExpressionList -> ??
#;
(define (elist-fn es)
   (cond
     [(empty? es) ...]
     [else (... (first es))
                (elist-fn (rest es))]))
;; Examples: (list (var 1) (op "+"))

;;;
;;; lit : Real -> Literal
;;; GIVEN: a real number
;;; RETURNS: a literal that represents that number
;;; Examples: (lit 1) => (make-literal 1)
;;; (lit 100) => literal-100
;;; Strategy: use constructor template of Literal 
(define (lit value)
  (make-literal value))
; Test
(define literal-100 (make-literal 100))
(begin-for-test
  (check-equal? (lit 100) literal-100 "it should be literal-100"))
;;; literal-value : Literal -> Real
;;; GIVEN: a literal
;;; RETURNS: the number it represents
;;; EXAMPLE: (literal-value (lit 17.4)) => 17.4
;Test
(begin-for-test
  (check-equal? (literal-value literal-100) 100 "it should be 100"))
;;; var : String -> Variable
;;; GIVEN: a string
;;; WHERE: the string begins with a letter and contains
;;;     nothing but letters and digits
;;; RETURNS: a variable whose name is the given string
;;; Strategy: use constructor template of Variable 
;;; Examples: (var "x15") => variable-x15
(define (var name)
  (make-variable name))
; Tests
(define variable-x15 (make-variable "x15"))
(begin-for-test
  (check-equal? (var "x15") variable-x15 "it should be variable-x15"))

;;; variable-name : Variable -> String
;;; GIVEN: a variable
;;; RETURNS: the name of that variable
;;; EXAMPLE: (variable-name (var "x15")) => "x15"
; Test
(begin-for-test
  (check-equal? (variable-name variable-x15) "x15" "it should return x15"))

;;; op : OperationName -> Operation
;;; GIVEN: the name of an operation
;;; RETURNS: the operation with that name
;;; Strategy: use constructor template of Operation 
;;; EXAMPLES: (op addition) => op-addition
(define (op name)
  (make-operation name))
; Tests
(define op-addition (make-operation addition))
(begin-for-test
  (check-equal? (op addition) op-addition "it should be op-addition"))

;;; operation-name : Operation -> OperationName
;;; GIVEN: an operation
;;; RETURNS: the name of that operation
;;; EXAMPLES:
;;;     (operation-name (op "+")) => "+"
;;;     (operation-name (op "/")) => "/"
; Tests
(begin-for-test
  (check-equal? (operation-name op-addition) addition "it should be addition")
  (check-equal? (operation-name (op "+")) "+" "it should be '+'"))

;;; call : ArithmeticExpression ArithmeticExpressionList -> Call
;;; GIVEN: an operator expression and a list of operand expressions
;;; RETURNS: a call expression whose operator and operands are as
;;;     given
;;; Strategy: use constructor template of Call 
;;; EXAMPLES: (call op-addition (list literal-100 literal-100))=> call-add-100
(define (call operator operands)
  (make-call-exp operator operands))
; Test
(define call-add-100 (make-call-exp op-addition (list literal-100 literal-100)))
(begin-for-test
  (check-equal? (call op-addition (list literal-100 literal-100)) call-add-100
                "it should be call-add-100"))

;;; call-operator : Call -> ArithmeticExpression
;;; GIVEN: a call
;;; RETURNS: the operator expression of that call
;;; EXAMPLE:
;;;     (call-operator (call (op "-")
;;;                          (list (lit 7) (lit 2.5))))
;;;         => (op "-")
;;; Strategy: use observer template of Call on call 
(define (call-operator call)
  (call-exp-operator call))
; Test
(begin-for-test
  (check-equal? (call-operator call-add-100) op-addition "it should be op-addition")
  (check-equal? (call-operator (call (op "-") (list (lit 7) (lit 2.5))))
                (op "-") "it should be (op \"- \")"))

;;; call-operands : Call -> ArithmeticExpressionList
;;; GIVEN: a call
;;; RETURNS: the operand expressions of that call
;;; EXAMPLE:
;;;     (call-operands (call (op "-")
;;;                          (list (lit 7) (lit 2.5))))
;;;         => (list (lit 7) (lit 2.5))
;;; Strategy: use observer template of Call on call 
(define (call-operands call)
  (call-exp-operands call))
; Test
(begin-for-test
  (check-equal? (call-operands call-add-100) (list literal-100 literal-100)
                "it should be (list literal-100 literal-100)")
  (check-equal? (call-operands (call (op "-") (list (lit 7) (lit 2.5))))
                (list (lit 7) (lit 2.5)) "it should be (list (lit 7) (lit 2.5))"))

;;; block : Variable ArithmeticExpression ArithmeticExpression
;;;             -> Block
;;; GIVEN: a variable, an expression e0, and an expression e1
;;; RETURNS: a block that defines the variable's value as the
;;;     value of e0; the block's value will be the value of e1
;;; EXAMPLES: (block (var "x5")
;;;                       (lit 5)
;;;                       (call (op "*")
;;;                             (list (var "x6") (var "x7")))))
;;; => block-x5
;;; Strategy: use construct template of Block  
(define (block var rhs body)
  (make-block-exp var rhs body))  
; Test
(define block-x5 (make-block-exp (var "x5")  (lit 5) 
                                 (call (op "*") (list (var "x6") (var "x7")))))
(begin-for-test
  (check-equal? (block (var "x5")  (lit 5) (call (op "*") (list (var "x6") (var "x7"))))
                block-x5 "it should be block-x5"))

;;; block-var : Block -> Variable
;;; GIVEN: a block
;;; RETURNS: the variable defined by that block
;;; EXAMPLE:
;;;     (block-var (block (var "x5")
;;;                       (lit 5)
;;;                       (call (op "*")
;;;                             (list (var "x6") (var "x7")))))
;;;         => (var "x5")
;;; Strategy: use observer template of Block on block
(define (block-var block)
  (block-exp-var block))    
; Test
(begin-for-test
  (check-equal? (block-var block-x5) (var "x5") "it should be "))

;;; block-rhs : Block -> ArithmeticExpression
;;; GIVEN: a block
;;; RETURNS: the expression whose value will become the value of
;;;     the variable defined by that block
;;; EXAMPLE:
;;;     (block-rhs (block (var "x5")
;;;                       (lit 5)
;;;                       (call (op "*")
;;;                             (list (var "x6") (var "x7")))))
;;;         => (lit 5)
;;; Strategy: use observer template of Block on block
(define (block-rhs block)
  (block-exp-rhs block))
; Test
(begin-for-test
  (check-equal? (block-rhs block-x5) (lit 5) "it should be (lit 5)"))

;;; block-body : Block -> ArithmeticExpression
;;; GIVEN: a block
;;; RETURNS: the expression whose value will become the value of
;;;     the block expression
;;; EXAMPLE:
;;;     (block-body (block (var "x5")
;;;                        (lit 5)
;;;                        (call (op "*")
;;;                              (list (var "x6") (var "x7")))))
;;;         => (call (op "*") (list (var "x6") (var "x7")))
;;; Strategy: use observer template of Block on block
(define (block-body block)
  (block-exp-body block))
; Test
(begin-for-test
  (check-equal? (block-body block-x5) (call (op "*") (list (var "x6") (var "x7")))
                "it should be (call (op '*') (list (var 'x6') (var 'x7')))"))

;;; literal?   : ArithmeticExpression -> Boolean
;;; variable?  : ArithmeticExpression -> Boolean
;;; operation? : ArithmeticExpression -> Boolean
;;; call?      : ArithmeticExpression -> Boolean
;;; block?     : ArithmeticExpression -> Boolean
;;; GIVEN: an arithmetic expression
;;; RETURNS: true if and only the expression is (respectively)
;;;     a literal, variable, operation, call, or block
;;; EXAMPLES:
;;;     (variable? (block-body (block (var "y") (lit 3) (var "z"))))
;;;         => true
;;;     (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
;;;         => false
;;;     (call? call-add-100) => true
;;;      (block? (block-body (block (var "y") (lit 3) (var "z")))) => false
;;; Strategy: use observer template
;;; of Literal, Variable, Operation, Call, or Block
(define (call? expression)
  (call-exp? expression))

(define (block? expression)
  (block-exp? expression))
; Test
(begin-for-test
  (check-true (literal? literal-100) "it should return true")
  (check-true (variable? variable-x15) "it should return true")
  (check-false (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
               "it should return true")
  (check-true (variable? (block-body (block (var "y") (lit 3) (var "z"))))
              "it should return true")
  (check-true (call? call-add-100))
  (check-false (block? (block-body (block (var "y") (lit 3) (var "z"))))))

; remove-duplicates: StringList -> StringList
; Given: a list of string
; Returns: a list like the given one except without repititions
; Examples: (list "x" "v" "x" "v") => (list "x" "v") or (list "v" "x")
; Strategy: use observer template for StringList on l
(define (remove-duplicates lon)
  (foldr (lambda (x y) (cons x (filter (lambda (z) (not (string=? x z))) y))) empty lon))

         ;;; undefined-variables : ArithmeticExpression -> StringList
          ;;; GIVEN: an arbitrary arithmetic expression
          ;;; RETURNS: a list of the names of all undefined variables
          ;;;     for the expression, without repetitions, in any order
          ;;; EXAMPLE:
          ;;;     (undefined-variables
          ;;;      (call (var "f")
          ;;;            (list (block (var "x")
          ;;;                         (var "x")
          ;;;                         (var "x"))
          ;;;                  (block (var "y")
          ;;;                         (lit 7)
          ;;;                         (var "y"))
          ;;;                  (var "z"))))
          ;;;  => some permutation of (list "f" "x" "z")

(define (undefined-variables exp)
  (remove-duplicates (undefined-variables-in-exp exp empty empty)))
; Tests
(begin-for-test
  (check-equal? (undefined-variables (call (var "f") 
    (list (block (var "x") (var "x") (var "x")) (block (var "y") (lit 7) (var "y"))
      (var "z")))) (list "f" "x" "z")))

; undefined-variables-in-var: Variable StringList StringList -> StringList
; Given: a variable var, a StringList s1 and a StringList s2
; Returns: a list like s2 except including the name of var if it is not in s1 otherwise s2
; Examples: (undefined-variables-in-var (var "x") (list "x") (list)) => empty
; (undefined-variables-in-var (var "x") (list) (list)) => (list "x")
; Strategy: cases on the name of the var
(define (undefined-variables-in-var var defines undefines)
  (let ([var (variable-name var)])
    (if (member? var defines)
    undefines
    (cons var undefines))))
; Test
(begin-for-test
  (check-equal? (undefined-variables-in-var (var "x") (list "x") (list)) empty
    "it should return empty")
  (check-equal? (undefined-variables-in-var (var "x") (list) (list)) (list "x")
    "it should return (list \"x\")"))

; undefined-variables-in-exp: ArithmeticExpression StringList StringList -> StringList
; Given: an ArithmeticExpression exp a StringList s1 and a StringList s2
; Returns: a list of string like s2 
; Strategy: use observer template on ArithmeticExpression
         ;;; EXAMPLE:
          ;;;     (undefined-variables-in-exp
          ;;;      (call (var "f")
          ;;;            (list (block (var "x")
          ;;;                         (var "x")
          ;;;                         (var "x"))
          ;;;                  (block (var "y")
          ;;;                         (lit 7)
          ;;;                         (var "y"))
          ;;;                  (var "z"))) empty empty)
          ;;;  => some permutation of (list "f" "x" "z")
          ; (undefined-variables-in-exp (var "x") (list "x") (list)) => empty
          ; (undefined-variables-in-exp (block (var "x") (var "x") (var "x")) empty empty) 
          ; => (list "x")
(define (undefined-variables-in-exp exp defines undefines)
  (cond
    [(variable? exp) (undefined-variables-in-var exp defines undefines)]
    [(block? exp) (undefined-variables-in-block exp defines undefines)]
    [(call? exp) (undefined-variables-in-call exp defines undefines)]
    [else undefines]))
; Test
(begin-for-test
  (check-equal? 
    (undefined-variables-in-exp (block (var "x") (var "x") (var "x")) empty empty)
    (list "x") "it should return (list \"x\")")
  (check-equal? (undefined-variables-in-exp (var "x") (list "x") (list)) empty
    "it should return empty")
  (check-equal? (undefined-variables-in-exp (call (var "f") 
    (list (block (var "x") (var "x") (var "x")) (block (var "y") (lit 7) (var "y"))
      (var "z"))) empty empty) (list "f" "x" "z") "it returns a wrong list"))

; undefined-variables-in-call: Call StringList StringList -> StringList
; Given: a Call c a StringList s1 and a StringList s2
; Returns: a list of string like s2 plus all the names of variable in c that are not in s1
; as well as not defined by block in call
         ;;; EXAMPLE:
          ;;;     (undefined-variables-in-call
          ;;;      (call (var "f")
          ;;;            (list (block (var "x")
          ;;;                         (var "x")
          ;;;                         (var "x"))
          ;;;                  (block (var "y")
          ;;;                         (lit 7)
          ;;;                         (var "y"))
          ;;;                  (var "z"))) empty empty)
          ;;;  => some permutation of (list "f" "x" "z")
(define (undefined-variables-in-call call defines undefines)
  (append 
      (undefined-variables-in-exp (call-operator call) defines undefines) 
      (undefined-variables-in-list (call-operands call) defines undefines)))
; Tests
(begin-for-test
  (check-equal? (undefined-variables-in-call (call (var "f") 
    (list (block (var "x") (var "x") (var "x")) (block (var "y") (lit 7) (var "y"))
      (var "z"))) empty empty) (list "f" "x" "z")))

; undefined-variables-in-block Block StringList StringList -> StringList
; Given: a Block block a StringList s1 and a StringList s2
; Returns: 
; Examples: (undefined-variables-in-block (block (var "x") (var "x") (var "x")) empty empty) 
          ; => (list "x")
(define (undefined-variables-in-block block defines undefines)
 (append
      (undefined-variables-in-exp (block-rhs block) defines undefines)
      (undefined-variables-in-exp (block-body block) 
        (cons (variable-name (block-var block)) defines) undefines)))
 ; Test
(begin-for-test
  (check-equal? 
    (undefined-variables-in-block (block (var "x") (var "x") (var "x")) empty empty)
    (list "x") "it should return (list \"x\")")) 

; undefined-variables-in-list: ArithmeticExpressionList StringList StringList -> StringList
; Given: a ArithmeticExpressionList exps a StringList s1 and a StringList s2
; Strategy: use HOF map on exps followed by apply
; Examples:(undefined-variables-in-list 
;     (list (block (var "x") (var "x") (var "x")) (block (var "y") (lit 7) (var "y"))
;       (var "z")) empty empty) => '("x" "z")
(define (undefined-variables-in-list exps defines undefines)
  (apply 
    append (map (lambda (x) (undefined-variables-in-exp x defines undefines)) exps)))
; Test
(begin-for-test 
  (check-equal? (undefined-variables-in-list 
    (list (block (var "x") (var "x") (var "x")) (block (var "y") (lit 7) (var "y"))
      (var "z")) empty empty) (list"x" "z") "it should return '(\"x\" \"z\")"))
