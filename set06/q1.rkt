;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(provide
 inner-product
 permutation-of? 
 shortlex-less-than?
 permutations)
(check-location "06" "q1.rkt")

;;; inner-product : RealList RealList -> Real
;;; GIVEN: two lists of real numbers
;;; WHERE: the two lists have the same length
;;; RETURNS: the inner product of those lists
;;; EXAMPLES:
;;;     (inner-product (list 2.5) (list 3.0))  =>  7.5
;;;     (inner-product (list 1 2 3 4) (list 5 6 7 8))  =>  70
;;;     (inner-product (list) (list))  =>  0
;;; Strategy: use HOF map on l1 and l2 followed by HOF foldr
(define (inner-product l1 l2)
  ; Real Real -> Real
  ; Given: two real numbersf
  ; Returns: the product of the two numbers
  ; Examples: ((lambda (e1 e2) (* e1 e2)) 1 2) => 2
  (foldr + 0 (map (lambda (e1 e2) (* e1 e2)) 
                  l1 l2)))
#;    
(define (inner-product l1 l2)
  (if(empty? l1) 0
     (+ (* (first l1) (first l2)) 
        (inner-product (rest l1) (rest l2)))))
; Test
(begin-for-test
  (check-equal? (inner-product (list 2.5) (list 3.0)) 7.5
                "the product should be 7.5")
  (check-equal? (inner-product (list 1 2 3 4) (list 5 6 7 8)) 70
                "the product should be 70")
  (check-equal? (inner-product (list) (list)) 0
                "the product should be 0"))

;;; permutation-of? : IntList IntList -> Boolean
;;; GIVEN: two lists of integers
;;; WHERE: neither list contains duplicate elements
;;; RETURNS: true if and only if one of the lists
;;;     is a permutation of the other
;;; EXAMPLES:
;;;     (permutation-of? (list 1 2 3) (list 1 2 3)) => true
;;;     (permutation-of? (list 3 1 2) (list 1 2 3)) => true
;;;     (permutation-of? (list 3 1 2) (list 1 2 4)) => false
;;;     (permutation-of? (list 1 2 3) (list 1 2)) => false
;;;     (permutation-of? (list) (list)) => true
(define (permutation-of? l1 l2)
  (equal? (sort l1 <) (sort l2 <)))

;;; shortlex-less-than? : IntList IntList -> Boolean
;;; GIVEN: two lists of integers
;;; RETURNS: true if and only either
;;;     the first list is shorter than the second
;;;  or both are non-empty, have the same length, and either
;;;         the first element of the first list is less than
;;;             the first element of the second list
;;;      or the first elements are equal, and the rest of
;;;             the first list is less than the rest of the
;;;             second list according to shortlex-less-than?
;;; EXAMPLES:
;;;     (shortlex-less-than? (list) (list)) => false
;;;     (shortlex-less-than? (list) (list 3)) => true
;;;     (shortlex-less-than? (list 3) (list)) => false
;;;     (shortlex-less-than? (list 3) (list 3)) => false
;;;     (shortlex-less-than? (list 3) (list 1 2)) => true
;;;     (shortlex-less-than? (list 3 0) (list 1 2)) => false
;;;     (shortlex-less-than? (list 0 3) (list 1 2)) => true
;;;     (shortlex-less-than? (list 1 2 2) (list 1 2 3)) => true
;;; Strategy: use observer template on IntList
(define (shortlex-less-than? l1 l2)
  (cond
    [(or (equal? l1 l2) (empty? l2)) false]
    [(or (< (length l1) (length l2)) (< (first l1) (first l2))) true]   
    [(= (first l1) (first l2))
     (shortlex-less-than? (rest l1) (rest l2))]
    [else false]))
(begin-for-test
  (check-equal?  (shortlex-less-than? (list) (list)) false
                 "it should return false")
  (check-equal?  (shortlex-less-than? (list) (list 3)) true
                 "it should return true")
  (check-equal?  (shortlex-less-than? (list 3) (list)) false
                 "it should return false")
  (check-equal?   (shortlex-less-than? (list 3) (list 3))  false
                  "it should return false")
  (check-equal?  (shortlex-less-than? (list 3) (list 1 2)) true
                 "it should return true")
  (check-equal? (shortlex-less-than? (list 3 0) (list 1 2)) false
                "it should return false")
  (check-equal? (shortlex-less-than? (list 0 3) (list 1 2)) true
                "it should return true")
  (check-equal? (shortlex-less-than? (list 1 2 2) (list 1 2 3)) true
                "it should return true"))

