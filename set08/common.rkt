;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname common) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

(provide
 make-tie-t
 tie-t-competitors
 make-defeat
 defeat-winner
 defeat-loser
 tie?
 defeat?
 member-in-tie?
 remove-duplicates)

; A Competitor is represented as a String (any string will do).
(define A "A")
(define B "B")
(define C "C")

; A Tie represents a tie (draw) between two competitors  
; as a struct (make-tie-t competitors)
; -competitors CompetitorList WHERE it must just have two elements
(define-struct tie-t (competitors))
; CONSTRUCTOR TEMPLATE 
; (make-tie-t CompetitorList)
; OBSERVER TEMPLATE
; tie-t-fn: Tie -> ??
#;
(define (tie-t-fn tie)
  (... (tie-t-competitors tie)))

; CompetitorList is a list of competitors
; -empty
; -(cons Competitor CompetitorList)
; OBSERVER TEMPLATE
#;
(define (clst-fn competitors)
  (cond
    [(empty? competitors) ...]
    [else (...
           (first competitors) clst-fn(rest competitors))]))

; A Defeat represents as a struct (make-defeat winner loser)
; the outcome of a contest in which one competitor wins and the other loses.
; -winner Competitor the winner of the contest
; -loser Competitor the one who loses the contest
(define-struct defeat(winner loser))
; CONSTRUCTOR TEMPLATE
; (make-defeat Competitor Competitor)
; OBSERVER TEMPLATE
#;
(define (defeat-fn defeat)
  (...(defeat-winner defeat)
      (defeat-loser defeat)))

;;; An Outcome is one of
;;;     -- a Tie
;;;     -- a Defeat
;;;
;;; OBSERVER TEMPLATE:
;;; outcome-fn : Outcome -> ??
#;
(define (outcome-fn o)
  (cond ((tie? o) ...)
        ((defeat? o) ...))
  )
; OutcomeList is a list as one of 
; - empty
; - (cons outcome OutcomeList)
; Where outcome is a Outcome
; OBSERVER TEMPLATE
;  OutcomeList -> ??
#;
(define (olst-fn lst)
  (cond
    [(empty? es) ...]
    [else (outcome-fn (first es))
          (olst-fn (rest es))]))

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

; tie?: Outcome -> Boolean
; GIVEN: a Outcome ot
; RETURNS: true iff ot is a tie
; Strategy: use template of tie-t
; Examples: (tie? (tie A B)) => true
(define (tie? ot)
  (tie-t? ot))
; Test
(begin-for-test
  (check-equal? (tie? (tie A B)) true "it should return true"))

; member-in-tie?: Competitor Tie -> Boolean
; GIVEN: a Competitor c and a Tie tie 
; RETURNS: true if c in the given tie
; Strategy: use observer template of Tie
; EXAMPLES: (member-in-tie? A (tie A B)) => true
(define (member-in-tie? c tie)
  (member? c (tie-t-competitors tie)))
; Test
(begin-for-test
  (check-equal? (member-in-tie? A (tie A B)) true "it should return true"))

; remove-duplicates: XList -> XList
; Given: a list of X which is any type
; Returns: a list like the given one except without repititions
; Examples: (remove-duplicates (list "x" "v" "x" "v"))
; => (list "x" "v") or (list "v" "x")
; Strategy: use HOF filter on XList followed by folder
(define (remove-duplicates st)
  ; String XList -> XList
  ; Returns: cons the given X to a list like the given XList except without X
  (foldr (lambda (x y) (cons x (filter 
                                ; X -> Boolean
                                ; Returns: true if the given X is equal to x
                                (lambda (z) (not (equal? x z))) y))) empty st))
; Test
(begin-for-test
  (check-equal? (remove-duplicates (list "x" "v" "x" "v")) (list "x" "v")
                "it should return (list \"x\" \"v\")"))
