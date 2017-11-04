;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(require "q1.rkt")

(provide
 tie
 defeated
 defeated?
 outranks
 outranked-by
 power-ranking)
(check-location "08" "q2.rkt")

; A OutcomeResult is the result of a competitor in all outcomes represented
; as a struct (make-outcome-r comparator outranks outranked percentage)
; -competitor Competitor   the owner of this outcome result
; -outranks NonNegInteger  indicates the number of competitors outranked by the owner
; -outranked NonNegInteger indicates the number of competitors that outrank the owner
; -percentage NonNegReal   the number of outcomes in which the owner defeats or ties 
;    another competitor divided by the number of outcomes that mention the owner. 
(define-struct outcome-r (competitor outranks outranked percentage))
; CONSTRUCTOR TEMPLATE
; (make-outcome-r Competitor NonNegInteger NonNegInteger NonNegReal)
; OBSERVER TEMPLATE
#;
(define (outcome-r-fn r)
  (...(outcome-r-competitor r)
      (outcome-r-outranks r)
      (outcome-r-outranked r)
      (outcome-r-percentage r)))

; A OutcomeResultList is one of
; -empty
; -(cons r rslt)
; WHERE: r is OutcomeResult, rslt is OutcomeResultList
; OBSERVER TEMPLATE
#;
(define (rslt-fn rslt)
  (cond
    [(empty? rslt) ...]
    [else (outcome-r-fn (first rslt)
                        (rslt-fn (rest rslt)))]))

(define results (list
                 (make-outcome-r "A" 3 0 1)
                 (make-outcome-r "D" 2 4 1/2)
                 (make-outcome-r "E" 0 3 0)
                 (make-outcome-r "C" 4 0 1)
                 (make-outcome-r "B" 2 4 1/2)
                 (make-outcome-r "F" 1 1 1/2)))

(define sorted-results (list
                        (make-outcome-r "C" 4 0 1)
                        (make-outcome-r "A" 3 0 1)
                        (make-outcome-r "F" 1 1 1/2)
                        (make-outcome-r "E" 0 3 0)
                        (make-outcome-r "B" 2 4 1/2)
                        (make-outcome-r "D" 2 4 1/2)))

(define outcomes (list (defeated "A" "D")
                       (defeated "A" "E")
                       (defeated "C" "B")
                       (defeated "C" "F")
                       (tie "D" "B")
                       (defeated "F" "E")))

(define competitors (list "A" "D" "E" "C" "B" "F"))

; A ComparatorList is a one of
; -empty
; -(cons comparator competitors)
; WHERE: comparator is a function as (X X -> Boolean) 
; competitors is ComparatorList
; OBSERVER TEMPLATE
#;
(define (cplst-fn comparators)
	(cond
		[(empty? comparators) ...]
		[else ... (first comparators) 
		(cplst-fn (rest comparators))]))

;;; power-ranking : OutcomeList -> CompetitorList
;;; GIVEN: a list of outcomes
;;; RETURNS: a list of all competitors mentioned by one or more
;;;     of the outcomes, without repetitions, with competitor A
;;;     coming before competitor B in the list if and only if
;;;     the power-ranking of A is higher than the power ranking
;;;     of B.
;;; EXAMPLE:
;;;     (power-ranking
;;;      (list (defeated "A" "D")
;;;            (defeated "A" "E")
;;;            (defeated "C" "B")
;;;            (defeated "C" "F")
;;;            (tie "D" "B")
;;;            (defeated "F" "E")))
;;;  => (list "C"   ; outranked by 0, outranks 4
;;;           "A"   ; outranked by 0, outranks 3
;;;           "F"   ; outranked by 1
;;;           "E"   ; outranked by 3
;;;           "B"   ; outranked by 4, outranks 12, 50%
;;;           "D")  ; outranked by 4, outranks 12, 50%
;;; Strategy: use HOF map on OutcomeResultList
(define (power-ranking olst)
  (map outcome-r-competitor (sort-of-result (results-of-competitors olst))))
; Test
(begin-for-test
  (check-equal? (power-ranking outcomes) (list "C" "A" "F" "E" "B" "D")))