;; S-expressions
;; Constructor Templates
;; 
;; An Sexp is either
;; -- a Int 
;; -- an SexpList
;; 
;; An SexpList is either
;; -- empty
;; -- (cons Sexp SexpList)
;; Examples:
;; (list (list 1 (list 2 (list 3)) (list 3 (list 2))) 
;; (list 2 (list 1 (list 3)) (list 3 (list 1))) 
;; (list 3 (list 1 (list 2)) (list 2 (list 1))))

;;; permutations : IntList -> IntListList
;;; GIVEN: a list of integers
;;; WHERE: the list contains no duplicates
;;; RETURNS: a list of all permutations of that list,
;;;     in shortlex order
;;; EXAMPLES:
;;;     (permutations (list))  =>  (list (list))
;;;     (permutations (list 9))  =>  (list (list 9))
;;;     (permutations (list 3 1 2))
;;;         =>  (list (list 1 2 3)
;;;                   (list 1 3 2)
;;;                   (list 2 1 3)
;;;                   (list 2 3 1)
;;;                   (list 3 1 2)
;;;                   (list 3 2 1))
;;; (permutations (list 1 2)) => (list (list 1 2) (list 2 1)
;; Strategy: combine simpler functions
(define (permutations l)
  (sort (flatten (first-element-permutation l) empty) shortlex-less-than?))
#;
(define (permutations l)
  (if (<= 0 (length l) 1)
      (list l)
      (let* ([n (length l)] [l1 (permutation-list l n n n)])
        (sort (arrangement l1 empty) shortlex-less-than?))))
(begin-for-test
  (check-equal?  (permutations (list)) (list (list))
                 "it should be  (list (list))")
  (check-equal?  (permutations (list 9)) (list (list 9))
                 "it should be  (list (list 9)")
  (check-equal?  (permutations (list 3 1 2)) (list (list 1 2 3) (list 1 3 2)
                                                   (list 2 1 3) (list 2 3 1)
                                                   (list 3 1 2) (list 3 2 1))
                 "it returns wrong list")
  (check-equal? (permutations (list 1 2)) (list (list 1 2) (list 2 1))
                "it should be (list (list 1 2) (list 2 1)))"))

; HOF version of permutation-list
; first-element-permutation: Intlist -> Sexp
; Given: a list of int
; Returns: a Sexp which every element in the given list is the first.
; Strategy: use HOF map on l
; Examples:
; (first-element-permutation (list 1 2 3)) => 
; (list (list 1 (list 2 (list 3)) (list 3 (list 2))) 
; (list 2 (list 1 (list 3)) (list 3 (list 1))) 
; (list 3 (list 1 (list 2)) (list 2 (list 1))))
(define (first-element-permutation l)
  ; Int -> IntList
  ; Given: a int
  ; Returns: a list of x as first and the rest is apply first-element-permutation 
  ; on l without x 
  ; Examples: ((lambda (x) (cons x 
  ; (first-element-permutation (remove x (list 1 2 3))))) 3) => 
  ;(list 3 (list 1 (list 2)) (list 2 (list 1)))
  (map (lambda (x) (cons x (first-element-permutation (remove x l)))) l))
; Test
(begin-for-test 
  (check-equal? (first-element-permutation (list 1 2 3))
    (list (list 1 (list 2 (list 3)) (list 3 (list 2))) 
      (list 2 (list 1 (list 3)) (list 3 (list 1))) 
      (list 3 (list 1 (list 2)) (list 2 (list 1))))
    "it returns wrong list"))

; clearer version of arrangement
; flatten: Sexp IntList -> IntListList
; Given: given a Sexp and a list of int
; Returns: a list of IntList
; Strategy: use HOF map on l1 followed by append
;           and use observer template of Sexp
; Examples:
; (flatten (list (list 1 (list 2 (list 3)) (list 3 (list 2))) 
; (list 2 (list 1 (list 3)) (list 3 (list 1))) 
; (list 3 (list 1 (list 2)) (list 2 (list 1)))) empty)
; => (list (list 3 2 1) (list 2 3 1) (list 3 1 2) (list 1 3 2) (list 2 1 3) (list 1 2 3))
(define (flatten sexp l)
  (cond
    [(empty? sexp) (list l)]
    [(number? (first sexp)) (flatten (rest sexp) (cons (first sexp) l))]
    ; Sexp -> IntListList
    ; Given: a sexp
    ; Returns: a list of intList by applying flatten on the given Sexp.
    ; Examples: ((lambda (x) (flatten x l)) (list 1)) -> (flatten empty l) -> (list l)
    [else (foldr append empty (map (lambda (x) (flatten x l)) sexp))]
    ;[(empty? (rest sexp)) (append (flatten (first sexp) l) empty)]
    ;[else (append (flatten (first sexp) l) (flatten (rest sexp) l))]
    ))

; Test
(begin-for-test 
  (check-equal? (flatten (first-element-permutation (list 1 2 3)) empty) 
    (list (list 3 2 1) (list 2 3 1) (list 3 1 2) (list 1 3 2) (list 2 1 3) (list 1 2 3))
    "it returns wrong!"))

; permutation-list: IntList Integer Integer Integer -> XList
; Given: a list of integers
; and three integers which are the same when initial and equal to the length of List.
; Returns: a list of integers or XList or both
; Strategy: use observer template on List
; Examples: (permutation-list (list 1 2 3) 3 3 3)
; -> (list (list 1 (list 2 3) (list 3 2)) 
; (list 2 (list 3 1) (list 1 3)) 
; (list 3 (list 1 2) (list 2 1)))
#;
(define (permutation-list l n m count)
  (cond
    [(and (= count 0) (= m n)) empty]
    [(= m n 1) l]
    [(= m n)
     (cons (permutation-list l (- n 1) m (- n 1))
           (permutation-list (change-1st-to-end l) n m (- count 1)))]           
    [(and (> count 0) (< n m))
     (cons (first l) (permutation-list (rest l) n (- m 1) n))]
    ))
#;
(begin-for-test 
  (check-equal? (permutation-list (list 1 2 3) 3 3 3)
                (list (list 1 (list 2 3) (list 3 2)) 
                      (list 2 (list 3 1) (list 1 3)) 
                      (list 3 (list 1 2) (list 2 1)))
                "it returns wrong result"))

; arrangement: XList IntList -> IntListList
; Given: a list of integers or XList or both and a IntList which is empty when initial
; for first time.
; Returns: a list of IntList
; Strategy: use observer template of List
; Examples: (arrangement tree-like-xlist empty) ->
; (list (list 3 2 1) (list 2 3 1) (list 1 3 2) (list 3 1 2) (list 2 1 3) (list 1 2 3))
#;
(define (arrangement l1 l2)
  (cond
    [(empty? l1) l2]
    [(number? (first l1)) (arrangement (rest l1) (cons (first l1) l2))]
    [(= (length (first l1)) 2)
     (cons (arrangement (first l1) l2) (to-end l1 l2))]
    [else (append (arrangement (first l1) l2) (to-end l1 l2))]))

;Tests
(define tree-like-xlist 
  (list (list 1 (list 2 3) (list 3 2)) 
        (list 2 (list 3 1) (list 1 3)) 
        (list 3 (list 1 2) (list 2 1))))
#;
(begin-for-test
  (check-equal? (arrangement tree-like-xlist empty)
                (list (list 3 2 1) (list 2 3 1) (list 1 3 2) (list 3 1 2) (list 2 1 3) (list 1 2 3))
                "it is wrong of input"))

; to-end XList IntList -> IntListList
; Given: a list of integers or XList or both and a IntList
; Returns: empty if rest of the given XList is empty and first of it is list
; otherwise return arrangement
; Strategy: use obserber tamplate of List and cases on List
; Examples: (to-end (list (list 1)) empty) -> empty
; (to-end (list (list 1) (list 2)) empty) -> (arrangement (list 2) empty)
#;
(define (to-end l1 l2)
  (if (and (list? (first l1)) (empty? (rest l1)))
      empty
      (arrangement (rest l1) l2)))
#;
(begin-for-test
  (check-equal?  (to-end (list (list 1)) empty)  empty 
                 "it should be empty")
  (check-equal? (to-end (list (list 1) (list 2)) empty)
                (arrangement (list 2) empty) ""))

; change-1st-to-end: IntList -> IntList
; Given: a list of integers where the list at least contains two integers.
; Returns: a list which is the same as the given list 
; except that the first item is changed to the end of the list
; Strategy: use observer template on IntList
; Examples: (change-1st-to-end (list 1 2 3)) -> (list 2 3 1)
#;
(define (change-1st-to-end l)
  (append (rest l) (list (first l))))
#;
(begin-for-test
  (check-equal? (change-1st-to-end (list 1 2 3)) (list 2 3 1)
                "it should be (list 2 3 1)"))