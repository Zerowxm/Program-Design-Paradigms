;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

(check-location "08" "q1.rkt")

; A Competitor is represented as a String (any string will do).
(define A "A")
(define B "B")
(define C "C")

; A Tie represents a tie (draw) between two competitors  
; as a struct (make tie-t competitors)
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
        ((defeat? o) ...)))

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
    [(defeat? out) (and (equal? c1 (defeat-winner out)) (equal? c2 (defeat-loser out)))]
    [(tie? out) (member-in-tie? (tie-t-competitors out))])) olst)))
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
    
(define (member-in-tie? c tie)
  (member? c (tie-t-competitors tie)))

; remove-duplicates: XList -> XList
; Given: a list of X which is any type
; Returns: a list like the given one except without repititions
; Examples: (remove-duplicates (list "x" "v" "x" "v")) => (list "x" "v") or (list "v" "x")
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
  (outranks-or-outranked c olst false))
#;
(define (outranks c olst)
  (let ([outranked (defeated-and-tied-of c olst)])
    (sort
    (remove-duplicates
    (append outranked
    (apply append (map 
      ; Competitor -> CompetitorList
      ; RETURNS: a list of the competitors outranked by the given competitor
      (lambda (c) (defeated-and-tied-of c olst)) outranked)))) string<?)))
; Test
(begin-for-test
  (check-equal? (outranks "A" (list (defeated "A" "B") (tie "B" "C")))
 (list "B" "C") "it returns wrong")
  (check-equal? (outranks "B" (list (defeated "A" "B") (defeated "B" "A")))
    (list "A" "B") "it returns wrong")
  (check-equal? (outranks "C" (list (defeated "A" "B") (tie "B" "C")))
    (list "B" "C") "it returns wrong"))

; defeated-and-tied-of: Competitor OutcomeList -> CompetitorList
; GIVEN: a Competitor c and OutcomeList olst
; RETURNS: a list of the competitors outranked by the given competitor c
; Strategy: use HOF map on olst followed by apply
; EXAMPLES: (defeated-and-tied-of "A" (list (defeated "A" "B") (tie "B" "C")))
;  => (list "B" "C")
(define (defeated-and-tied-of c olst)
  (apply append (map (lambda (out) (cond
    [(and (defeat? out) (equal? c (defeat-winner out))) (list (defeat-loser out))]
    [(and (tie? out) (member-in-tie? c out)) (tie-t-competitors out)]
    [else empty])) olst)))
; Test
(begin-for-test
  (check-equal? (outranks "A" (list (defeated "A" "B") (tie "B" "C")))
 (list "B" "C") "it returns wrong"))

; defeated-and-tied: Competitor OutcomeList Number -> CompetitorList
; GIVEN: a Competitor c and a OutcomeList olst and a Boolean by?
; RETURNS: a list of the competitors outranked by the given competitor if b is true
; otherwise a list of the competitors that outrank the given competitor
; Strategy: use HOF map on olst followed by apply
#;
(define (defeated-and-tied c olst by?)
  (local ([(define (winner-or-loser by?)
    (if (by?)
      defeat-winner defeat-loser))])
  (apply append (map (lambda (out) (cond
    [(and (defeat? out) (equal? c (func1 out))) (list (func2 out))]
    [(and (tie? out) (member-in-tie? c out)) (tie-t-competitors out)]
    [else empty])) olst))))


; defeated-and-tied-of: Competitor OutcomeList -> CompetitorList
; GIVEN: a Competitor c and OutcomeList olst
; RETURNS: a list of the competitors that outrank the given competitor c
; Strategy: use HOF map on olst followed by apply
; EXAMPLES:  (defeated-and-tied-by "A" (list (defeated "A" "B") (tie "B" "C")))
;;;  => (list)
(define (defeated-and-tied-by c olst)
  (apply append (map (lambda (out) (cond
    [(and (defeat? out) (equal? c (defeat-loser out))) (list (defeat-winner out))]
    [(and (tie? out) (member-in-tie? c out)) (tie-t-competitors out)]
    [else empty])) olst)))
(begin-for-test
  (check-equal? (defeated-and-tied-by "A" (list (defeated "A" "B") (tie "B" "C")))
    empty))

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
  (outranks-or-outranked c olst true))
#;
(define (outranked-by c olst)
   (let ([outranked (defeated-and-tied-by c olst)])
    (sort
    (remove-duplicates
    (append outranked
    (apply append (map 
      ; Competitor -> CompetitorList
      ; RETURNS: a list of the competitors outranked by the given competitor
      (lambda (c) (defeated-and-tied-by c olst)) outranked)))) string<?)))
; Test
(begin-for-test
  (check-equal? (outranked-by "A" (list (defeated "A" "B") (tie "B" "C")))
 (list) "it returns wrong")
  (check-equal? (outranked-by "B" (list (defeated "A" "B") (defeated "B" "A")))
    (list "A" "B") "it returns wrong")
  (check-equal? (outranked-by "C" (list (defeated "A" "B") (tie "B" "C")))
    (list "A" "B" "C") "it returns wrong"))

;;; outranks-or-outranked : Competitor OutcomeList Boolean-> CompetitorList
;;; GIVEN: the name of a competitor and a list of outcomes and a Boolean outranked?
;;; RETURNS: a list of the competitors that outrank the given
;;;     competitor, in alphabetical order if outranked is ture
;;; otherwise a list of the competitors outranked by the given competitor
;;; EXAMPLES:
;;;     (outranks-or-outranked "A" (list (defeated "A" "B") (tie "B" "C")) #t)
;;;  => (list)
; Strategy: use HOF map on OutcomtList followed by apply
(define (outranks-or-outranked c olst outranked?)
  (let* ([outrank (if (equal? true outranked?) 
    defeated-and-tied-by 
    defeated-and-tied-of)]
    [outranked (outrank c olst)])
    (sort
    (remove-duplicates
    (append outranked
    (apply append (map 
      ; Competitor -> CompetitorList
      ; RETURNS: a list of the competitors outranked by the given competitor
      (lambda (c) (outrank c olst)) outranked)))) string<?)))
; Test
(begin-for-test
  (check-equal? (outranks-or-outranked "A" (list (defeated "A" "B") (tie "B" "C")) #t)
 (list) "it returns wrong"))