; sort-of-result: OutcomeResultList -> OutcomeResultList
; GIVEN: a list of outcome result
; RETURNS: sorted list of the given one by power-ranking higher than
; Strategy: call general functions
; EXAMPLES: (sort-of-result results) => (list
; (make-outcome-r "C" 4 0 1)
; (make-outcome-r "A" 3 0 1)
; (make-outcome-r "F" 1 1 1/2)
; (make-outcome-r "E" 0 3 0)
; (make-outcome-r "B" 2 4 1/2)
; (make-outcome-r "D" 2 4 1/2))
(define (sort-of-result rslt)
	; OutcomeResultList ComparatorList -> OutcomeResultList
	; GIVEN: a OutcomeResultList rslt and a ComparatorList comparators
	; WHERE: comparators is a list of functions passed to sort as the comparator
	; to sort rslt
	; RETURNS: a list like rslt except it is sorted by comparators 
	; Strategy: use observer template of ComparatorList
	; Halting Measure: the length of comparators
  (local [(define (helper rslt comparators)
            (cond
              [(empty? comparators) rslt]
              [else (helper (sort rslt (first comparators)) (rest comparators))]))]
    (helper rslt (list outranked-less-than? outranks-more-than?
                       percentage-more-than? string-less-than?))))
; Test
(begin-for-test
  (check-equal? (sort-of-result results) sorted-results "it returns wrong"))

; results-of-competitors: OutcomeList -> OutcomeResultList
; GIVEN: a list of outcomes
; RETURNS: a list of outcome results of every competitors
; Strategy: use HOF map on CompetitorList
; EXAMPLES: (results-of-competitors outcomes) => (list
; (make-outcome-r "A" 3 0 1)
; (make-outcome-r "D" 2 4 1/2)
; (make-outcome-r "E" 0 3 0)
; (make-outcome-r "C" 4 0 1)
; (make-outcome-r "B" 2 4 1/2)
; (make-outcome-r "F" 1 1 1/2))
(define (results-of-competitors olst)
  (let ([clst (list-of-competitors olst)])
    ; Competitor -> OutcomeResult
    ; RETURNS: the result of outcomes of the given competitor
    ; Strategy: use construct template of OutcomeResult
    (map (lambda (c) (make-outcome-r c 
                                     (length (outranks c olst)) 
                                     (length (outranked-by c olst))
                                     (no-losing-percentage c olst clst)))
         clst)))
; Test
(begin-for-test
  (check-equal? (results-of-competitors outcomes) results "it returns wrong"))

; list-of-competitors: OutcomeList -> CompetitorList
; GIVEN: a OutcomeList olst
; RETURNS: a list of all competitors in olst without repetitions
; Strategy: use HOF map on olst followed by apply
; EXAMPLES: (list-of-competitors outcomes) => (list "A" "D" "E" "C" "B" "F")
(define (list-of-competitors olst)
  (remove-duplicates
   ; Outcome -> CompetitorList
   ; RETURNS: a list of two competitors of the given outcome
   (apply append (map (lambda (o) (cond
                                    [(defeat? o) 
                                     (list (defeat-winner o) (defeat-loser o))]
                                    [(tie? o) 
                                    (tie-t-competitors o)])) 
                      olst))))
; Test
(begin-for-test
  (check-equal? (list-of-competitors outcomes) (list "A" "D" "E" "C" "B" "F")
                "it returns wrong list"))

; mentions?: Competitor Outcome -> Boolean
; GIVEN: a Competitor c and an Outcome out
; RETURNS: true iff c is mentioned by out
; Strategy: use observer template of Outcome and Defeat
; EXAMPLES: (mentions? A (tie A B)) -> true
(define (mentions? c out)
  (cond
    [(defeat? out) (or (equal? c (defeat-winner out))
                       (equal? c (defeat-loser out)))]
    [(tie? out) (member-in-tie? c out)]))
; Test
(begin-for-test
  (check-true (mentions? "A" (tie "A" "B")) "it shou return true"))

