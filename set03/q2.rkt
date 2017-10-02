;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/universe)
(require 2htdp/image)
(require "extras.rkt")
(provide
 simulation 
 initial-world
 world-ready-to-serve?
 world-after-tick
 world-after-key-event
 world-ball
 world-racket
 ball-x
 ball-y
 racket-x
 racket-y
 ball-vx
 ball-vy
 racket-vx
 racket-vy 
 world-after-mouse-event
 racket-after-mouse-event
 racket-selected?)

(check-location "03" "q2.rkt")
; The simulation is a universe program 
; that displays the positions and motions of a squash ball and
; the player's racket moving within a rectangular court.

;!!!IMPORTANT: R is Returns,G is Given S is Strategy E is Examples.

; Constants
; Dimensions and attributes of the court

(define COURT-WIDTH 425)
(define COURT-HEIGHT 649)
(define COURT-COLOR "white")
(define COURT-COLOR-PAUSE "yellow")
(define PEN (make-pen "black" 5 "solid" "round" "round"))

(define COURT-IMAGE (scene+line
                     (scene+line
                      (scene+line
                       (scene+line
                        (rectangle COURT-WIDTH COURT-HEIGHT
                                   "solid" COURT-COLOR)
                        0 COURT-HEIGHT COURT-WIDTH COURT-HEIGHT 
                        PEN)
                       COURT-WIDTH 0 COURT-WIDTH COURT-HEIGHT 
                       PEN)
                      0 0 COURT-WIDTH 0 
                      PEN)
                     0 0 0 COURT-HEIGHT 
                     PEN))

(define COURT-IMAGE-PAUSE (scene+line
                           (scene+line
                            (scene+line
                             (scene+line
                              (rectangle COURT-WIDTH COURT-HEIGHT
                                         "solid" COURT-COLOR-PAUSE)
                              0 COURT-HEIGHT COURT-WIDTH COURT-HEIGHT 
                              PEN)
                             COURT-WIDTH 0 COURT-WIDTH COURT-HEIGHT 
                             PEN)
                            0 0 COURT-WIDTH 0 
                            PEN)
                           0 0 0 COURT-HEIGHT 
                           PEN))

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
; mouse blue circle
(define MOUSE-CIRCLE-RADIUS 4)
(define MOUSE-CIRCLE-COLOR "blue")
(define MOUSE-CIRCLE (circle MOUSE-CIRCLE-RADIUS "solid" MOUSE-CIRCLE-COLOR))

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
; ball racket state speed pause-time)
; INTERP
; ball : Ball  the squash ball
; racket : Racket the player's racket
; state : WorldState the current state of world
; speed : PosReal the speed of the simulation, in seconds per tick
; pause-time : PosReal  the time counter when the world is in pause state 
; Implemention
(define-struct world (ball racket state speed pause-time))

; Constructor template
; (make-world Ball Racket WolrdState PosReal PosReal)

;;; world-ball : World -> Ball
;;; GIVEN: a world
;;; RETURNS: the ball that's present in the world
          
;;; world-racket : World -> Racket
;;; GIVEN: a world
;;; RETURNS: the racket that's present in the world

;;; world-state : World -> WorldState
;;; GIVEN: a world
;;; RETURNS: the state that's present in the world
          
;;; world-speed : World -> PosReal
;;; GIVEN: a world
;;; RETURNS: the speed that's present in the world

;;; world-pause-time : World -> PosReal
;;; GIVEN: a world
;;; RETURNS: the pause-time that's present in the world

; Observer Template
; world-fn : World -> ??
(define (world-fn w)
  (...
   (world-ball w)
   (world-racket w)
   (world-state w)
   (world-speed w)
   (world-pause-time w)))

; A Ball is represented as (make-ball x-pos y-pos vx vy)
; Interpretation:
; x, y   : Integer  the position of the center of the ball
;          in the scene 
; vx, vy : Integer  two components vx and vy of the ball 
;          telling how many pixels it moves on each tick 
;          in the x and y directions, respectively.

(define-struct ball (x y vx vy))
; Constructor template
; (make-ball Integer Integer Integer Integer)

;;; ball-x : Ball -> Integer
;;; ball-y : Ball -> Integer
;;; GIVEN: a ball
;;; RETURNS: the x or y coordinate of that item's position,
;;;     in graphics coordinates
          
;;; ball-vx : Ball -> Integer
;;; ball-vy : Ball -> Integer
;;; GIVEN: a ball
;;; RETURNS: the vx or vy component of that item's velocity,
;;;     in pixels per tick     

; Observer template
; ball-fn : Ball -> ??
(define (ball-fn b)
  (...
   (ball-x b)
   (ball-y b)
   (ball-vx b)
   (ball-vy b)))

; A Racket is represented as (make-racket x-pos y-pos vx vy 
; selected? pos-mouse)
; Interpretation:
; x, y   : Integer  the position of the center of the racket
;          in the scene 
; vx, vy : Integer  two components vx and vy of the racket 
;          telling how many pixels it moves on each tick                                             
;          in the x and y directions, respectively.
; selected? : Boolean describes whether or not the racket is selected.
; pos-mouse : List 4-elements list indicating the mouse position
; and the difference between positions of racket and mouse
; first two elements are position of mouse and last two ones are difference 
; if mouse is not pressed default value is (0 0 0 0)
; Exmples: (23 21 0 0)  means mouse is on the point (23 21) and is the center
; of racket.

