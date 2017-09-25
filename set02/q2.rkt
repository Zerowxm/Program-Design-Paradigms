;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

(provide
 initial-state
 next-state
 is-red?
 is-green?
 )

(check-location "02" "q2.rkt")

;; DATA DEFINITION
;; A Color is represented by one of the strings
;; -- "red"
;; -- "blank" 
;; -- "green"
;; INTERP: self-evident

;; A ChineseTrafficSignal is a struct (make-signal color durtime left-time) with following fileds
;; color:     Color           represents the current color of the traffic light
;; durtime:   PosInteger      represents the initial last time for the current color in seconds
;; left-time: PosInteger      represents the left time for the current color in seconds

;; IMPLEMENTATION
(define-struct signal(color durtime left-time))

;; CONSTRUCTOR TEMPLATE
;; (make-signal Color PosInteger PosInteger)

;; OBSERVER TEMPLATE
;; signal-fn: ChineseTrafficSignal -> ??
(define (signal-fn sg)
  (...
   (signal-color sg)
   (signal-durtime sg)
   (signal-left-time sg))
  )
  
;;; initial-state : PosInt -> ChineseTrafficSignal
;;; GIVEN:   an integer n greater than 3
;;; RETURNS: a representation of a Chinese traffic signal
;;;          at the beginning of its red state, which will last
;;;          for n seconds
;;; EXAMPLE:
;;;     (is-red? (initial-state 4))  =>  true
;;; STRATEGY: Use constructor template for ChineseTrafficSignal
(define (initial-state t)
  (make-signal "red" t t))

;;; next-state : ChineseTrafficSignal -> ChineseTrafficSignal
;;; GIVEN:   a representation of a traffic signal in some state
;;; RETURNS: the state that traffic signal should have one
;;;          second later
;;; STRATEGY: Combine simpler functions and cases if the signal is red or not
(define (next-state sg)
  (cond
    [(is-red? sg) (red-next sg)]
    [(is-green? sg) (green-next sg)]
    [else (blank-next sg)]))

;; red-next: ChineseTrafficSignal -> ChineseTrafficSignal
;; RETURNS:  the state that the given red signal should have one second later
;; STRATEGY: Cases if left time of signal is 1 then turn green otherwise still red
;;           and use template for ChineseTrafficSignal
;; EXAMPLES:
;; (red-next (initial-state 4)) => (make-signal "red" 4 3)
;; (red-next (make-signal "red" 4 1)) => (make-signal "green" 4 4)
(define (red-next sg)
  (let ([durtime (signal-durtime sg)] [left-time (signal-left-time sg)])
    (if(= 1 left-time)
       (make-signal "green" durtime durtime)
       (make-signal "red" durtime (- left-time 1)))))

;; TESTS
(begin-for-test
  (check-equal? (red-next (initial-state 4)) (make-signal "red" 4 3))
  (check-equal? (red-next (make-signal "red" 4 1)) (make-signal "green" 4 4))
  )
  

;; green-next: ChineseTrafficSignal -> ChineseTrafficSignal
;; RETURNS:  the state that the given green signal should have one second later
;; STRATEGY: Cases on the left-time of green signal
;;           and use template for ChineseTrafficSignal
;; EXAMPLES:
;; (green-next (make-signal "green" 4 2)) => (make-signal "blank" 4 1) 
;; (green-next (make-signal "green" 5 5)) => (make-signal "green" 5 4) 
(define (green-next sg)
  (let ([left-time (signal-left-time sg)] [durtime (signal-durtime sg)])
    (if(> left-time 4)
       (make-signal "green" durtime (- left-time 1))
       (make-signal "blank" durtime (- left-time 1)))))
     
;; blank-next: ChineseTrafficSignal -> ChineseTrafficSignal
;; RETURNS:  the state that the given blank signal should have one second later
;; STRATEGY: Cases on the left-time of blank signal
;;           and use template for ChineseTrafficSignal
;; EXAMPLES:
;; (blank-next (make-signal "blank" 4 3)) => (make-signal "green" 4 2) 
;; (blank-next (make-signal "blank" 5 1)) => (make-signal "red" 5 5) 
(define (blank-next sg)
   (let ([left-time (signal-left-time sg)] [durtime (signal-durtime sg)])
     (if(= 3 left-time)
        (make-signal "green" durtime (- left-time 1))
        (make-signal "red" durtime durtime))))

