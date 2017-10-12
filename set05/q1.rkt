;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

; A Literal is represented as a struct (make-literal value)
; - value Real   is a real number Literal represents
(define-struct literal (value))
; (make-literal Real)
;;; lit : Real -> Literal
;;; GIVEN: a real number
;;; RETURNS: a literal that represents that number
;;; EXAMPLE: (see the example given for literal-value,
;;;          which shows the desired combined behavior
;;;          of lit and literal-value)
(define (lit value)
  (make-literal value))

;;; literal-value : Literal -> Real
;;; GIVEN: a literal
;;; RETURNS: the number it represents
;;; EXAMPLE: (literal-value (lit 17.4)) => 17.4
; Observer template
; literal-fn : lit -> ??
(define (literal-fn lit)
  (...(literal-value)))


; A Variable is represented as a struct (make-variable name)
; name : String (any string will do) the name of variable
(define-struct variable (name))
; (make-variable String)
;;; var : String -> Variable
;;; GIVEN: a string
;;; WHERE: the string begins with a letter and contains
;;;     nothing but letters and digits
;;; RETURNS: a variable whose name is the given string
;;; EXAMPLE: (see the example given for variable-name,
;;;          which shows the desired combined behavior
;;;          of var and variable-name)
(define (var name)
  (make-variable name))

;;; variable-name : Variable -> String
;;; GIVEN: a variable
;;; RETURNS: the name of that variable
;;; EXAMPLE: (variable-name (var "x15")) => "x15"
; Observer teamplate
; variable-fn : Variable -> ??
(define (variable-fn var)
  (...(variable-name var)))

; A Operation is represented as a struct (make-operation name)
; name : OperationName  is the name of the operation
(define-struct operation (name))
; (make-operation OperationName)
;;; op : OperationName -> Operation
;;; GIVEN: the name of an operation
;;; RETURNS: the operation with that name
;;; EXAMPLES: (see the examples given for operation-name,
;;;           which show the desired combined behavior
;;;           of op and operation-name)
(define (op name)
  (make-operation name))

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

;;; call : ArithmeticExpression ArithmeticExpressionList -> Call
;;; GIVEN: an operator expression and a list of operand expressions
;;; RETURNS: a call expression whose operator and operands are as
;;;     given
;;; EXAMPLES: (see the examples given for call-operator and
;;;           call-operands, which show the desired combined
;;;           behavior of call and those functions)
(define (call operator operands)
  (make-func-call operator operands))

;;; call-operator : Call -> ArithmeticExpression
;;; GIVEN: a call
;;; RETURNS: the operator expression of that call
;;; EXAMPLE:
;;;     (call-operator (call (op "-")
;;;                          (list (lit 7) (lit 2.5))))
;;;         => (op "-")
(define (call-operator call)
     (func-call-operator call))

;;; call-operands : Call -> ArithmeticExpressionList
;;; GIVEN: a call
;;; RETURNS: the operand expressions of that call
;;; EXAMPLE:
;;;     (call-operands (call (op "-")
;;;                          (list (lit 7) (lit 2.5))))
;;;         => (list (lit 7) (lit 2.5))
(define (call-operands call)
     (func-call-operands call))
         

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


;;; block : Variable ArithmeticExpression ArithmeticExpression
;;;             -> ArithmeticExpression
;;; GIVEN: a variable, an expression e0, and an expression e1
;;; RETURNS: a block that defines the variable's value as the
;;;     value of e0; the block's value will be the value of e1
;;; EXAMPLES: (see the examples given for block-var, block-rhs,
;;;           and block-body, which show the desired combined
;;;           behavior of block and those functions)
  (define (block var rhs body)
  (make-block-exp var rhs body))  

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