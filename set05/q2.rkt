;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
 block?
 variables-defined-by
 variables-used-by
 constant-expression? 
 constant-expression-value)
(check-location "05" "q2.rkt")

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


; A Call is represented as a struct (make-func-call operator operands)
; - operator : ArithmeticExpression  is the operator expression of that call
; - operands :   is the operand expressions of that call
(define-struct func-call (operator operands))
; Constructor template
; (make-func-call ArithmeticExpression ArithmeticExpressionList)
; Observer template
; func-call-fn : Call => ??
(define (func-call-fn call)
  (...(func-call-operator call)
      (func-call-operands call)))
; Examples
; (define call-add-100 (make-func-call op-addition (list literal-100 literal-100)))

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
;;;     -- an OperationExpression
;;;     -- a ConstantExpression
;;;
;;; OBSERVER TEMPLATE:
;;; arithmetic-expression-fn : ArithmeticExpression -> ??
#;
(define (arithmetic-expression-fn exp)
  (cond ((literal? exp) ...)
        ((variable? exp) ...)
        ((operation? exp) ...)
        ((call? exp) ...)
        ((block? exp) ...)
        ((operation-expression? exp) ...)
        ((constant-expression? exp) ...))) 

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

; A OperationExpression is represented as either
; -- an Operation
; -- a Block where its body is an operation expression
;;; OBSERVER TEMPLATE:
;;; operation-expression-fn : OperationExpression -> ??
#;
(define (operation-expression-fn exp)
  (cond ((operation? exp) ...)
        ((block? exp) ...)))

; A ConstantExpression is represented as one of
; -- a Literal
; -- a Call where its operator is an operation expression 
;           and its operands are all constant expressions
; -- a Block where its body is an operation expression
;;; OBSERVER TEMPLATE:
;;; constant-expression-fn : ConstantExpression -> ??
#;
(define (constant-expression-fn exp)
  (cond((literal? exp) ...)
       ((call? exp) ...)
       ((block? exp) ...)))

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
  (make-func-call operator operands))
; Test
(define call-add-100 (make-func-call op-addition (list literal-100 literal-100)))
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
  (func-call-operator call))
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
  (func-call-operands call))
; Test
(begin-for-test
  (check-equal? (call-operands call-add-100) (list literal-100 literal-100)
                "it should be (list literal-100 literal-100)")
  (check-equal? (call-operands (call (op "-") (list (lit 7) (lit 2.5))))
                (list (lit 7) (lit 2.5)) "it should be (list (lit 7) (lit 2.5))"))

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
  (func-call? expression))

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

;;; variables-defined-by : ArithmeticExpression -> StringList
;;; GIVEN: an arithmetic expression
;;; RETURNS: a list of the names of all variables defined by
;;;     all blocks that occur within the expression, without
;;;     repetitions, in any order
;;; EXAMPLE:
;;;     (variables-defined-by
;;;      (block (var "x")
;;;             (var "y")
;;;             (call (block (var "z")
;;;                          (var "x")
;;;                          (op "+"))
;;;                   (list (block (var "x")
;;;                                (lit 5)
;;;                                (var "x"))
;;;                         (var "x")))))
;;;  => (list "x" "z") or (list "z" "x")
;;; (variables-defined-by block-x5) => (list "x5")
;;; Strategy: cases on the type of the expression
(define (variables-defined-by exp)
  (cond
    [(block? exp) (without-duplicates (variables-defined-by-block exp))]
    [(call? exp) (without-duplicates (variables-defined-by-call exp))]
    [else empty]
    )) 
; Test
(define exp-exm (block (var "x") (var "y")
                       (call (block (var "z") (var "x") (op "+"))
                             (list (block (var "x")
                                          (lit 5) (var "x")) (var "x")))))
(define call-exm (call (block (var "z") (var "x") (op "+"))
                       (list (block (var "x") (lit 5) (var "x")) (var "x"))))
(define exp-list (call-operands call-exm))
(begin-for-test
  (check-equal? (variables-defined-by block-x5) (list "x5")
                "it should return '(\"x5\")")
  (check-equal? (variables-defined-by exp-exm) '("z" "x")
                "it should be '(\"z\" \"x\")"))

