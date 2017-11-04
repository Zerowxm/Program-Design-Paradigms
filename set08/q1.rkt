;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(require "common.rkt")
(provide
 tie
 defeated
 defeated?
 outranks
 outranked-by)
(check-location "08" "q1.rkt")

(define A "A")
(define B "B")
(define C "C")

;;; tie : Competitor Competitor -> Tie
;;; GIVEN: the names of two competitors
;;; RETURNS: an indication that the two competitors have
;;;     engaged in a contest, and the outcome was a tie
;;; EXAMPLE: (see the examples given below for defeated?,
;;;     which shows the desired combined behavior of tie
;;;     and defeated?)
;;; Strategy: use construct template of Tie
(define (tie c1 c2)
  (make-tie-t (list c1 c2)))
; Test
(begin-for-test
  (check-equal? (tie A B) (make-tie-t (list A B)) "it returns wrong"))

;;; defeated : Competitor Competitor -> Defeat
;;; GIVEN: the names of two competitors
;;; RETURNS: an indication that the two competitors have
;;;     engaged in a contest, with the first competitor
;;;     defeating the second
;;; EXAMPLE: (see the examples given below for defeated?,
;;;     which shows the desired combined behavior of defeated
;;;     and defeated?)
;;; Strategy: use construct template of Defeat
(define (defeated c1 c2)
  (make-defeat c1 c2))
; Test
(define A-defeat-B (make-defeat A B))
(begin-for-test
  (check-equal? (defeated A B) A-defeat-B "it should be A defeat B"))

;;; defeated? : Competitor Competitor OutcomeList -> Boolean
;;; GIVEN: the names of two competitors and a list of outcomes
;;; RETURNS: true if and only if one or more of the outcomes indicates
;;;     the first competitor has defeated or tied the second
;;; EXAMPLES:
;;;     (defeated? "A" "B" (list (defeated "A" "B") (tie "B" "C")))
;;;  => true
;;;
;;;     (defeated? "A" "C" (list (defeated "A" "B") (tie "B" "C")))
;;;  => false
;;;
;;;     (defeated? "B" "A" (list (defeated "A" "B") (tie "B" "C")))
;;;  => false
;;;
;;;     (defeated? "B" "C" (list (defeated "A" "B") (tie "B" "C")))
;;;  => true
;;;
;;;     (defeated? "C" "B" (list (defeated "A" "B") (tie "B" "C")))
;;;  => true
;;; Strategy: use HOF ormap on OutcomeList
(define (defeated? c1 c2 olst)
  ; CompetitorList -> Boolean
  ; GIVEN: a CompetitorList clst
  ; Where: clst is the competitors of a tie
  ; RETURNS: true iff two competitors c1 c2 are in the given list
  (local [(define (member-in-tie? clst)
            (and (member? c1 clst) (member? c2 clst)))]
    ; Outcome -> Boolean
    ; RETURNS: true iff the outcome indicates 
    ; the first competitor has defeated or tied the second
    ; Strategy: use observer template of Outcome
    (ormap (lambda(out) (cond
                          [(defeat? out) (and (equal? c1 (defeat-winner out))
                                              (equal? c2 (defeat-loser out)))]
                          [(tie? out) (member-in-tie? (tie-t-competitors out))]))
           olst)))
; Test
(begin-for-test
  (check-equal? (defeated? "A" "B" (list (defeated "A" "B") (tie "B" "C")))
                true "it should return true")
  (check-equal? (defeated? "A" "C" (list (defeated "A" "B") (tie "B" "C")))
                false "it should return false")
  (check-equal?  (defeated? "B" "A" (list (defeated "A" "B") (tie "B" "C")))
                 false "it should return false")
  (check-equal?  (defeated? "B" "C" (list (defeated "A" "B") (tie "B" "C")))
                 true "it should return true")
  (check-equal? (defeated? "C" "B" (list (defeated "A" "B") (tie "B" "C")))
                true "it should return true"))