; no-losing-percentage: Competitor OutcomeList CompetitorList -> NonNegReal
; GIVEN: a Competitor c an OutcomeList olst and a CompetitorList clst
; RETURNS: the number of outcomes in which c defeats or ties another competitor
; divided by the number of outcomes that mention c
; Strategy: use HOF filter on clst and olst
; EXAMPLES: (no-losing-percentage "D" outcomes competitors) => 1/2 
(define (no-losing-percentage c olst clst)
  ; Competitor -> Boolean
  ; RETURNS: true if c defeated or tied the given competitor c2
  (let ([outranks (length (filter (lambda (c2) 
                                    (and (not (equal? c c2)) (defeated? c c2  olst)))
                                  clst))]
        ; Outcome -> Boolean
        ; RETURNS: true iff c is mentioned in the given outcome o
        [mentions (length (filter (lambda (o) (mentions? c o))
                                  olst))])
    (/ outranks mentions)))
; Test
(begin-for-test
  (check-equal? (no-losing-percentage "D" outcomes competitors) 1/2 
                "it should be 1/2"))

; outranked-less-than?: OutcomeResult OutcomeResult -> Boolean
; GIVEN: two OutcomeResult r1 and r2
; RETURNS: true if the outranked of r1 is less than the one of r2
; Strategy: use observer template of OutcomeResult
; EXAMPLES: (outranked-less-than? (make-outcome-r "B" 2 4 1/2)
; (make-outcome-r "D" 2 4 1/2)) => false
(define (outranked-less-than? r1 r2)
  (< (outcome-r-outranked r1) (outcome-r-outranked r2)))
; Test
(begin-for-test
  (check-equal? (outranked-less-than? (make-outcome-r "B" 2 4 1/2)
                                      (make-outcome-r "D" 2 4 1/2)) false
  "it should return false"))

; outranks-more-than?: OutcomeResult OutcomeResult -> Boolean
; GIVEN: two OutcomeResult r1 and r2
; RETURNS: true if the outranked of r1 and r2 are same
; and the outranks of r1 is larger than the outranks of r2
; Strategy: use observer template of OutcomeResult
; EXAMPLES:(outranks-more-than? (make-outcome-r "B" 2 4 1/2)
; (make-outcome-r "D" 2 4 1/2)
(define (outranks-more-than? r1 r2)
  (and (= (outcome-r-outranked r1) (outcome-r-outranked r2))
       (> (outcome-r-outranks r1) (outcome-r-outranks r2))))
; Test
(begin-for-test
  (check-equal? (outranks-more-than? (make-outcome-r "B" 2 4 1/2)
                                     (make-outcome-r "D" 2 4 1/2)) false
  "it should return false"))

; percentage-more-than?: OutcomeResult OutcomeResult -> Boolean
; GIVEN: two OutcomeResult r1 and r2
; RETURNS: true if the outranked outranks of r1 and r2 are same
; and the percentage of r1 is larger than the percentage of r2
; Strategy: use observer template of OutcomeResult
; EXAMPLES: (percentage-more-than? (make-outcome-r "B" 2 4 1/2)
; (make-outcome-r "D" 2 4 1/2)) => false
(define (percentage-more-than? r1 r2)
  (and (= (outcome-r-outranked r1) (outcome-r-outranked r2))
       (= (outcome-r-outranks r1) (outcome-r-outranks r2))
       (> (outcome-r-percentage r1) (outcome-r-percentage r2))))
; Test
(begin-for-test
  (check-equal? (percentage-more-than? (make-outcome-r "B" 2 4 1/2)
                                       (make-outcome-r "D" 2 4 1/2)) false
  "it should return false"))

; string-less-than?: OutcomeResult OutcomeResult -> Boolean
; GIVEN: two OutcomeResult r1 and r2
; RETURNS: true if the outranked outranks percentage of r1 and r2 are same
; and competitor of r1 is string< the competitor of r2
; Strategy: use observer template of OutcomeResult
; EXAMPLES: (string-less-than? (make-outcome-r "B" 2 4 1/2)
; (make-outcome-r "D" 2 4 1/2)=> true
(define (string-less-than? r1 r2)
  (and (= (outcome-r-outranked r1) (outcome-r-outranked r2))
       (= (outcome-r-outranks r1) (outcome-r-outranks r2))
       (= (outcome-r-percentage r1) (outcome-r-percentage r2))
       (string<? (outcome-r-competitor r1) (outcome-r-competitor r2))))
; Test
(begin-for-test
  (check-true (string-less-than? (make-outcome-r "B" 2 4 1/2)
                                 (make-outcome-r "D" 2 4 1/2))
  "it should return true"))