; variables-defined-by-block: ArithmeticExpression -> StringList
; Given: an arithmetic expression 
; Returns: a list of the names of all variables defined by
;          all blocks that occur within the expression 
; Strategy: use observer template for Block and Variable 
; Examples: (variables-defined-by-block block-x5) => (list "x5")
(define (variables-defined-by-block exp)
  (if (variable? exp)
      (list (variable-name exp))
      (append (variables-defined-by-block (block-var exp)) 
              (variables-defined-by (block-rhs exp)) 
              (variables-defined-by (block-body exp)))))
; Test
(begin-for-test
  (check-equal? (variables-defined-by-block block-x5) (list "x5")))

; variables-defined-by-call: Call -> StringList
; Given: a call
; Returns: a list of the names of all variables defined by
;          all blocks that occur within the expression 
; Strategy: use observer template for Call on exp
; Examples: (variables-defined-by-call call-exm) => (list "z" "x")
(define (variables-defined-by-call exp)
  (append (variables-defined-by (call-operator exp)) 
          (variables-defined-by-list (call-operands exp))))
; Test
(begin-for-test
  (check-equal? (variables-defined-by-call call-exm)  '("z" "x")
                "it should return  '(\"z\" \"x\")"))

; variables-defined-by-list: ArithmeticExpressionList -> StringList
; Given: a list of a rithmetic expression
; Returns: a list of the names of all variables defined by
;          all blocks that occur within the expression 
; Strategy: use observer template for ArithmeticExpression on es
; Examples: (variables-defined-by-list exp-list) => (list "x")
(define (variables-defined-by-list es)
  (cond
    [(empty? es) empty]
    [else (append (variables-defined-by (first es)) 
                  (variables-defined-by-list (rest es)))]))  
; Test
(begin-for-test
  (check-equal? (variables-defined-by-list exp-list) (list "x")
                "it should return (list 'x')"))  

; without-duplicates: StringList -> StringList
; Given: a list of string
; Returns: a list like the given one except without repititions
; Examples: (list "x" "v" "x" "v") => (list "x" "v") or (list "v" "x")
; Strategy: use observer template for StringList on l
(define (without-duplicates l)
  (cond 
    [(empty? l) empty]
    [(member (first l) (rest l)) (without-duplicates (rest l))]
    [else (cons (first l) (without-duplicates (rest l)))]))
; Test
(begin-for-test
  (check-equal? (without-duplicates (list "x" "v" "x" "v")) (list "x" "v")
                "it should be (list 'x' 'v')"))

;;; variables-used-by : ArithmeticExpression -> StringList
;;; GIVEN: an arithmetic expression
;;; RETURNS: a list of the names of all variables used in
;;;     the expression, including variables used in a block
;;;     on the right hand side of its definition or in its body,
;;;     but not including variables defined by a block unless
;;;     they are also used
;;; EXAMPLE:
;;;     (variables-used-by
;;;      (block (var "x")
;;;             (var "y")
;;;             (call (block (var "z")
;;;                          (var "x")
;;;                          (op "+"))
;;;                   (list (block (var "x")
;;;                                (lit 5)
;;;                                (var "x"))
;;;                         (var "x")))))
;;;  => (list "x" "y") or (list "y" "x")
;;; Strategy: cases on the type of the expression
(define (variables-used-by exp)
  (cond
    [(variable? exp) (list (variable-name exp))]
    [(block? exp) (without-duplicates (variables-used-by-block exp))]
    [(call? exp) (without-duplicates (variables-used-by-call exp))]
    [else empty])) 
; Tests
(begin-for-test
  (check-equal? (variables-used-by exp-exm) (list "y" "x")))

; variables-used-by-block: ArithmeticExpression -> StringList
; Given: an arithmetic expression
; Returns: a list of the names of all variables used by
;          all blocks that occur within the expression 
; Strategy: use observer template for Block and Variable 
; Examples: (variables-used-by-block block-x5) => (list "x6" "x7")
; (variables-used-by-block exp-exm) => (list "y" "x" )
(define (variables-used-by-block exp)
  (append (variables-used-by (block-rhs exp)) 
          (variables-used-by (block-body exp))))
