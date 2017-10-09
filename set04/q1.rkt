;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/universe)
(require 2htdp/image)
(require "extras.rkt")
(provide
 inner-product
 permutation-of? 
 shortlex-less-than?
 permutations)
(check-location "04" "q1.rkt")

;;; inner-product : RealList RealList -> Real
;;; GIVEN: two lists of real numbers
;;; WHERE: the two lists have the same length
;;; RETURNS: the inner product of those lists
;;; EXAMPLES:
;;;     (inner-product (list 2.5) (list 3.0))  =>  7.5
;;;     (inner-product (list 1 2 3 4) (list 5 6 7 8))  =>  70
;;;     (inner-product (list) (list))  =>  0
(define (inner-product l1 l2)
  (if(empty? l1) 0
     (+ (* (first l1) (first l2)) 
        (inner-product (rest l1) (rest l2)))))
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
  (let ([count (max-count l2)])
    (permutation-comparator l1 l2 count)))
(begin-for-test
  (check-equal?  (permutation-of? (list 1 2 3) (list 1 2 3)) true
                 "it should be the permutation")
  (check-equal?  (permutation-of? (list) (list 1 2 3)) false
                 "it should be not the permutation")
  (check-equal?  (permutation-of?  (list 3 1 2) (list 1 2 3)) true
                 "it should be the permutation")
  (check-equal?  (permutation-of?  (list 3 1 2) (list 1 2 4)) false
                 "it should be not the permutation")
  (check-equal?  (permutation-of? (list 1 2 3) (list 1 2)) false
                 "it should not be the permutation")
  (check-equal?  (permutation-of? (list) (list)) true
                 "it should be the permutation"))

; another way to implement the permutation-of? function using sort
#;
(define (permutation-of? l1 l2)
  (cond
    [(and (empty? l1) (empty? l2)) true]
    [(or (empty? l1) (empty? l2)) false]
    [else (equal? (sort l1 <) (sort l2 <))]))

;;; permutation-comparator : IntList IntList Integer -> Boolean
;;; GIVEN: two lists of integers and the max-count of the second list
;;; WHERE: neither list contains duplicate elements
;;; RETURNS: true if and only if one of the lists
;;;     is a permutation of the other
;;; Strategy: user observer template on IntList
;;; EXAMPLES:
;;;     (permutation-comparator (list 1 2 3) (list 1 2 3)) => true
;;;     (permutation-comparator (list 3 1 2) (list 1 2 3)) => true
;;;     (permutation-comparator (list 3 1 2) (list 1 2 4)) => false
;;;     (permutation-comparator (list 1 2 3) (list 1 2)) => false
;;;     (permutation-comparator (list) (list)) => true
(define (permutation-comparator l1 l2 count)
  (cond
    [(and (empty? l1) (empty? l2)) true]
    [(or (empty? l1) (empty? l2) (< count 0)) false]
    [(= (first l1) (first l2))
     (permutation-comparator (rest l1) (rest l2) (new-count count l2))]
    [else
     (permutation-comparator l1 (change-1st-to-end l2) (- count 1))]))
(begin-for-test
  (check-equal? (permutation-comparator (list 3 1 2) (list 1 2 3) 3) true
                "it should return true")
  (check-equal? (permutation-comparator (list 3 1 2) (list 1 2 4) 3) false
                "it should return false")
  (check-equal? (permutation-comparator (list 1 2 3) (list 1 2) 1) false
                "it should return false")
  (check-equal? (permutation-comparator (list) (list) 0) true
                "it should return true"))
; max-count: IntList -> Int
; Given: a list of integers
; Returns: (n(n-1)/2) in which n is the length of the given list
; Examples:  (max-count (list 1 2 3)) => 3 
; Strategy: translation of formula
(define (max-count l)
  (let ([count (length l)])
    (* count (- count 1) 1/2)))
(begin-for-test
  (check-equal? (max-count (list 1 2 3)) 3 "it should return 3") 
  (check-equal? (max-count (list)) 0 "it should return 0"))

; max-count: Integer IntList -> Int
; Given: a number and a list of integers
; Returns:  a number which is the result of the given number minus the length of list
; and plus 2
; Examples:  (new-count 3 (list 1 2 3)) => 2 
; Strategy: translation of formula
(define (new-count count l)
  (- count (- (length l) 2)))
(begin-for-test
  (check-equal? (new-count 3 (list 1 2 3)) 2 "it should return 2"))

; change-1st-to-end: IntList -> IntList
; Given: a list of integers where the list at least contains two integers.
; Returns: a list which is the same as the given list 
; except that the first item is changed to the end of the list
; Examples: (change-1st-to-end (list 1 2 3)) -> (list 2 3 1)
(define (change-1st-to-end l)
  (append (rest l) (list (first l))))
