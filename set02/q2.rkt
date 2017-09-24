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
  (if (equal? "red" (signal-color sg))
      (red-next sg)
      (non-red-next sg)
      ))

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
  

;; non-red-next: ChineseTrafficSignal -> ChineseTrafficSignal
;; RETURNS:  the state that the given non-red signal(green&blank) should have one second later
;; STRATEGY: Cases on the left-time of non-red signal if time == 4 or 2 color turns blank
;;           if time = 3 color turns green and time == 1 turns red
;;           and use template for ChineseTrafficSignal
;; EXAMPLES:
;; (non-red-next (make-signal "green" 4 2)) => (make-signal "blank" 4 1) 
;; (non-red-next (make-signal "blank" 4 1)) => (make-signal "red" 4 4) 
(define (non-red-next sg)
  (let ([left (signal-left-time sg)] [durtime (signal-durtime sg)])
    (cond
      [(or (= 4 left) (= 2 left)) (make-signal "blank" durtime (- left 1))]
      [(= 3 left) (make-signal "green" durtime (- left 1))]
      [(= 1 left) (make-signal "red" durtime durtime)]
      )))

;; TESTS
(begin-for-test
  (check-equal? (non-red-next (make-signal "green" 4 2)) (make-signal "blank" 4 1) )
  (check-equal? (non-red-next (make-signal "blank" 4 1)) (make-signal "red" 4 4))
  )

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