; Test
(begin-for-test
  (check-equal? (variables-used-by-block block-x5) (list "x6" "x7")
                "it should return  '(\"x6\" \"x7\")")
  (check-equal? (variables-used-by-block exp-exm) (list "y" "x" )
                "it should return '(\"y\" \"x\")"))

; variables-used-by-call: Call -> StringList
; Given: a call
; Returns: a list of the names of all variables used by
;          all blocks that occur within the expression 
; Strategy: use observer template for Call on exp
; Examples: (variables-used-by-call call-exm) => (list "x" "x" "x")
(define (variables-used-by-call exp)
  (append (variables-used-by (call-operator exp)) 
          (variables-used-by-list (call-operands exp))))
; Test
(begin-for-test
  (check-equal? (variables-used-by-call call-exm) (list "x" "x" "x")
                "it should return (list \"x\" \"x\" \"x\")"))

; variables-used-by-list: ArithmeticExpressionList -> StringList
; Given: a list of a rithmetic expression
; Returns: a list of the names of all variables used by
;          all blocks that occur within the expression 
; Strategy: use observer template for ArithmeticExpression on es
; Examples: (variables-used-by-list exp-list) => (list "z" "x")
(define (variables-used-by-list es)
  (cond
    [(empty? es) empty]
    [else (append (variables-used-by (first es)) 
                  (variables-used-by-list (rest es)))]))  
; Test
(begin-for-test
  (check-equal? (variables-used-by-list exp-list) (list "x" "x")
                "it should return (list \"x\" \"x\")"))         

;;; constant-expression? : ArithmeticExpression -> Boolean
;;; GIVEN: an arithmetic expression
;;; RETURNS: true if and only if the expression is a constant
;;;     expression
;;; EXAMPLES:
;;;     (constant-expression?
;;;      (call (var "f") (list (lit -3) (lit 44))))
;;;         => false
;;;     (constant-expression?
;;;      (call (op "+") (list (var "x") (lit 44))))
;;;         => false
;;;     (constant-expression?
;;;      (block (var "x")
;;;             (var "y")
;;;             (call (block (var "z")
;;;                          (call (op "*")
;;;                                (list (var "x") (var "y")))
;;;                          (op "+"))
;;;                   (list (lit 3)
;;;                         (call (op "*")
;;;                               (list (lit 4) (lit 5)))))))
;;;         => true
;;; Strategy: cases on the type of the expression
(define (constant-expression? exp)
  (cond
    [(literal? exp) true]
    [(block? exp) (constant-expression? (block-body exp))]
    [(call? exp) (call-constant? exp)]
    [else false]))
; Test
(define const-exp (block (var "x") (var "y")
                         (call (block (var "z")
                                      (call (op "*") (list (var "x") (var "y")))
                                      (op "+")) (list (lit 3) (call (op "*")
                                                                    (list (lit 4) (lit 5)))))))
(define const-call (call (block (var "z")
                                (call (op "*") (list (var "x") (var "y")))
                                (op "+")) (list (lit 3) (call (op "*")
                                                              (list (lit 4) (lit 5))))))
(begin-for-test
  (check-true (constant-expression? const-exp) "it should return true"))

;;; call-constant? Call -> Boolean
;;; GIVEN: an Call
;;; RETURNS: true if and only if the expression is a constant expression
;;; Examples: (call-constant? call-exm) => true
;;;  (call-constant? call-exm) => false
;;; Strategy: combine simpler functions
(define (call-constant? call)
  (and (call-operands-constant? (call-operands call)) 
       (operation-expression? (call-operator call))))
; Test
(begin-for-test
  (check-false (call-constant? call-exm) "it should be false")
  (check-true (call-constant? const-call) "it should be true"))

;;; call-operands-constant? ArithmeticExpressionList -> Boolean
;;; GIVEN: an list of ArithmeticExpression
;;; RETURNS: true if and only if all the expressions is constant expressions
;;; Examples: (call-operands-constant? exp-list) => true
;;; Strategy: use observer template of ArithmeticExpressionList on es
(define (call-operands-constant? es)
  (cond
    [(empty? es) true]
    [else (and (constant-expression? (first es))
               (call-operands-constant? (rest es)))]))
