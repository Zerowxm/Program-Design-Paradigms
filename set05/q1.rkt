;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
(check-location "05" "q1.rkt")
; A Literal is represented as a struct (make-literal value)
; - value Real   is a real number Literal represents
(define-struct literal (value))
; (make-literal Real)
;;; lit : Real -> Literal
;;; GIVEN: a real number
;;; RETURNS: a literal that represents that number
;;; (lit 1) => (make-literal 1)
;;; (lit 100) => literal-100
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
; Observer template
; literal-fn : lit -> ??
(define (literal-fn lit)
  (...(literal-value)))
;Test
(begin-for-test
  (check-equal? (literal-value literal-100) 100 "it should be 100"))

; A Variable is represented as a struct (make-variable name)
; name : String (any string will do) the name of variable
(define-struct variable (name))
; (make-variable String)
;;; var : String -> Variable
;;; GIVEN: a string
;;; WHERE: the string begins with a letter and contains
;;;     nothing but letters and digits
;;; RETURNS: a variable whose name is the given string
;;; (var "x15") => variable-x15
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
; Observer teamplate
; variable-fn : Variable -> ??
(define (variable-fn var)
  (...(variable-name var)))
; Test
(begin-for-test
  (check-equal? (variable-name variable-x15) "x15" "it should return x15"))

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
; (make-operation OperationName)
;;; op : OperationName -> Operation
;;; GIVEN: the name of an operation
;;; RETURNS: the operation with that name
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
; Observer tamplate
; operation-fn : Operation -> ??
(define (operation-fn op)
  (...(operation-name op)))
; Tests
(begin-for-test
  (check-equal? (operation-name op-addition) addition "it should be addition"))

; A Call is represented as a struct (make-func-call operator operands)
; - operator : ArithmeticExpression  is the operator expression of that call
; - operands : ArithmeticExpressionList  is the operand expressions of that call
(define-struct func-call (operator operands))
; (make-func-call ArithmeticExpression ArithmeticExpressionList)
; Observer template
; func-call-fn : Call => ??
(define (func-call-fn call)
  (...(func-call-operator call)
      (func-call-operands call)))
; Examples
(define call-add-100 (make-func-call op-addition (list literal-100 literal-100)))

;;; call : ArithmeticExpression ArithmeticExpressionList -> Call
;;; GIVEN: an operator expression and a list of operand expressions
;;; RETURNS: a call expression whose operator and operands are as
;;;     given
;;; EXAMPLES: (call op-addition (list literal-100 literal-100))=> call-add-100
(define (call operator operands)
  (make-func-call operator operands))
; Test
#;
(begin-for-test
  (check-equal? (call op-addition (list literal-100 literal-100)) call-add-100
                "it should be call-add-100"))
(check-expect (call op-addition (list literal-100 literal-100)) call-add-100)

;;; call-operator : Call -> ArithmeticExpression
;;; GIVEN: a call
;;; RETURNS: the operator expression of that call
;;; EXAMPLE:
;;;     (call-operator (call (op "-")
;;;                          (list (lit 7) (lit 2.5))))
;;;         => (op "-")
(define (call-operator call)
  (func-call-operator call))
; Test
#;
(begin-for-test
  (check-equal? (call-operator call-add-100) op-addition "it should be op-addition")
  (check-equal? (call-operator (call (op "-") (list (lit 7) (lit 2.5))))
                (op "-") "it should be (op "-")"))
(check-expect (call-operator call-add-100) op-addition )
(check-expect (call-operator (call (op "-") (list (lit 7) (lit 2.5)))) (op "-"))

;;; call-operands : Call -> ArithmeticExpressionList
;;; GIVEN: a call
;;; RETURNS: the operand expressions of that call
;;; EXAMPLE:
;;;     (call-operands (call (op "-")
;;;                          (list (lit 7) (lit 2.5))))
;;;         => (list (lit 7) (lit 2.5))
(define (call-operands call)
  (func-call-operands call))
; Test
#;
(begin-for-test
  (check-equal? (call-operands call-add-100) (list literal-100 literal-100)
                "it should be (list literal-100 literal-100)")
  (check-equal? (call-operands (call (op "-") (list (lit 7) (lit 2.5))))
                (list (lit 7) (lit 2.5)) "it should be (list (lit 7) (lit 2.5))"))
(check-expect (call-operands call-add-100) (list literal-100 literal-100))
(check-expect (call-operands (call (op "-") (list (lit 7) (lit 2.5))))
              (list (lit 7) (lit 2.5)))

; A Block is represented as a struct (make-block-exp var rhs body)
; - var :  Variable               is the variable of the block
; - rhs :  ArithmeticExpression   is the expression whose value will become 
;          the value of the variable defined by that block
; - body : ArithmeticExpression   is the expression whose value will become 
;          the value of the block expression
(define-struct block-exp (var rhs body))
; (make-block Variable ArithmeticExpression ArithmeticExpression)
; Observer template
; block-fn : Block -> ??
(define (block-exp-fn block)
  (...(block-exp-var block)
      (block-exp-rhs block)
      (block-exp-body block)))
(define block-x5 (make-block-exp (var "x5")  (lit 5) 
                                 (call (op "*") (list (var "x6") (var "x7")))))

;;; block : Variable ArithmeticExpression ArithmeticExpression
;;;             -> ArithmeticExpression
;;; GIVEN: a variable, an expression e0, and an expression e1
;;; RETURNS: a block that defines the variable's value as the
;;;     value of e0; the block's value will be the value of e1
;;; EXAMPLES: (block (var "x5")
;;;                       (lit 5)
;;;                       (call (op "*")
;;;                             (list (var "x6") (var "x7")))))
;;; => block-x5
(define (block var rhs body)
  (make-block-exp var rhs body))  
; Test
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
(define (block-rhs block)
  (block-exp-rhs block))

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
(define (block-body block)
  (block-exp-body block))
; Test
#;
(begin-for-test
  (check-equal? (block-body block-x5) (call (op "*") (list (var "x6") (var "x7")))
                "it should be (call (op "*") (list (var 'x6') (var 'x7')))"))
(check-expect (block-body block-x5) (call (op "*") (list (var "x6") (var "x7"))))        
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
;; (define (elist-fn es)
;;   (cond
;;     [(empty? es) ...]
;;     [else (... (first es))
;;                (elist-fn (rest es)))]))
;; Examples: (list (var 1) (op "+"))

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
(define (call? expression)
  (func-call? expression))

(define (block? expression)
  (block-exp? expression))

(begin-for-test
  (check-true (literal? literal-100) "it should return true")
  (check-true (variable? variable-x15) "it should return true")
  (check-false (variable? (block-rhs (block (var "y") (lit 3) (var "z"))))
               "it should return true")
  (check-true (variable? (block-body (block (var "y") (lit 3) (var "z"))))
              "it should return true")
  (check-true (call? call-add-100))
  (check-false (block? (block-body (block (var "y") (lit 3) (var "z"))))))