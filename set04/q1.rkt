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
(define (max-count l)
  (let ([count (length l)])
    (* count (- count 1) 1/2)))
(define (new-count count l)
  (- count (- (length l) 2)))

(define (permutation-of? l1 l2)
  (let ([count (max-count l2)])
    (permutation-count l1 l2 count)))

(define (permutation-count l1 l2 count)
  (cond
    [(and (empty? l1) (empty? l2)) true]
    [(or (empty? l1) (empty? l2)) false]
    [(< count 0) false]
    [(= (first l1) (first l2))
     (permutation-count (rest l1) (rest l2) (new-count count l2))]
    [else
     (permutation-count l1 (change-1st-to-end l2) (- count 1))]))

(define (change-1st-to-end l)
  (append (rest l) (list (first l))))

(begin-for-test
  (check-equal? (permutation-of? (list 1 2 3) (list 1 2 3)) true
                "it should return true")
  (check-equal? (permutation-of? (list 3 1 2) (list 1 2 3)) true
                "it should return true")
  (check-equal? (permutation-of? (list 3 1 2) (list 1 2 4)) false
                "it should return false")
  (check-equal? (permutation-of? (list 1 2 3) (list 1 2)) false
                "it should return false")
  (check-equal? (permutation-of? (list) (list)) true
                "it should return true"))

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


(define (shortlex-less-than? l1 l2)
  (cond
    [(equal? l1 l2) false]
    [(empty? l2) false]
    [(< (length l1) (length l2)) true]   
    [(< (first l1) (first l2)) true]
    [(= (first l1) (first l2))
     (shortlex-less-than? (rest l1) (rest l2))]
    [else false]
    ))

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


;; insert : Integer SortedIntList -> SortedIntList
;; GIVEN: An integer and a sorted sequence of integers
;; RETURNS: A new SortedIntList just like the
;;   original, but with the new integer inserted.
;; EXAMPLES:
;; (insert 3 empty) = (list 3)
;; (insert 3 (list 5 6)) = (list 3 5 6)
;; (insert 3 (list -1 1 5 6)) 
;;    = (list -1 1 3 5 6)
;; STRATEGY: Use observer template for
;; SortedIntList
(define (insert n seq)
  (cond
    [(empty? seq) (list n)]
    [(shortlex-less-than? n (first seq)) (cons n seq)]
    [else (cons (first seq)
                (insert n (rest seq)))]))

(define (mysort permutations)
  (cond
    [(empty? permutations) empty]
    [else (insert (first permutations)
                  (mysort (rest permutations)))]))

(define (arrangement l1 l2)
  (cond
    [(empty? l1) l2]
    [(number? (first l1)) (arrangement (rest l1) (cons (first l1) l2) )]
    [else (adjunction l1 l2)]))

(define (adjunction l1 l2)
  (if (= (length (first l1)) 2)
      (cons (arrangement (first l1) l2) (to-end? l1 l2))
      (append (arrangement (first l1) l2) (to-end? l1 l2)))
  )
(define (to-end? l1 l2)
  (if (and (list? (first l1)) (empty? (rest l1)))
      empty
      (arrangement (rest l1) l2)))

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
(define (permutations l)
  (if (<= 0 (length l) 1)
      (list l)
      (let* ([n (length l)] [l1 (permutation-list l n n n)])
        (mysort (arrangement l1 empty)))))

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
	