;; TESTS
(begin-for-test
  (check-equal? (green-next (make-signal "green" 4 2)) (make-signal "blank" 4 1) )
  (check-equal? (green-next (make-signal "green" 5 5)) (make-signal "green" 5 4) )
  (check-equal? (blank-next (make-signal "blank" 4 3)) (make-signal "green" 4 2))
  (check-equal? (blank-next (make-signal "blank" 5 1)) (make-signal "red" 5 5)))

;;; is-red? : ChineseTrafficSignal -> Boolean
;;; GIVEN:   a representation of a traffic signal in some state
;;; RETURNS: true if and only if the signal is red
;;; EXAMPLES:
;;;     (is-red? (next-state (initial-state 4)))  =>  true
;;;     (is-red?
;;;      (next-state
;;;       (next-state
;;;        (next-state (initial-state 4)))))  =>  true
;;;     (is-red?
;;;      (next-state
;;;       (next-state
;;;        (next-state
;;;         (next-state (initial-state 4))))))  =>  false
;;;     (is-red?
;;;      (next-state
;;;       (next-state
;;;        (next-state
;;;         (next-state
;;;          (next-state (initial-state 4)))))))  =>  false
;;; STRATEGY: Use observer template for ChineseTrafficSignal
(define (is-red? sg)
  (equal? "red" (signal-color sg)))

;; TESTS
;; Including all posibilities about green red and blank
(begin-for-test
  (check-equal? (is-red? (next-state (initial-state 4))) true)
  (check-equal? (is-red?
                 (next-state
                  (next-state
                   (next-state (initial-state 4))))) true)
   (check-equal? (is-red?
                  (next-state
                   (next-state
                    (next-state
                     (next-state (initial-state 4)))))) false)
   (check-equal? (is-red?
                  (next-state
                   (next-state
                    (next-state
                     (next-state (initial-state 30)))))) true)
  (check-equal? (is-red?
                 (next-state
                  (next-state
                   (next-state
                    (next-state
                     (next-state (initial-state 4))))))) false)
  (check-equal? (is-red?
                 (next-state
                  (next-state
                   (next-state
                    (next-state
                     (next-state
                      (next-state (initial-state 4)))))))) false)
  (check-equal? (is-red?
                 (next-state
                  (next-state
                   (next-state
                    (next-state
                     (next-state
                      (next-state
                       (next-state (initial-state 4))))))))) false)
  (check-equal? (is-red?
                 (next-state
                  (next-state
                   (next-state
                    (next-state
                     (next-state
                      (next-state
                       (next-state
                        (next-state (initial-state 4)))))))))) true)
     )

;;; is-green? : ChineseTrafficSignal -> Boolean
;;; GIVEN:   a representation of a traffic signal in some state
;;; RETURNS: true if and only if the signal is green
;;; EXAMPLES:
;;;     (is-green?
;;;      (next-state
;;;       (next-state
;;;        (next-state
;;;         (next-state (initial-state 4))))))  =>  true
;;;     (is-green?
;;;      (next-state
;;;       (next-state
;;;        (next-state
;;;         (next-state
;;;          (next-state (initial-state 4)))))))  =>  false
;;; STRATEGY: Use observer template for ChineseTrafficSignal
(define (is-green? sg)
  (equal? "green" (signal-color sg)))

;; TESTS
;; Including all posibilities about green red and blank
(begin-for-test
  (check-equal? (is-green? (next-state (initial-state 4))) false)
  (check-equal? (is-green? (next-state (initial-state 30))) false)
  (check-equal? (is-green?
                 (next-state
                  (next-state
                   (next-state
                    (next-state (initial-state 4)))))) true)
  (check-equal? (is-green?
                 (next-state
                  (next-state
                   (next-state (initial-state 4))))) false)
  (check-equal? (is-green?
                 (next-state
                  (next-state
                   (next-state
                    (next-state
                     (next-state (initial-state 4))))))) false)
  (check-equal? (is-green?
                 (next-state
                  (next-state
                   (next-state
                    (next-state
                     (next-state
                      (next-state (initial-state 4)))))))) true)
  (check-equal? (is-green?
                 (next-state
                  (next-state
                   (next-state
                    (next-state
                     (next-state
                      (next-state
                       (next-state (initial-state 4))))))))) false)
  (check-equal? (is-green?
                 (next-state
                  (next-state
                   (next-state
                    (next-state
                     (next-state
                      (next-state
                       (next-state
                        (next-state (initial-state 4)))))))))) false)
  )