; Test
(begin-for-test
  (check-false (call-operands-constant? exp-list) "it should be false")
  (check-true (call-operands-constant? (call-operands const-call))
              "it should be true"))

; operation-expression? ArithmeticExpression -> Boolean
; Given:  an arithmentic expression
; Returns: true iff the expression is operation expression
; Examples: (operation-expression? op-addition) => true
; Strategy: cases on whether the given expression is an operation expression
(define (operation-expression? exp)
  (cond
    [(operation? exp) true]
    [(block? exp) (operation-expression? (block-body exp))]
    [else false]))
; Test
(begin-for-test
  (check-true (operation-expression? op-addition) "it should be true")
  (check-false (operation-expression? block-x5) "it should be false"))       

;;; constant-expression-value : ArithmeticExpression -> Real
;;; GIVEN: an arithmetic expression
;;; WHERE: the expression is a constant expression
;;; RETURNS: the numerical value of the expression
;;; EXAMPLES:
;;;     (constant-expression-value
;;;      (call (op "/") (list (lit 15) (lit 3))))
;;;         => 5
;;;     (constant-expression-value
;;;      (block (var "x")
;;;             (var "y")
;;;             (call (block (var "z")
;;;                          (call (op "*")
;;;                                (list (var "x") (var "y")))
;;;                          (op "+"))
;;;                   (list (lit 3)
;;;                         (call (op "*")
;;;                               (list (lit 4) (lit 5)))))))
;;;         => 23     
;;; Strategy: cases on the type of constant expression
(define (constant-expression-value exp)
  (cond
    [(literal? exp) (literal-value exp)]
    [(block? exp) (constant-expression-value (block-body exp))]
    [(call? exp) (call-value exp)]))
; Test data
(define exp-value (block (var "x") (var "y") 
                         (call (block (var "z") (call (op "*")
                                                      (list (var "x")(var "y")))
                                      (op "+"))
                               (list (lit 3)
                                     (call (op "*")
                                           (list (lit 4) (lit 5)))))))
(define op-block (block (var "z") (call (op "*") (list (var "x") (var "y")))
                        (op "+")))
; Test
(begin-for-test
  (check-equal? (constant-expression-value (call (op "/") (list (lit 15) (lit 3))))
                5 "it should be 5")
  (check-equal? (constant-expression-value exp-value) 23))

; call-value : Call -> Real
; Given: a call
; Returns: the numerical value of the expression 
; Examples: (call-value const-call) => 23
; (call-value (call (op "-") (list (lit 15) (lit 5)))) => 10
(define (call-value call)
  (let ([op (operator-value (call-operator call))])
    (cond
      [(string=? op "+") (call-operation (call-operands call) +)]
      [(string=? op "-") (call-operation (call-operands call) -)]
      [(string=? op "*") (call-operation (call-operands call) *)]
      [(string=? op "/") (call-operation (call-operands call) /)])))
; Test
(begin-for-test
  (check-equal? (call-value const-call) 23 "it should be 23")
  (check-equal? (call-value (call (op "-") (list (lit 15) (lit 5)))) 10 
                "it should be 10"))

; operator-value : OperationExpression -> String
; Given: an operation expression
; Returns: the name of the operation expression
; Examples: check-equal? (operator-value op-addition) => "+"
; (operator-value op-block) => "+"
; Strategy: cases on the type of operation expresssion
(define (operator-value exp)
  (cond
    [(operation? exp) (operation-name exp)]
    [(block? exp) (operator-value (block-body exp))]))
; Test
(begin-for-test
  (check-equal? (operator-value op-addition) "+")
  (check-equal? (operator-value op-block) "+"))

; call-operation : ArithmeticExpressionList Procedure -> Real
; Given: a list of arithmetic expressions
; and the operation procedure on the expressions
; Returns: the numerical value of the expression
; Examples: (call-operation (list (lit 15) (lit 5)) -) => 10
; Strategy: use observer template for ArithmeticExpressionList on es
(define (call-operation es op)
  (cond
    [(empty? (rest es)) (constant-expression-value (first es))]
    [else (op (constant-expression-value (first es))
              (call-operation (rest es) op))]))
; Test
(begin-for-test
  (check-equal? (call-operation (list (lit 15) (lit 5)) -) 10)
  "it should be 10")

