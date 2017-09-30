(require rackunit)
(require 2htdp/universe)
(require 2htdp/image)
(require "extras.rkt")
(provide
 )

(check-location "03" "q1.rkt")

; Constants
; Colors
(define BLACK "black")
(define WHITE "white")
(define YELLOW "yellow")
(define GREEN "green")


; Dimensions and attributes of the court
(define COURT-WIDTH 425)
(define COURT-HEIGHT 649)
(define COURT-OUTLINE-COLOR "black")
(define COURT-INSIDE "white")

(define COURT-IMAGE (rectangle COURT-WIDTH COURT-HEIGHT
 "outline" COURT-OUTLINE-COLOR))

; Iniatial Postion of ball and racket
(define X-POS 330)
(define Y-POS 384)


; Dimensions and attributes of the ball
(define BALL-RADIUS 3)
(define BALL-COLOR "black")
(define BALL-IMAGE (circle BALL-RADIUS "solid" BALL-COLOR))

; Dimensions and attributes of the racket
(define RACKET-WIDTH 47)
(define RACKET-HEIGHT 7)
(define RACKET-COLOR "green")

(define RACKET-IMAGE (rectangle RACKET-WIDTH RACKET-HEIGHT
 "solid" RACKET-COLOR))



; Data definitions
; A WorldState is represented as one of the following strings
; -"ready-to-serve"
; -"rally"
; -"pause"
; INTERP:
; the tate of the world, ready-to-serve is the initiate state 
; of world and rally means world is simulated,
; pause is between ready-toserve and rally.
(define READY-TO-SERVE "ready-to-serve")
(define RALLY "rally")
(define PAUSE "pause")

; A World is represented as a (make-world
; ball racket state speed)
; INTERP
; ball : Ball  the ball
; racket : Racket 
; state : WorldState
; speed : Real 
; Implemention
(define-struct world (ball racket state speed))

; Constructor template
; (make-world Ball Racket WolrdState Real)

; Observer Template
; world-fn : World -> ??
(define (world-fn w)
     (...
     (world-ball w)
     (world-racket w)
     (world-state w)
     (world-speed w)))

; A Ball is represented as (make-ball x-pos y-pos vx vy)
; Interpretation:
; x, y   : Integer  the position of the center of the ball
;          in the scene 
; vx, vy : Real  two components vx and vy of the ball 
;          telling how many pixels it moves on each tick 
;          in the x and y directions, respectively.

(define-struct ball (x y vx vy))

; (make-ball Integer Integer Real Real)

; ball-fn : Ball -> ??
(define (ball-fn b)
     (...
     (ball-x b)
     (ball-y b)
     (ball-vx b)
     (ball-vy b)))

; A Racket is represented as (make-racket x-pos y-pos vx vy)
; Interpretation:
; x, y   : Integer  the position of the center of the racket
;          in the scene 
; vx, vy : Real  two components vx and vy of the racket 
;          telling how many pixels it moves on each tick 
;          in the x and y directions, respectively.

(define-struct racket (x y vx vy))

; (make-racket Integer Integer Real Real)

; racket-fn : Racket -> ??
(define (racket-fn r)
     (...
     (racket-x r)
     (racket-y r)
     (racket-vx r)
     (racket-vy r)))

;;; simulation : PosReal -> World
          ;;; GIVEN: the speed of the simulation, in seconds per tick
          ;;;     (so larger numbers run slower)
          ;;; EFFECT: runs the simulation, starting with the initial world
          ;;; RETURNS: the final state of the world
          ;;; EXAMPLES:
          ;;;     (simulation 1) runs in super slow motion
          ;;;     (simulation 1/24) runs at a more realistic speed
(define (simulation speed)
     (big-bang 
          (initial-world speed)
          (on-tick world-after-tick speed)
          (on-draw )
          (on-key world-after-key-event)))          
          ;;; initial-world : PosReal -> World
          ;;; GIVEN: the speed of the simulation, in seconds per tick
          ;;;     (so larger numbers run slower)
          ;;; RETURNS: the ready-to-serve state of the world
          ;;; EXAMPLE: (initial-world 1)
 
 (define (initial-world speed)
     (make-world 
          (make-ball X-POS Y-POS 0 0)
          (make-racket X-POS Y-POS 0 0)
          READY-TO-SERVE
          speed
          ))

(define (world-rally speed)
     (make-world 
          (make-ball X-POS Y-POS 3 -9)
          (make-racket X-POS Y-POS 0 0)
          RALLY
          speed
          ))




          ;;; world-ready-to-serve? : World -> Boolean
          ;;; GIVEN: a world
          ;;; RETURNS: true iff the world is in its ready-to-serve state
(define (world-ready-to-serve? w)
     (equal? READY-TO-SERVE (world-state) w))          
          ;;; world-after-tick : World -> World
          ;;; GIVEN: any world that's possible for the simulation
          ;;; RETURNS: the world that should follow the given world
          ;;;     after a tick
(define (world-after-tick w)
     (make-world) ) 
(define (ball-after-tick b)
     )      
          ;;; world-after-key-event : World KeyEvent -> World
          ;;; GIVEN: a world and a key event
          ;;; RETURNS: the world that should follow the given world
          ;;;     after the given key event
          
          ;;; world-ball : World -> Ball
          ;;; GIVEN: a world
          ;;; RETURNS: the ball that's present in the world
          
          ;;; world-racket : World -> Racket
          ;;; GIVEN: a world
          ;;; RETURNS: the racket that's present in the world
          
          ;;; ball-x : Ball -> Integer
          ;;; ball-y : Ball -> Integer
          ;;; racket-x : Racket -> Integer
          ;;; racket-y : Racket -> Integer
          ;;; GIVEN: a racket or ball
          ;;; RETURNS: the x or y coordinate of that item's position,
          ;;;     in graphics coordinates
          
          ;;; ball-vx : Ball -> Integer
          ;;; ball-vy : Ball -> Integer
          ;;; racket-vx : Racket -> Integer
          ;;; racket-vy : Racket -> Integer
          ;;; GIVEN: a racket or ball
          ;;; RETURNS: the vx or vy component of that item's velocity,
          ;;;     in pixels per tick