(define-struct racket (x y vx vy selected? pos-mouse))
; Constructor template
; (make-racket Integer Integer Integer Integer Boolean List)

;;; racket-x : Racket -> Integer
;;; racket-y : Racket -> Integer
;;; GIVEN: a racket 
;;; RETURNS: the x or y coordinate of that item's position,
;;;     in graphics coordinates
;;; racket-vx : Racket -> Integer
;;; racket-vy : Racket -> Integer
;;; GIVEN: a racket
;;; RETURNS: the vx or vy component of that item's velocity,
;;;     in pixels per tick   
;;; racket-selected? : Racket-> Boolean
;;; GIVEN: a racket
;;; RETURNS: true iff the racket is selected
;;; racket-pos-mouse : Racket -> List
;;; Given: a racket
;;; Returns: position of mouse 
; Observer template
; racket-fn : Racket -> ??
(define (racket-fn r)
  (...
   (racket-pos-mouse r)
   (racket-selected? r)
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
   (on-draw world-to-scene)
   (on-key world-after-key-event)
   (on-mouse world-after-mouse-event)))          
;;; initial-world : PosReal -> World
;;; GIVEN: the speed of the simulation, in seconds per tick
;;;     (so larger numbers run slower)
;;; RETURNS: the ready-to-serve state of the world
;;; EXAMPLE: (initial-world 1)
 