(define OUTRANKS #f)
(define OUTRANKED #t)
;;; outranks : Competitor OutcomeList -> CompetitorList
;;; GIVEN: the name of a competitor and a list of outcomes
;;; RETURNS: a list of the competitors outranked by the given
;;;     competitor, in alphabetical order
;;; NOTE: it is possible for a competitor to outrank itself
;;; EXAMPLES:
;;;     (outranks "A" (list (defeated "A" "B") (tie "B" "C")))
;;;  => (list "B" "C")
;;;
;;;     (outranks "B" (list (defeated "A" "B") (defeated "B" "A")))
;;;  => (list "A" "B")
;;;
;;;     (outranks "C" (list (defeated "A" "B") (tie "B" "C")))
;;;  => (list "B" "C")
;;; Strategy: call general functions
(define (outranks c olst)
  (sort (outranks-or-outranked c olst OUTRANKS) string<?))
; Test
(begin-for-test
  (check-equal? (outranks "A" (list (defeated "A" "B") (tie "B" "C")))
                (list "B" "C") "it returns wrong")
  (check-equal? (outranks "B" (list (defeated "A" "B") (defeated "B" "A")))
                (list "A" "B") "it returns wrong")
  (check-equal? (outranks "C" (list (defeated "A" "B") (tie "B" "C")))
                (list "B" "C") "it returns wrong")
  (check-equal? (outranks "C" (list (tie "B" "C") (defeated "A" "B")))
                (list "B" "C") "it returns wrong")
  (check-equal? (outranks "A" (list (defeated "A" "B") (tie "B" "C") (tie "C" "E")))
                (list "B" "C" "E")  "it returns wrong")
  (check-equal? (outranks "A" (list (defeated "A" "B") (defeated "B" "C") 
                                    (defeated"C" "E"))) (list "B" "C" "E")
                                                        "it returns wrong"))

;;; outranked-by : Competitor OutcomeList -> CompetitorList
;;; GIVEN: the name of a competitor and a list of outcomes
;;; RETURNS: a list of the competitors that outrank the given
;;;     competitor, in alphabetical order
;;; NOTE: it is possible for a competitor to outrank itself
;;; EXAMPLES:
;;;     (outranked-by "A" (list (defeated "A" "B") (tie "B" "C")))
;;;  => (list)
;;;
;;;     (outranked-by "B" (list (defeated "A" "B") (defeated "B" "A")))
;;;  => (list "A" "B")
;;;
;;;     (outranked-by "C" (list (defeated "A" "B") (tie "B" "C")))
;;;  => (list "A" "B" "C")
; Strategy: call general functions
(define (outranked-by c olst)
  (sort (outranks-or-outranked c olst OUTRANKED) string<?))
; Test
(begin-for-test
  (check-equal? (outranked-by "A" (list (defeated "A" "B") (tie "B" "C")))
                (list) "it returns wrong")
  (check-equal? (outranked-by "B" (list (defeated "A" "B") (defeated "B" "A")))
                (list "A" "B") "it returns wrong")
  (check-equal? (outranked-by "C" (list (defeated "A" "B") (tie "B" "C")))
                (list "A" "B" "C") "it returns wrong"))

;;; outranks-or-outranked : Competitor OutcomeList Boolean-> CompetitorList
;;; GIVEN: the name of a competitor and
;;; a list of outcomes and a Boolean outranked?
;;; RETURNS: a list of the competitors that outrank the given
;;;     competitor, in alphabetical order if outranked is ture
;;; otherwise a list of the competitors outranked by the given competitor
;;; in alphabetical order
;;; EXAMPLES:
;;;     (outranks-or-outranked "A" (list (defeated "A" "B") (tie "B" "C"))
;;;                                                    OUTRANKED) => (list)
; (outranks-or-outranked "A" (list (defeated "A" "B") (tie "B" "C")) OUTRANKS)
;                => '("B" "C") 
; Strategy: use HOF map on OutcomeList followed by apply
(define (outranks-or-outranked c olst outranked?)
  (let* ([outrank (if (equal? true outranked?) 
                      defeated-and-tied-by 
                      defeated-and-tied-of)]
         [outranked (outrank c olst)])
    (local [(define (helper competitors outranked)
              (let ([competitors
                     (filter (lambda (x) (not (member? x outranked)))
                             ; Competitor -> CompetitorList
                             ; RETURNS: a list of the competitors outranked by c
                             (apply append (map
                                            (lambda (c) (outrank c olst))
                                            competitors)))]
                    [outranked (append outranked competitors)])
                (cond
                  [(empty? competitors) outranked]
                  [else (helper competitors outranked)])))]
      (remove-duplicates (helper outranked outranked)))))
; Test
(begin-for-test
  (check-equal? (outranks-or-outranked "A" (list (defeated "A" "B") (tie "B" "C"))
                                       OUTRANKED) (list) "it returns wrong")
  (check-equal? (outranks-or-outranked "A" (list (defeated "A" "B") (tie "B" "C"))
                                       OUTRANKS) '("B" "C") "it returns wrong"))

(define OF #f)
(define BY #t)
; defeated-and-tied-of: Competitor OutcomeList -> CompetitorList
; GIVEN: a Competitor c and OutcomeList olst
; RETURNS: a list of the competitors outranked by the given competitor c
; Strategy: call general functions
; EXAMPLES: (defeated-and-tied-of "A" (list (defeated "A" "B") (tie "B" "C")))
;  => (list "B" "C")
(define (defeated-and-tied-of c olst)
  (defeated-and-tied c olst OF))
; Test
(begin-for-test
  (check-equal? (defeated-and-tied-of "A" (list (defeated "A" "B") (tie "B" "C")))
                (list "B") "it returns wrong"))

; defeated-and-tied-by: Competitor OutcomeList -> CompetitorList
; GIVEN: a Competitor c and OutcomeList olst
; RETURNS: a list of the competitors that outrank the given competitor c
; Strategy: call general functions
; EXAMPLES:  (defeated-and-tied-by "A" (list (defeated "A" "B") (tie "B" "C"))) 
; => (list)
(define (defeated-and-tied-by c olst)
  (defeated-and-tied c olst BY))
; Test
(begin-for-test
  (check-equal? (defeated-and-tied-by "A" (list (defeated "A" "B") (tie "B" "C")))
                empty "it should be empty"))

; defeated-and-tied: Competitor OutcomeList Boolean -> CompetitorList
; GIVEN: a Competitor c and a OutcomeList olst and a Boolean by?
; RETURNS: a list of the competitors outranked by the given competitor
; if by? is true
; otherwise a list of the competitors that outrank the given competitor
; Strategy: use HOF map on olst followed by apply
; EXAMPLES: (defeated-and-tied "A" (list (defeated "A" "B") (tie "B" "C"))
;                                                               BY)  => (list)
; (defeated-and-tied "A" (list (defeated "A" "B") (tie "B" "C")) OF) => '("B")
(define (defeated-and-tied c olst by?)
  ; Outcome -> CompetitorList
  ; RETURNS: a list of the competitors outranked by c if by? is true
  ; otherwise a list of the competitors that outrank c in olst
  (apply append (map (lambda (out) 
                       (cond
                         [(and by? (defeat? out) (equal? c (defeat-loser out))) 
                          (list (defeat-winner out))]
                         [(and (not by?) (defeat? out)
                               (equal? c (defeat-winner out)))
                          (list (defeat-loser out))]
                         [(and (tie? out) (member-in-tie? c out))
                          (tie-t-competitors out)]
                         [else empty]))
                     olst)))
; Test
(begin-for-test
  (check-equal? (defeated-and-tied "A" (list (defeated "A" "B") (tie "B" "C"))
                  BY) empty "it should return empty")
  (check-equal? (defeated-and-tied "A" (list (defeated "A" "B") (tie "B" "C")) 
                  OF) '("B") "it should return (\"B\")"))