(begin-for-test
  (check-equal? (change-1st-to-end (list 1 2 3)) (list 2 3 1)
                "it should be (list 2 3 1)"))

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

; arrangement: XList IntList -> IntListList
; Given: a list of integers or XList or both and a IntList which is empty when initial
; for first time.
; Returns: a list of IntList
; Strategy: use observer template of List
; Examples: (arrangement tree-like-xlist empty) ->
; (list (list 3 2 1) (list 2 3 1) (list 1 3 2) (list 3 1 2) (list 2 1 3) (list 1 2 3))
(define (arrangement l1 l2)
  (cond
    [(empty? l1) l2]
    [(number? (first l1)) (arrangement (rest l1) (cons (first l1) l2))]
    [(= (length (first l1)) 2)
     (cons (arrangement (first l1) l2) (to-end? l1 l2))]
    [else (append (arrangement (first l1) l2) (to-end? l1 l2))]))

;Tests
(define tree-like-xlist 
  (list (list 1 (list 2 3) (list 3 2)) 
        (list 2 (list 3 1) (list 1 3)) 
        (list 3 (list 1 2) (list 2 1))))
(begin-for-test
  (check-equal? (arrangement tree-like-xlist empty)
                (list (list 3 2 1) (list 2 3 1) (list 1 3 2) (list 3 1 2) (list 2 1 3) (list 1 2 3))
                "it is wrong of input"))

; to-end? XList IntList -> IntListList
; Given: a list of integers or XList or both and a IntList
; Returns: empty if rest of the tree-like list is empty and first is list
; otherwise return arrangement
; Strategy: use obserber tamplate of List and cases on List
; Examples: (to-end? (list (list 1)) empty) -> empty
; (to-end? (list (list 1) (list 2)) empty) -> (arrangement (list 2) empty)
(define (to-end? l1 l2)
  (if (and (list? (first l1)) (empty? (rest l1)))
      empty
      (arrangement (rest l1) l2)))
(begin-for-test
  (check-equal?  (to-end? (list (list 1)) empty)  empty 
                 "it should be empty")
  (check-equal? (to-end? (list (list 1) (list 2)) empty)
                (arrangement (list 2) empty) ""))

; permutation-list: IntList Integer Integer Integer -> XList
; Given: a list of integers
; and three integers which are the same when initial and equal to the length of List.
; Returns: a list of integers or XList or both
; Strategy: use observer template on List
; Examples: (permutation-list (list 1 2 3) 3 3 3)
; -> (list (list 1 (list 2 3) (list 3 2)) 
; (list 2 (list 3 1) (list 1 3)) 
; (list 3 (list 1 2) (list 2 1)))
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
(begin-for-test 
  (check-equal? (permutation-list (list 1 2 3) 3 3 3)
                (list (list 1 (list 2 3) (list 3 2)) 
                      (list 2 (list 3 1) (list 1 3)) 
                      (list 3 (list 1 2) (list 2 1)))
                "it returns wrong result"))

;; User defined sort function which is defined before I use system sort function	
;; insert : IntList IntListList -> IntListList
;; GIVEN: An IntList and A list of IntList 
;  which is sorted by shortlex-less-than?
;; RETURNS: A new IntListList just like the
;;   original one, but with the new IntList inserted.
;; EXAMPLES:
;; (insert empty empty) = (list empty)
;; (insert (list 6 2) (list 5 6)) = (list (list 5 6) (list 6 2))
;; STRATEGY: Use observer template for IntListList
(define (insert n seq)
  (cond
    [(empty? seq) (list n)]
    [(shortlex-less-than? n (first seq)) (cons n seq)]
    [else (cons (first seq)
                (insert n (rest seq)))]))
(begin-for-test
  (check-equal? (insert empty empty) (list empty))
  (check-equal? (insert (list 6 2) (list (list 5 6))) (list (list 5 6) (list 6 2))))

; musort: IntListList -> IntListList
; Given: a list of IntList
; Returns: a sorted IntListList of the given one sorting by
; the function shortlex-less-than? if a list is shortlex-less-than another
; the first one is in the first place.
; Strategy: Use observer template for IntListList on permutaions
; Examples: (mysort (list (list 3 2) (list 1 2))) -> (list (list 1 2) (list 3 2))
; (mysort (list (list 1 2) (list 1 4))) -> (list (list 1 2) (list 1 4))
(define (mysort permutations)
  (cond
    [(empty? permutations) empty]
    [else (insert (first permutations)
                  (mysort (rest permutations)))]))
(begin-for-test
  (check-equal? (mysort (list (list 3 2) (list 1 2))) (list (list 1 2) (list 3 2))
                "it should be (list (list 1 2) (list 3 2)")
  (check-equal? (mysort (list (list 1 2) (list 1 4))) (list (list 1 2) (list 1 4))
                "it should be (list (list 1 2) (list 1 4)"))