(define (initial-world speed)
  (make-world 
   (make-ball X-POS Y-POS 0 0)
   (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
   READY-TO-SERVE
   speed
   0))
(define SPEED 1/3)
(define world-initial (initial-world SPEED))

; Tests
(begin-for-test
  (check-equal? (initial-world SPEED)
                world-initial "(initial-world SPEED) should be world-initial"))

;; world-to-scene : World -> Scene
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE: if world is pause, then everthing will be still and court becomes yellow
;; and if world is rally, then the ball and the racket will move by the instructions
;; STRATEGY: Cases on world state.
(define (world-to-scene w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (if(string=? PAUSE (world-state w))
       (place-images
        (list BALL-IMAGE
              RACKET-IMAGE)
        (list (make-posn (ball-x b) (ball-y b))
              (make-posn (racket-x r) (racket-y r)))
        COURT-IMAGE-PAUSE)
       (rally-world-to-scene w))))

(define (mouse-posn r)
  (let* ([mouse-pos (racket-pos-mouse r)] 
         [x (list-ref mouse-pos 0)] [y (list-ref mouse-pos 1)])
    (make-posn x y)))

; Test
; Test data
(define racket-selected
  (make-racket X-POS Y-POS 0 0 true (list X-POS Y-POS 0 0)))

(define racket-unselected
  (make-racket X-POS Y-POS 0 0 false (list 0 0 0 0)))

(define ball-at-20-20-1-1 (make-ball 20 20 1 1))

(define mouse-click-world
  (make-world ball-at-20-20-1-1 racket-selected
              RALLY
              SPEED
              0))

(define mouse-click-image (place-images
                           (list MOUSE-CIRCLE
                                 BALL-IMAGE
                                 RACKET-IMAGE)
                           (list (make-posn X-POS Y-POS)
                                 (make-posn 20 20)
                                 (make-posn X-POS Y-POS)) 
                           COURT-IMAGE))

(define (rally-world-to-scene w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (if (racket-selected? r)
        (place-images
         (list MOUSE-CIRCLE
               BALL-IMAGE
               RACKET-IMAGE)
         (list (mouse-posn r)
               (make-posn (ball-x b) (ball-y b))
               (make-posn (racket-x r) (racket-y r)))
         COURT-IMAGE)
        (place-images
         (list BALL-IMAGE
               RACKET-IMAGE)
         (list (make-posn (ball-x b) (ball-y b))
               (make-posn (racket-x r) (racket-y r)))
         COURT-IMAGE))))
 
(define image-serve (place-images
                     (list BALL-IMAGE
                           RACKET-IMAGE)
                     (list (make-posn X-POS Y-POS)
                           (make-posn X-POS Y-POS))
                     COURT-IMAGE))

(define image-pause (place-images
                     (list BALL-IMAGE
                           RACKET-IMAGE)
                     (list (make-posn X-POS Y-POS)
                           (make-posn X-POS Y-POS))
                     COURT-IMAGE-PAUSE))
(define pause-world (make-world 
                     (make-ball X-POS Y-POS 0 0)
                     (make-racket X-POS Y-POS 0 0  false '(0 0 0 0))
                     PAUSE
                     SPEED
                     0))
(begin-for-test
  (check-equal? (world-to-scene world-initial)
                image-serve "(world-to-scene world-initial) returns wrong image")
  (check-equal? (world-to-scene pause-world) image-pause 
                "(world-to-scene pause-world) returns wrong image")
  (check-equal? (rally-world-to-scene mouse-click-world) mouse-click-image 
                "(rally-world-to-scene mouse-click-world) returns wrong image"))
 
; world-to-rally : World -> World
; GIVEN: A world in ready-to-serve state
; RETURNS: The world in rally state
; changing the ball's velocity components to (3,-9).
; Strategy: use constructor template on World

; Examples:
; (world-to-rally (initial-world 1)) -> (make-world 
; (make-ball X-POS Y-POS 3 -9)
; (world-racket w)
; RALLY
; 1
; 0)
(define (world-to-rally w)
  (make-world 
   (make-ball X-POS Y-POS 3 -9)
   (world-racket w)
   RALLY
   (world-speed w)
   0))
; Tests:
(define rally-world 
  (make-world 
   (make-ball X-POS Y-POS 3 -9)
   (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
   RALLY
   SPEED
   0))
(define rally-world-right-event 
  (make-world 
   (make-ball X-POS Y-POS 3 -9)
   (make-racket X-POS Y-POS 1 0 false '(0 0 0 0))
   RALLY
   SPEED
   0))
(begin-for-test
  (check-equal? (world-to-rally world-initial)  
                rally-world "the wolrd changes wrong state"))

;;; world-ready-to-serve? : World -> Boolean
;;; GIVEN: a world
;;; RETURNS: true iff the world is in its ready-to-serve state
;;; Stategy: cases on world state
;;; Examples: (world-ready-to-serve? world-initial) => true
(define (world-ready-to-serve? w)
  (equal? READY-TO-SERVE (world-state w)))
(begin-for-test
  (check-equal? (world-ready-to-serve? world-initial) true
                "return wrong infor the world should be ready"))

;;; world-after-tick : World -> World
;;; GIVEN: any world that's possible for the simulation
;;; RETURNS: the world that should follow the given world
;;;     after a tick
;;; Strategy: cases on world state if world is no longer in rally, treat it as
;;; press space
;;; Examples: (world-after-tick world-to-end) => world-after-end
;;; (world-after-tick world-initial) => world-initial
(define (world-after-tick w)
  (if (rally-end? w)
      (press-space w)
      (diff-world-state-after-tick w)))
; Tests
; Test data
(define racket-at-20-20-1-1 (make-racket 20 20 1 1 false '(0 0 0 0)))
(define ball-collide-back-wall (make-ball 2 650 1 1))

(define ball-at-20-20-0-0 (make-ball 20 20 0 0))

(define ball-after-end (make-ball 2 650 0 0))

(define racket-at-10-10-1-1 (make-racket 10 10 1 1 false '(0 0 0 0)))

(define racket-at-10-10-0-0 (make-racket 10 10 0 0 false '(0 0 0 0)))
(define world-to-end (make-world ball-collide-back-wall racket-at-10-10-1-1
                                 RALLY SPEED 0))

(define world-after-end (make-world ball-after-end racket-at-10-10-0-0
                                    PAUSE SPEED 0))
(begin-for-test 
  (check-equal? (world-after-tick world-to-end)
                world-after-end "the world should be pause")
  (check-equal? (world-after-tick world-initial)
                world-initial "the world should not be changed"))
;;; diff-world-state-after-tick : World -> World
;;; GIVEN: any world that's possible for the simulation
;;; RETURNS: the world that should follow the given world
;;;     after a tick 
;;; Strategy: cases on the world state
;;; Examples: (diff-world-state-after-tick pause-world) => pause-world-1-tick
;;; (diff-world-state-after-tick rally-world) => rally-world-1-tick
(define (diff-world-state-after-tick w)
  (let ([state (world-state w)])
    (cond
      [(equal? PAUSE state) (pause-world-after-tick w)]
      [(equal? RALLY state) (rally-world-after-tick w)]
      [else w])))
; Tests
(define pause-world-1-tick (make-world 
                            (make-ball X-POS Y-POS 0 0)
                            (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
                            PAUSE
                            SPEED
                            SPEED))
(define pause-world-to-serve (make-world 
                              (make-ball X-POS Y-POS 0 0)
                              (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
                              PAUSE
                              SPEED
                              3))
(define rally-world-1-tick (make-world 
                            (make-ball (+ 3 X-POS) (- Y-POS 9) 3 -9)
                            (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
                            RALLY
                            SPEED
                            0))
(begin-for-test 
  (check-equal? (diff-world-state-after-tick pause-world)
                pause-world-1-tick "should pause for 1 tick")
  (check-equal? (diff-world-state-after-tick rally-world)
                rally-world-1-tick "the ball should is in wrong position"))

; rally-end? : World -> Boolean
; Given: any world that's possible for the simulation
; Returns: true if the ball collides the back wall or the racket
; collides the top wall
; Strategy: cases on whether the world is no longer in rally
; Examples:  (rally-end? world-to-end) => true
(define (rally-end? w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (if (equal? PAUSE (world-state w))
        false
        (or (racket-collide-top-wall? r)
            (ball-collide-back-wall? b)))))
; Tests
(begin-for-test 
  (check-equal? (rally-end? world-to-end) true "the world should end"))

; ball-collide-back-wall?: Ball -> Boolean
; Given: a ball of a world
; Returns: true if the ball collides the back wall
; Strategy: cases
; E:(ball-collide-back-wall? ball-collide-back-wall) => true
(define (ball-collide-back-wall? b)
  (let ([y (+ (ball-y b) (ball-vy b))])
    (if(> y 649)
       true
       false)))
;Tests
(begin-for-test
  (check-equal? (ball-collide-back-wall? ball-collide-back-wall)
                true "should return true")
  (check-equal? (ball-collide-back-wall? ball-at-20-20-1-1)
                false "should return false"))
; rally-world-after-tick: World -> World
; Given: a world in rally state
; Returns: the world that should follow the given world
;     after a tick 
; Stategy : use constructor template on World 
; and combine simpler functions 
; E:(rally-world-after-tick rally-world) =>rally-world-1-tick
(define (rally-world-after-tick w)
  (make-world
   (ball-after-tick w)
   (racket-after-tick w)
   (world-state w) 
   (world-speed w)
   (world-pause-time w)))
; Tests
(begin-for-test
  (check-equal? (rally-world-after-tick rally-world)
                rally-world-1-tick "the world is wrong"))
; pause-world-after-tick: World -> World
; Given: A world in pause state
; Returns: the world that should follow the given world
; after a tick
; Stategy: cases on the puase-time if time < 3 the world is still pausing 
; Examples:(pause-world-after-tick pause-world) => pause-world-1-tick 
(define (pause-world-after-tick w)
  (let* ([b (world-ball w)] [r (world-racket w)] [speed (world-speed w)])
    (if(< (world-pause-time w) 3)
       (make-world b r (world-state w)
                   speed
                   (+ (world-pause-time w) speed))
       (initial-world speed))))
; Test;
(begin-for-test
  (check-equal? (pause-world-after-tick pause-world)
                pause-world-1-tick 
                "the pause world after 1 tick is wrong should be 
          pause-world-1-tick")
  (check-equal? (pause-world-after-tick pause-world-to-serve)
                world-initial 
                "the pause world should be reset"))
;ball-after-tick: World -> Ball
; Given: A world in rally state
; Returns: the ball of the world that should follow the given world
; after a tick
; Strtegy: cases on ball collision
(define (ball-after-tick w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (if (ball-collide-racket? b r)
        (ball-collide-racket b (racket-vy r))
        (ball-next-motion b))))
; Tests
(define racket-at-20-20-0-5 (make-racket 20 20 0 -5 false '(0 0 0 0)))
(define ball-at-19-19-1-5 (make-ball 19 19 1 5))
(define world-ball-collide-racket (make-world
                                   ball-at-19-19-1-5 racket-at-20-20-0-5 RALLY
                                   SPEED 0))
(begin-for-test
  (check-equal? (ball-after-tick rally-world) 
                (make-ball (+ 3 X-POS) (- Y-POS 9) 3 -9)
                "the ball is wrong")
  (check-equal? (ball-after-tick world-ball-collide-racket)
                (make-ball 19 19 1 -10) "the ball should collide the racket"))

; ball-next-motion: Ball -> Ball
; Given: A ball 
; Returns: the ball after
; Strtegy: cases on ball collision
; Examples
; (ball-next-motion collide-both-ball) => (make-ball 8 8 10 10)
(define (ball-next-motion b)
  (let ([type (ball-collide-wall? b)])
    (cond
      [(= 0 type) (ball-no-collide b)]
      [(= 1 type) (ball-collide-side-wall b)]
      [(= 2 type) (ball-collide-top-wall b)]
      [else (ball-collide-side-wall (ball-collide-top-wall b))])))
; Tests
(define collide-both-ball(make-ball 2 2 -10 -10))
(define collide-side-ball1 (make-ball 2 10 -10 2))
(define collide-side-ball2 (make-ball 424 10 10 2))
(define collide-top-ball (make-ball 10 2 2 -10))
(begin-for-test
  (check-equal? (ball-next-motion collide-both-ball) 
                (make-ball 8 8 10 10)
                "the ball should at (8,8) with v (10,10)")
  (check-equal? (ball-next-motion collide-side-ball1) 
                (make-ball 8 10 10 2)
                "the ball should at (8,10) with v (10,2)")
  (check-equal? (ball-next-motion collide-side-ball2) 
                (make-ball 416 10 -10 2)
                "the ball should at (8,10) with v (-10,2)")
  (check-equal? (ball-next-motion collide-top-ball) 
                (make-ball 10 8 2 10))
  "the ball should at (10,8) with v (2,10)")
; ball-no-collide Ball -> Ball
; Given: a ball which does not collide any thing
; Returns: the ball in next movement by changing the pos of the ball.
; Strategy: use template on Ball
(define (ball-no-collide b)
  (make-ball (+ (ball-x b) (ball-vx b))
             (+ (ball-y b) (ball-vy b)) 
             (ball-vx b) (ball-vy b)))

; ball-collide-wall? Ball -> Boolean
; Given: a ball
; Returns: 0 if ball does not collide the wall
; 1 if ball collides side wall and 2 if collides top wall
; 3 if ball collides both walls.
; Stratagy : cases on the collision
(define (ball-collide-wall? b)
  (let ([y (+ (ball-y b) (ball-vy b))]
        [x (+ (ball-x b) (ball-vx b))])
    (+ (ball-collide-top-wall? y) (ball-collide-side-wall? x))))

; ball-collide-side-wall? Ball -> Boolean
; Given: a ball
; Returns: 1 if ball collide the side wall 0 if not
; Stratagy : cases on the collision
(define (ball-collide-side-wall? x)
  (if (or (< x 0) (> x 425))
      1
      0))

; ball-collide-top-wall? Ball -> Boolean
; Given: a ball
; Returns: 2 if ball collide the top wall 0 if not
; Stratagy : cases on the collision
(define (ball-collide-top-wall? y)
  (if(< y 0)
     2
     0))
(begin-for-test
  (check-equal? (ball-collide-top-wall? 3) 0 
                "it should return 0"))
; ball-collide-side-wall: Ball -> Ball
; Given: a ball colliding the side wall
; Returns: a ball afrer colliding the side wall
; Strategy: cases on right side or left side wall
(define (ball-collide-side-wall b)
  (let* ([vx (ball-vx b)]
         [x (+ (ball-x b) vx)])
    (if (< x 0)
        (make-ball (- x) (ball-y b) (- vx) (ball-vy b))
        (make-ball (- 850 x) (ball-y b) (- vx) (ball-vy b)))))

; ball-collide-top-wall: Ball -> Ball
; Given: a ball colliding the top wall
; Returns: a ball afrer colliding the top wall
; Strategy: use template on Ball
(define (ball-collide-top-wall b)
  (let* ([vy (ball-vy b)]
         [y (+ (ball-y b) vy)])
    (make-ball (ball-x b) (- y) (ball-vx b) (- vy))))

; ball-collide-racket: Ball Integer -> Ball
; Given: a ball colliding the racket
; Returns: a ball afrer colliding the racket
; Strategy: use template on Ball
(define (ball-collide-racket b vy)
  (make-ball (ball-x b) (ball-y b) 
             (ball-vx b) (- vy (ball-vy b))))

; racket-collide-ball: Racket Integer -> Racket
; Given: a racket colliding the ball
; Returns: a racket afrer colliding the ball
; Strategy: cases on vy of the racket and use template on Racket
(define (racket-collide-ball r)
  (if (< (racket-vy r) 0)
      (make-racket (racket-x r) (racket-y r) 
                   (racket-vx r) 0 (racket-selected? r) (racket-pos-mouse r))
      r))
; Test
(begin-for-test
  (check-equal? (racket-collide-ball racket-at-10-10-1-1)
                racket-at-10-10-1-1 "racket whould not change")
  (check-equal? (racket-collide-ball 
                 (make-racket 1 1 -1 -1 false '(0 0 0 0)))
                (make-racket 1 1 -1 0 false '(0 0 0 0))
                "racket should change vy to 0"))

; racket-collide-side-wall? Racket -> Boolean
; Given: a racket
; Returns: true if racket collide the side wall 
; Stratagy : cases on the collision
(define (racket-collide-side-wall? r)
  (let ([x (+ (racket-x r) (racket-vx r))])
    (or (> x 401.5) 
        (< x 23.5))))

; racket-collide-side-wall: Racket -> Racket
; Given: a racket colliding the side wall
; Returns: a racket afrer colliding the side wall
; Strategy: cases on colliding the right side or left side wall
(define (racket-collide-side-wall r)
  (if (< (racket-x r) 212.5)
      (make-racket 23.5 (racket-y r) 0 (racket-vy r)
                   (racket-selected? r) (racket-pos-mouse r))
      (make-racket 401.5 (racket-y r) 
                   0 (racket-vy r) (racket-selected? r)
                   (racket-pos-mouse r))))
; Tests
(begin-for-test 
  (check-equal? (racket-collide-side-wall racket-at-10-10-1-1)
                (make-racket 23.5 10 0 1 false '(0 0 0 0)) 
                "it should be (make-racket 23.5 10 0 1 false '(0 0 0 0))")
  (check-equal? (racket-collide-side-wall (make-racket 233.5 10 1 1  false '(0 0 0 0)))
                (make-racket 401.5 10 0 1 false '(0 0 0 0)) 
                "it should be (make-racket 401.5 10 0 1 false '(0 0 0 0))"))
; racket-collide-top-wall: Racket -> Racket
; Given: a racket colliding the top wall
; Returns: a racket afrer colliding the top wall
; Strategy: cases on racket collision
(define (racket-collide-top-wall? r)
  (let ([y (+ (racket-y r) (racket-vy r))])
    (< y 0)))
(begin-for-test
  (check-equal? (racket-collide-top-wall? racket-at-20-20-0-5) false
                "it should return false"))
;racket-after-tick: World -> racket
; Given: A world in rally state
; Returns: the racket of the world that should follow the given world
; after a tick
; Strtegy: cases on racket collision
; Examples:
;(racket-after-tick world-ball-collide-racket)
; => (make-racket 23.5 20 0 0 false '(0 0 0 0))
(define (racket-after-tick w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (cond
      [(racket-selected? r) r]
      [(racket-collide-ball-wall? b r) (racket-collide-ball-wall b r)]
      [(ball-collide-racket? b r) (racket-collide-ball r)]
      [(racket-collide-side-wall? r) (collide-side-wall-racket-next r)]
      [else (racket-next r)])))
;Test
(define world-ball-wall
  (make-world
   (make-ball 240 19 1 5) (make-racket 240 20 0 -2 false '(0 0 0 0)) RALLY
   SPEED 0))
(define world-racket-wall
  (make-world
   (make-ball 18 19 1 5) (make-racket 440 20 0 -2 false '(0 0 0 0)) RALLY
   SPEED 0))
(begin-for-test
  (check-equal? (racket-after-tick world-ball-collide-racket)
                (make-racket 23.5 20 0 0 false '(0 0 0 0))
                "it should return (racket 23.5 20 0 0 false '(0 0 0 0))")
  (check-equal? (racket-after-tick world-ball-wall)
                (make-racket 240 20 0 0 false '(0 0 0 0))
                "it should return (racket 240 20 0 0 false '(0 0 0 0))")
  (check-equal? (racket-after-tick world-racket-wall)
                (make-racket 401.5 18 0 -2 false '(0 0 0 0))
                "it should return (racket 401.5 18 0 -2 false '(0 0 0 0))"))

(define (collide-side-wall-racket-next r)
  (racket-next (racket-collide-side-wall r)))
(define (racket-next r)
  (make-racket (+ (racket-x r) (racket-vx r))
               (+ (racket-y r) (racket-vy r))
               (racket-vx r) (racket-vy r)
               (racket-selected? r) (racket-pos-mouse r)))

(define (racket-collide-ball-wall? b r)
  (and (ball-collide-racket? b r) (racket-collide-side-wall? r)))

(define (racket-collide-ball-wall b r)
  (racket-collide-side-wall (racket-collide-ball r)))
; press-space: World -> World
; Given: A world is not paused
; Returns: a world which is paused and the ball and racket do not move
; Strategy: use template on World , Ball and Racket.
(define (press-space w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (make-world (make-ball (ball-x b) (ball-y b) 0 0)
                (make-racket (racket-x r) (racket-y r)
                             0 0 false (racket-pos-mouse r))
                PAUSE
                (world-speed w)
                0)))

; ball-collide-racket? : Ball Racket -> Boolean
; Given: a ball and a racket
; Returns: true if the ball and the racket are collided.
; Strategy: Cases on collision
; Examles: (ball-collide-racket? ball-23 racket-23) => true
(define (ball-collide-racket? b r)
  (and (collide-y? b r) (collide-x? b r)))  
(define racket-23 (make-racket 23.5 300 0 0 false (list 0 0 0 0)))
(define ball-23 (make-ball 23 299 3 9))
(begin-for-test
  (check-equal? (ball-collide-racket? ball-23 racket-23) true 
                "it should be true"))
; helper functions on collision
; collide-y? : Ball Racket -> Boolean
; Given: a ball and a racket
; Returns: true l
; Strategy: formula the pos-y of racket is between 
; the start y the end y during a tick of the bal
(define (collide-y? b r)
  (or (< (ball-y b) (racket-y r) (+ (ball-y b) (ball-vy b)))
      (> (ball-y b) (racket-y r) (+ (ball-y b) (ball-vy b)))))
; collide-x? : Ball Racket -> Boolean
; Given: a ball and a racket
; Returns: true if the collide x is on the center line of racket 
; Strategy: cases 
(define (collide-x? b r)
  (<= (abs (- (racket-x r) (collide-x b r))) 23.5))
(begin-for-test
  (check-equal? (collide-x? ball-at-20-20-1-1 racket-at-10-10-1-1) true
                "it should return true"))
; collide-x : Ball Racket -> Boolean
; Given: a ball and a racket
; Returns: x of the line of ball's start position and end position
; when y is equal to the y of the racket
; Strategy: use formula (x2-x1)(y-y1)=(y2-y1)(x-x1)
; Examples: (collide-x ball-at-19-19-1-5 racket-at-20-20-0-5) -> 91/5
(define (collide-x b r)
  (let ([x1 (ball-x b)] [y1 (ball-y b)])
    (+ (* (/ (ball-vx b) (ball-vy b)) (- (+ (racket-y r) (racket-vy r)) y1)) x1)))
(begin-for-test
  (check-equal? (collide-x ball-at-19-19-1-5 racket-at-20-20-0-5) 91/5))

;;; world-after-key-event : World KeyEvent -> World
;;; GIVEN: a world and a key event
;;; RETURNS: the world that should follow the given world
;;;     after the given key event
;;; Strategy: cases on the world state
;;; Examples
;;; (world-after-key-event world-initial non-pause-key-event) -> world-initial
;;; (world-after-key-event world-initial pause-key-event) -> rally-world
;;; (world-after-key-event rally-world pause-key-event) -> pause-world
(define (world-after-key-event w ev)
  (let ([state (world-state w)])
    (cond
      [(equal? RALLY state) (rally-world-after-key-event w ev)]
      [(and (equal? READY-TO-SERVE state) (is-pause-key-event? ev))
       (world-to-rally w)]
      [else w])))
; Test
(begin-for-test 
  (check-equal? (world-after-key-event world-initial non-pause-key-event)
                world-initial "it should result that nothing will change")
  (check-equal? (world-after-key-event world-initial pause-key-event)
                rally-world "it should result rally-world")
  (check-equal? (world-after-key-event rally-world pause-key-event)
                pause-world "it should result that world is paused")
  (check-equal? (world-after-key-event rally-world non-pause-key-event)
                rally-world "it should result that world does nothing"))

; rally-world-after-key-event： World KeyEvent -> World
;;; GIVEN: a world and a key event
;;; RETURNS: the world that should follow the given world
;;;     after the given key event
;;; Strategy: cases on the world state
(define (rally-world-after-key-event w ev)
  (if (is-pause-key-event? ev)
      (press-space w)
      (arrow-key-event w ev)))
; arrow-key-event: World KeyEvent -> World
;;; GIVEN: a world and a key event
;;; RETURNS: the world that should follow the given world
;;;     after the given key event
;;; Strategy: cases on the arrow key and use template on World
;;; Examles
;;; (arrow-key-event rally-world "a") ->rally-world
;;; (arrow-key-event rally-world "right") -> rally-world-right-event
(define (arrow-key-event w ev)
  (let* ([v (arrow-key-event? ev)]
         [vx (list-ref v 0)] [vy (list-ref v 1)] [r (world-racket w)])
    (if(= vx vy 0)
       w
       (make-world (world-ball w)
                   (make-racket (racket-x r) (racket-y r)
                                (+ (racket-vx r) vx) (+ (racket-vy r) vy) 
                                (racket-selected? r) (racket-pos-mouse r))
                   (world-state w)
                   (world-speed w)
                   (world-pause-time w)))))  
; Test
(begin-for-test 
  (check-equal? (arrow-key-event rally-world "a")
                rally-world "key event should not act")
  (check-equal? (arrow-key-event rally-world "right")
                rally-world-right-event "it should add 1 to vx of racket"))

;;; arrow-key-event? KeyEvent -> List
;;; GIVEN: a key event
;;; RETURNS: the list containing 
;;; vx and vy that should be added to the racket
;;; after the given key event
;;; Strategy: cases on the arrow key
;;; Exmples (arrow-key-event? "up") -> (0 -1)
;;; (arrow-key-event? "left") -> '(-1 0)
(define (arrow-key-event? ev)
  (cond
    [(key=? ev "up") '(0 -1)]
    [(key=? ev "down") '(0 1)]
    [(key=? ev "left") '(-1 0)]
    [(key=? ev "right") '(1 0)]
    [else '(0 0)]))   
(begin-for-test
  (check-equal? (arrow-key-event? "up") '(0 -1)) 
  (check-equal? (arrow-key-event? "down") '(0 1)) 
  (check-equal? (arrow-key-event? "left") '(-1 0))
  (check-equal? (arrow-key-event? "right") '(1 0)) 
  (check-equal? (arrow-key-event? "a") '(0 0))) 
;; help function for key event
;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
(define (is-pause-key-event? ev)
  (key=? ev " "))   
;; examples KeyEvents for testing
(define pause-key-event " ")
(define non-pause-key-event "q") 
;; example MouseEvents for testing:
(define button-down-event "button-down")
(define drag-event "drag")
(define button-up-event "button-up")
(define other-event "enter") 

;;; world-after-mouse-event
;;;     : World Int Int MouseEvent -> World
;;; GIVEN: a world, the x and y coordinates of a mouse event,
;;;     and the mouse event
;;; RETURNS: the world that should follow the given world after
;;;     the given mouse event
;;; Strategy: cases on world state
;;; Examles:(world-after-mouse-event pause-world 1 2 "button-down") -> pause-world
(define (world-after-mouse-event w x y ev)
  (if (string=? RALLY (world-state w))
      (make-world (world-ball w)
                  (racket-after-mouse-event (world-racket w) x y ev)
                  (world-state w) (world-speed w) (world-pause-time w))
      w))    

; Test
(begin-for-test 
  (check-equal? (world-after-mouse-event pause-world 1 2 "button-down") 
                pause-world
                "it should be the same world")
  (check-equal? (world-after-mouse-event rally-world 1 2 "button-down") 
                rally-world
                "it should be the same world"))      
;;; racket-after-mouse-event
;;;     : Racket Int Int MouseEvent -> Racket
;;; GIVEN: a racket, the x and y coordinates of a mouse event,
;;;     and the mouse event
;;; RETURNS: the racket as it should be after the given mouse event
;;; Strategy cases on mouse event       
;;; Examles
;;; (racket-after-mouse-event racket-unselected X-POS Y-POS "button-down")
;;; -> racket-selected
;;; (racket-after-mouse-event racket-selected X-POS Y-POS "drag")
;;; -> racket-selected    
(define (racket-after-mouse-event r x y ev)
  (cond
    [(mouse=? ev "button-down") (racket-after-button-down r x y)]
    [(mouse=? ev "drag") (racket-after-drag r x y)]
    [(mouse=? ev "button-up") (racket-after-button-up r x y)]
    [else r]))
; Test
(begin-for-test 
  (check-equal? (racket-after-mouse-event racket-unselected X-POS Y-POS "button-down")
                racket-selected "the racket should be selected")
  (check-equal? (racket-after-mouse-event racket-unselected X-POS Y-POS "enter")
                racket-unselected "the racket should not be changed")
  (check-equal? (racket-after-mouse-event racket-selected X-POS Y-POS "drag")
                racket-selected "the racket should be dragged")
  (check-equal? (racket-after-mouse-event racket-selected X-POS Y-POS "button-up")
                racket-unselected "the racket should be unselected")
  (check-equal? (racket-after-mouse-event racket-unselected X-POS Y-POS "drag")
                racket-unselected "the racket should be dragged")
  (check-equal? (racket-after-mouse-event racket-unselected X-POS Y-POS "button-up")
                racket-unselected "the racket should be unselected"))

; in-racket? : Racket PosReal PosReal -> Boolean
; Given: a racket and a positon 
; Returns: true if the posion is in the circle of the racket center with 25 radius 
; Exmples: (in-racket? racket-unselected 1 1) -> false
; (in-racket? racket-unselected X-POS Y-POS) -> true
(define (in-racket? r x1 y1)
  (let ([x2 (racket-x r)] [y2 (racket-y r)])
    (< (distance-between-dots x1 y1 x2 y2) 25)))
(begin-for-test
  (check-equal? (in-racket? racket-at-20-20-0-5 1 1) false
                "it should return false")
  (check-equal? (in-racket? racket-unselected 1 1)false
                "it should return false"))
; difference-of-dots: Real Real Real Real
; Given positions of two points
; Returns: a list of the first two arguments and the difference of x1,x2 and y1,y2
; Examples (difference-of-dots 100 120 100 120) -> '(100 120 0 0)
; (difference-of-dots 30 100 40 10) -> '(30 100 10 -90)
(define (difference-of-dots x1 y1 x2 y2) 
  (list x1 y1 (- x2 x1) (- y2 y1)))
(begin-for-test
  (check-equal? (difference-of-dots 30 100 40 10) '(30 100 10 -90)
                "it should return '(30 100 10 -90)")
  (check-equal? (difference-of-dots 100 120 100 120) '(100 120 0 0)
                "it should return '(100 120 0 0)"))
; new-pos-racket: Racket Real Real Boolean -> Racket
; Given: a racket and positions of mouse and whether racket is selected
; Returns: a new racket according to the position
; Strategy: Cases on whether the racket is selected and use template on Racket
(define (new-pos-racket r x1 y1 selected?)
  (let* ([pos-mouse (racket-pos-mouse r)] 
         [t1 (list-ref pos-mouse 2)] [t2 (list-ref pos-mouse 3)])
    (if (equal? true selected?)
        (make-racket (+ t1 x1) (+ t2 y1)
                     (racket-vx r) (racket-vy r) true
                     (list x1 y1 t1 t2))
        (make-racket (+ t1 x1) (+ t2 y1)
                     (racket-vx r) (racket-vy r) false
                     (list 0 0 0 0)))))

; racket-after-button-down: Racket Real Real -> Racket
; Given:  a racket and positions of mouse
; Returns: a racket after mouse down.
; Strategy: cases on whether the position is in racket
(define (racket-after-button-down r x1 y1)
  (let ([x2 (racket-x r)] [y2 (racket-y r)])
    (if (in-racket? r x1 y1)
        (make-racket x2 y2 (racket-vx r) (racket-vy r)
                     true (difference-of-dots x1 y1 x2 y2))
        r)))

; racket-after-drag: Racket Real Real -> Racket
; Given:  a racket and positions of mouse
; Returns: a racket after mouse drag.
; Strategy: cases on whether the racket is selected 
(define (racket-after-drag r x y)
  (if (racket-selected? r)
      (new-pos-racket r x y true)
      r))

; racket-after-button-up: Racket Real Real -> Racket
; Given:  a racket and positions of mouse
; Returns: a racket after mouse up.
; Strategy: cases on whether the racket is selected 
(define (racket-after-button-up r x y)
  (if (racket-selected? r)
      (new-pos-racket r x y false)
      r))

; distance-between-dots: Real Real Real Real -> Real
; Given the positions of two points
; Returns: the distance between them
; Stratedy:
; AB=√((x1-x2)^2+(y1-y2)^2)
; Examples: (distance-between-dots 1 2 1 2) -> 0
; (distance-between-dots 1 3 2 4) -> 2
(define (distance-between-dots x1 y1 x2 y2)
  (sqrt(+ (expt (- x1 x2) 2) (expt (- y1 y2) 2))))
(begin-for-test
  (check-equal? (distance-between-dots 1 2 1 2) 0)
  (check-= (distance-between-dots 1 2 3 4) 2.8284 0.0001))