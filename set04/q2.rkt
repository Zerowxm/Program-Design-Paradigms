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
 world-balls
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

(check-location "04" "q2.rkt")
; The simulation is a universe program 
; that displays the positions and motions of a squash ball and
; the player's racket moving within a rectangular court.  
; Constants
; Dimensions and attributes of the court
(define UP "up")
(define DOWN "down")
(define LEFT "left")
(define RIGHT "right")

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
(define VX-INITIAL 3)
(define VY-INITIAL -9)

; Dimensions and attributes of the ball
(define BALL-RADIUS 3)
(define BALL-COLOR "black")
(define BALL-IMAGE (circle BALL-RADIUS "solid" BALL-COLOR))

; Dimensions and attributes of the racket
(define RACKET-WIDTH 47)
(define RACKET-HEIGHT 7)
(define RACKET-COLOR "green")
(define HALF-RACKET-WIDTH (/ RACKET-WIDTH 2))
(define RACKET-IMAGE (rectangle RACKET-WIDTH RACKET-HEIGHT "solid" RACKET-COLOR))
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
; balls racket state speed pause-time)
; INTERP
; balls : BallList  a list of the balls that are present in the world
; racket : Racket the player's racket
; state : WorldState the current state of world
; speed : PosReal the speed of the simulation, in seconds per tick
; pause-time : PosReal  the time counter when the world is in pause state 
; Implemention
(define-struct world (balls racket state speed pause-time))

; Constructor template
; (make-world BallList Racket WolrdState PosReal PosReal)

;;; world-balls : World -> BallList
;;; GIVEN: a world
;;; RETURNS: a list of the balls that are present in the world
          
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
   (world-balls w)
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

; A BallList is represented as a list of Ball
;; CONSTRUCTOR TEMPLATE AND INTERPRETATION
;; empty                  -- the empty sequence
;; (cons b ns)
;;   WHERE:
;;    b  is a Ball      -- the first Ball
;;                           in the sequence
;;    ns is a BallList  -- the rest of the 
;;                           balls in the sequence

;; OBSERVER TEMPLATE:
;; bl-fn : BallList -> ??
(define (bl-fn lst)
  (cond
    [(empty? lst) ...]
    [else (... (first lst)
               (bl-fn (rest lst)))]))

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
;;; GIVEN: a racket
;;; RETURNS: position of mouse 
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
   (make-balls (make-ball X-POS Y-POS 0 0) empty)
   (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
   READY-TO-SERVE
   speed
   0))

; make-balls: Ball BallList -> BallList
; GIVEN: a ball  and a list of balls
; RETURNS: a list like given one with a given ball added in list
; Strategy: use template on BallList
; Examples: (make-balls ball-at-80-75-1-5 (list ball-at-20-20-0-0)) =>
; (list ball-at-80-75-1-5 ball-at-20-20-0-0)
(define (make-balls b bl)
  (cons b bl))

; Tests
(define SPEED 1/3)
(define world-initial (initial-world SPEED))
(begin-for-test
  (check-equal? (initial-world SPEED)
                world-initial "(initial-world SPEED) should be world-initial"))

;; world-to-scene : World -> Scene
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE: if world is pause, then everthing will be still and court becomes yellow
;; and if world is rally, then the ball and the racket will move by the instructions
;; STRATEGY: Cases on world state.
(define (world-to-scene w)
  (if(string=? PAUSE (world-state w))
     (place-common-image w COURT-IMAGE-PAUSE)
     (rally-world-to-scene w)))

; balls-posn: BallList -> PosnList
; GIVEN: A list of ball
; RETURNS: a list of posn of ball in the given list
; Strategy: use observer template on BallList
; Examples: (balls-posn (list ball-at-20-20-0-0)) -> (list (make-posn 20 20))
(define (balls-posn bl)
  (cond
    [(empty? bl) empty]
    [else (let ([b (first bl)])
            (cons (make-posn (ball-x b) (ball-y b)) (balls-posn (rest bl))))]))

; place-common-image: World Image -> Image
; Given: a world and an image
; RETURNS: a image of world on the given image.
; Strategy: use obverser template on BallList and World
(define (place-common-image w bg)
  (let ([bl (world-balls w)] [r (world-racket w)])
    (place-images
     (append
      (make-list (length bl) BALL-IMAGE)
      (list RACKET-IMAGE))
     (append (balls-posn bl)
             (list (make-posn (racket-x r) (racket-y r)))
             )
     bg)))

; Test
; Test data
(define racket-selected
  (make-racket X-POS Y-POS 0 0 true (list X-POS Y-POS 0 0)))

(define racket-unselected
  (make-racket X-POS Y-POS 0 0 false (list 0 0 0 0)))

(define ball-at-20-20-1-1 (make-ball 20 20 1 1))

(define mouse-click-world
  (make-world (make-balls ball-at-20-20-1-1 empty)
              racket-selected
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

;; rally-world-to-scene : World -> Scene
;; Given: A world
;; RETURNS: a Scene that portrays the given world.
;; EXAMPLE: world becomes rally, then the ball and the racket will move
;; by the instructions
;; STRATEGY: use observer template on World and combine simpler functions
(define (rally-world-to-scene w)
  (let ([r (world-racket w)])
    (if (racket-selected? r)
        (place-image
         MOUSE-CIRCLE
         (list-ref (racket-pos-mouse r) 0)
         (list-ref (racket-pos-mouse r) 1)
         (place-common-image w  COURT-IMAGE))
        (place-common-image w  COURT-IMAGE))))
; Tests
(define image-serve (place-images
                     (list BALL-IMAGE RACKET-IMAGE)
                     (list (make-posn X-POS Y-POS)
                           (make-posn X-POS Y-POS)) COURT-IMAGE))

(define image-pause (place-images
                     (list BALL-IMAGE RACKET-IMAGE)
                     (list (make-posn X-POS Y-POS)
                           (make-posn X-POS Y-POS)) COURT-IMAGE-PAUSE))
(define pause-world (make-world 
                     (make-balls (make-ball X-POS Y-POS 0 0) empty)
                     (make-racket X-POS Y-POS 0 0  false '(0 0 0 0))
                     PAUSE SPEED SPEED))
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
; (make-balls (make-ball X-POS Y-POS VX-INITIAL VY-INITIAL) empty)
; (world-racket w) RALLY 1 0)
(define (world-to-rally w)
  (make-world 
   (make-balls (make-ball X-POS Y-POS VX-INITIAL VY-INITIAL) empty)
   (world-racket w)
   RALLY
   (world-speed w)
   0))
; Tests:
(define rally-world 
  (make-world 
   (make-balls (make-ball X-POS Y-POS VX-INITIAL VY-INITIAL) empty)
   (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
   RALLY SPEED 0))

(define rally-world-right-event 
  (make-world 
   (make-balls (make-ball X-POS Y-POS VX-INITIAL VY-INITIAL) empty)
   (make-racket X-POS Y-POS 1 0 false '(0 0 0 0))
   RALLY SPEED 0))
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
(define racket-at-11-11-1-1 (make-racket 11 11 1 1 false '(0 0 0 0)))
(define racket-at-10-10-0-0 (make-racket 10 10 0 0 false '(0 0 0 0)))
(define world-to-end (make-world (make-balls 
                                  ball-collide-back-wall empty)
                                 racket-at-10-10-1-1 
                                 RALLY SPEED 0))

(define world-after-end (make-world (make-balls
                                     ball-after-end empty)
                                    racket-at-10-10-0-0 
                                    PAUSE SPEED SPEED))
(begin-for-test 
  (check-equal? (world-after-tick world-to-end)
                world-after-end "the world should be pause")
  (check-equal? (world-after-tick world-initial)
                world-initial "the world should not be changed"))

;;; diff-world-state-after-tick : World -> World
;;; GIVEN: any world that's possible for the simulation
;;; RETURNS: the world that should follow the given world after a tick 
;;; Strategy: cases on the world state and combine simpler func
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
                            (make-balls (make-ball X-POS Y-POS 0 0) empty)
                            (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
                            PAUSE SPEED (* 2 SPEED)))
(define pause-world-to-serve (make-world 
                              (make-balls (make-ball X-POS Y-POS 0 0) empty)
                              (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
                              PAUSE SPEED 3))
(define rally-world-1-tick (make-world 
                            (make-balls (make-ball (+ 3 X-POS) (- Y-POS 9) 3 -9) empty)
                            (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
                            RALLY SPEED 0))
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
  (let ([bl (world-balls w)] [r (world-racket w)])
    (if (equal? PAUSE (world-state w))
        false
        (or (racket-collide-top-wall? r)
            (empty? (balls-collide-back-wall? bl))))))
; Tests
(begin-for-test 
  (check-equal? (rally-end? world-to-end) true "the world should end")
  (check-equal? (rally-end? pause-world) false "the world should not end"))

; balls-collide-back-wall?: BallList -> BallList
; Given: a list balls of a world
; Returns: a list like the given one except for the collided balls
; Strategy: use observer template of BallList
(define (balls-collide-back-wall? bl)
  (cond
    [(empty? bl) empty]
    [else (let* ([b (first bl)] [y (+ (ball-y b) (ball-vy b))])
            (if(> y COURT-HEIGHT)
               (balls-collide-back-wall? (rest bl))
               (cons b (balls-collide-back-wall? (rest bl)))))]))
;Tests
(begin-for-test
  (check-equal? (balls-collide-back-wall? (world-balls rally-world)) 
                (list (make-ball X-POS Y-POS VX-INITIAL VY-INITIAL))
                "it should not collide"))

; rally-world-after-tick: World -> World
; Given: a world in rally state
; Returns: the world that should follow the given world after a tick 
; Stategy : use constructor template on World 
; and combine simpler functions 
; E:(rally-world-after-tick rally-world) =>rally-world-1-tick
(define (rally-world-after-tick w)
  (make-world
   (balls-after-tick (world-balls w) (world-racket w))
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
  (let* ([bl (world-balls w)] [r (world-racket w)] [speed (world-speed w)])
    (if(< (world-pause-time w) 3)
       (make-world bl r (world-state w) speed (+ (world-pause-time w) speed))
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

; balls-after-tick: BallList Racket -> BallList
; Given: A list of balls and a racket
; Returns: a list of balls of the world that should follow the given world
; after a tick
; Strtegy: use observer template on BallList
; Examples: (balls-after-tick (make-balls ball-at-80-75-1-5 empty) racket-at-80-80-0-5)
;  => (make-balls (make-ball 81 80 1 -10) empty) 
(define (balls-after-tick bl r)
  (cond
    [(empty? bl) empty]
    [else 
     (let* ([fb (first bl)] [b (if (ball-collide-racket? fb r) 
                                   (ball-collide-racket fb (racket-vy r))
                                   (ball-next-motion fb))])
       (cons b (balls-after-tick (rest bl) r)))]))
; Tests
(define racket-at-80-80-0-5 (make-racket 80 80 0 -5 false '(0 0 0 0)))
(define racket-at-80-80-0-0 (make-racket 80 80 0 0 false (list 0 0 0 0)))
(define ball-at-80-75-1-5 (make-ball 80 75 1 5))
(define world-ball-collide-racket (make-world
                                   (make-balls ball-at-80-75-1-5 empty)
                                   racket-at-80-80-0-5 
                                   RALLY SPEED 0))
(begin-for-test
  (check-equal? (balls-after-tick (make-balls ball-at-80-75-1-5 empty)
                                  racket-at-80-80-0-5)
                (make-balls (make-ball 81 80 1 -10) empty)
                "the ball should at (81 80) with v (1,-10)"))

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
                (make-ball 18 18 10 10)
                "the ball should at (18,18) with v (10,10)")
  (check-equal? (ball-next-motion collide-side-ball1) 
                (make-ball 8 12 10 2)
                "the ball should at (8,12) with v (10,2)")
  (check-equal? (ball-next-motion collide-side-ball2) 
                (make-ball 416 12 -10 2)
                "the ball should at (416,12) with v (-10,2)")
  (check-equal? (ball-next-motion collide-top-ball) 
                (make-ball 12 8 2 10))
  "the ball should at (12,8) with v (2,10)")
; ball-no-collide Ball -> Ball
; Given: a ball which does not collide any thing
; Returns: the ball in next movement by changing the pos of the ball.
; Strategy: use template on Ball
; Examples: (ball-no-collide ball-at-80-75-1-5) => ball-at-81-80-1-5
(define (ball-no-collide b)
  (make-ball (+ (ball-x b) (ball-vx b))
             (+ (ball-y b) (ball-vy b)) 
             (ball-vx b) (ball-vy b)))

; ball-collide-wall? Ball -> Integer
; Given: a ball
; Returns: 0 if ball does not collide the wall
; 1 if ball collides side wall and 2 if collides top wall
; 3 if ball collides both walls.
; Stratagy : cases on the collision
; Examples: (ball-collide-wall? ball-at-20-20-1-1) => 0
(define (ball-collide-wall? b)
  (let ([y (+ (ball-y b) (ball-vy b))]
        [x (+ (ball-x b) (ball-vx b))])
    (+ (ball-collide-top-wall? y) (ball-collide-side-wall? x))))

; ball-collide-side-wall?: Integer -> Integer
; Given: the tentive x of the ball
; Returns: 1 if ball collide the side wall 0 if not
; Stratagy : cases on the collision
(define (ball-collide-side-wall? x)
  (if (or (< x 0) (> x COURT-WIDTH))
      1
      0))

; ball-collide-top-wall?: Integer -> Integer
; Given: the tentive y of the ball
; Returns: 2 if ball collide the top wall 0 if not
; Stratagy: cases on the y if y < 0 return 2
; Examples: (ball-collide-top-wall? 3) 0 
(define (ball-collide-top-wall? y)
  (if(< y 0)
     2
     0))
(begin-for-test
  (check-equal? (ball-collide-top-wall? 3) 0 "it should return 0"))

; ball-collide-side-wall: Ball -> Ball
; Given: a ball colliding the side wall
; Returns: a ball afrer colliding the side wall
; Strategy: cases on right side or left side wall
; Examples: (ball-collide-side-wall ball-at-426-100-10-10)
; => ball-at-424-110--10-10
(define (ball-collide-side-wall b)
  (let* ([vx (ball-vx b)]
         [x (+ (ball-x b) vx)])
    (if (< x 0)
        (make-ball (- x) (+ (ball-vy b) (ball-y b)) (- vx) (ball-vy b))
        (make-ball (- 850 x) (+ (ball-vy b) (ball-y b)) (- vx) (ball-vy b)))))

; ball-collide-top-wall: Ball -> Ball
; Given: a ball colliding the top wall
; Returns: a ball afrer colliding the top wall
; Strategy: use template on Ball
; Examples: (ball-collide-top-wall ball-at-100-1-10--10)
; => ball-at-110-9-10
(define (ball-collide-top-wall b)
  (let* ([vy (ball-vy b)]
         [y (+ (ball-y b) vy)])
    (make-ball (+ (ball-vx b) (ball-x b)) (- y) (ball-vx b) (- vy))))

; ball-collide-racket: Ball Integer -> Ball
; Given: a ball colliding the racket and the vy of racket
; Returns: a ball afrer colliding the racket
; Strategy: use template on Ball
; Examples: (ball-collide-racket ball-at-80-75-1-5 0) => ball-at-81-80-1--5
(define (ball-collide-racket b vy)
  (make-ball (+ (ball-x b) (ball-vx b))
             (+ (ball-vy b) (ball-y b)) 
             (ball-vx b) (- vy (ball-vy b))))
(begin-for-test
  (check-equal? (ball-collide-racket ball-at-80-75-1-5 0) (make-ball 81 80 1 -5)))
;racket-after-tick: World -> racket
; Given: A world in rally state
; Returns: the racket of the world that should follow the given world
; after a tick
; Strtegy: cases on racket collision
; Examples:
;(racket-after-tick world-ball-collide-racket)
; => (make-racket 24 20 0 0 false '(0 0 0 0))
(define (racket-after-tick w)
  (let ([bl (world-balls w)] [r (world-racket w)])
    (cond
      [(balls-collide-racket? bl r) (racket-collide-ball r)]
      [(racket-collide-side-wall? r) (racket-collide-side-wall r)]
      [else (racket-next r)])))
;Test
(define world-ball-wall
  (make-world
   (make-balls (make-ball 240 19 1 5) empty)
   (make-racket 240 20 0 -2
                false '(0 0 0 0)) RALLY SPEED 0))
(define world-racket-wall
  (make-world
   (make-balls (make-ball 18 19 1 5) empty)
   (make-racket 440 20 0 -2 false '(0 0 0 0)) RALLY
   SPEED 0))
(begin-for-test
  (check-equal? (racket-after-tick world-ball-collide-racket)
                (make-racket 80 75 0 0 false '(0 0 0 0))
                "it should return (racket 80 75 0 0 false '(0 0 0 0))")
  (check-equal? (racket-after-tick world-ball-wall)
                (make-racket 240 18 0 -2 false '(0 0 0 0))
                "it should return (racket 240 18 0 -2 false '(0 0 0 0))")
  (check-equal? (racket-after-tick world-racket-wall)
                (make-racket 401 18 0 -2 false '(0 0 0 0))
                "it should return (racket 401 18 0 -2 false '(0 0 0 0))"))

; racket-collide-ball: Racket -> Racket
; Given: a racket colliding the ball
; Returns: a racket afrer colliding the ball
; Strategy: cases on vy of the racket and use template on Racket
; Examples: (racket-collide-ball racket-at-10-10-1-1) => racket-at-10-10-1-1
(define (racket-collide-ball r)
  (if (< (racket-vy r) 0)
      (make-racket (racket-x r) (+ (racket-y r) (racket-vy r)) 
                   (racket-vx r) 0 (racket-selected? r) (racket-pos-mouse r))
      r))
; Test
(begin-for-test
  (check-equal? (racket-collide-ball racket-at-10-10-1-1)
                racket-at-10-10-1-1 "racket whould not change")
  (check-equal? (racket-collide-ball 
                 (make-racket 1 1 -1 -1 false '(0 0 0 0)))
                (make-racket 1 0 -1 0 false '(0 0 0 0))
                "racket should change vy to 0"))

; racket-collide-side-wall: Racket -> Racket
; Given: a racket colliding the side wall
; Returns: a racket afrer colliding the side wall
; Strategy: cases on colliding the right side or left side wall
; Examples: (racket-collide-side-wall racket-at-10-10-1-1)
; =>               (make-racket 24 11 0 1 false '(0 0 0 0)) 
(define (racket-collide-side-wall r)
  (let ([x (if (< (racket-x r) (/ COURT-WIDTH 2)) (ceiling HALF-RACKET-WIDTH) 
               (floor (- COURT-WIDTH HALF-RACKET-WIDTH)))]
        [y (if (racket-selected? r) (racket-y r)
               (+ (racket-vy r) (racket-y r)))])
    (make-racket x y 0 (racket-vy r) (racket-selected? r) (racket-pos-mouse r))))
; Tests
(define racket-selected-collided-wall 
  (make-racket 23 111 -1 -1 true '(24 111 1 0)))
(begin-for-test 
  (check-equal? (racket-collide-side-wall racket-at-10-10-1-1)
                (make-racket 24 11 0 1 false '(0 0 0 0)) 
                "it should be (make-racket 24 11 0 1 false '(0 0 0 0))")
  (check-equal? (racket-collide-side-wall (make-racket 234 10 1 1  false '(0 0 0 0)))
                (make-racket 401 11 0 1 false '(0 0 0 0)) 
                "it should be (make-racket 401 11 0 1 false '(0 0 0 0))")
  (check-equal? (racket-collide-side-wall racket-selected-collided-wall) 
                (make-racket 24 111 0 -1 true '(24 111 1 0))))

; racket-next: Racket -> Racket
; given: a racket
; RETURNS: a racket after a tick
; STRATEGY: use template on  Racket
; Examples: (racket-next racket-at-10-10-1-1) => racket-at-11-11-1-1)
; (racket-next racket-selected) => racket-selected
(define (racket-next r)
  (if (racket-selected? r)
      r
      (make-racket (+ (racket-x r) (racket-vx r))
                   (+ (racket-y r) (racket-vy r))
                   (racket-vx r) (racket-vy r)
                   (racket-selected? r) (racket-pos-mouse r))))
(begin-for-test
  (check-equal? (racket-next racket-at-10-10-1-1) racket-at-11-11-1-1
                "it should racket-at-11-11-1-1")
  (check-equal? (racket-next racket-selected) racket-selected
                "it should not change"))
; racket-collide-top-wall: Racket -> Racket
; Given: a racket colliding the top wall
; Returns: a racket afrer colliding the top wall
; Strategy: cases on racket collision
; Examples: (racket-collide-top-wall? racket-at-80-80-0-5) => false
(define (racket-collide-top-wall? r)
  (let ([y (+ (racket-y r) (racket-vy r))])
    (< y 0)))
(begin-for-test
  (check-equal? (racket-collide-top-wall? racket-at-80-80-0-5) false
                "it should return false"))

; racket-collide-side-wall? Racket -> Boolean
; Given: a racket
; Returns: true if racket collide the side wall 
; Stratagy : cases on the collision
; Examples: (racket-collide-side-wall? racket-80-80-0-0) false
(define (racket-collide-side-wall? r)
  (let ([x (+ (racket-x r) (racket-vx r))] [half HALF-RACKET-WIDTH])
    (or (> x (- COURT-WIDTH half)) 
        (< x half))))

; press-space: World -> World
; Given: A world is not paused
; Returns: a world which is paused and the ball and racket do not move
; Strategy: use template on World , Ball and Racket.
; Examples: (press-space rally-world) => puase-world
(define (press-space w)
  (let ([bl (world-balls w)] [r (world-racket w)])
    (make-world (map puased-ball bl)
                (make-racket (racket-x r) (racket-y r)
                             0 0 false (racket-pos-mouse r))
                PAUSE
                (world-speed w)
                (world-speed w))))
; puased-ball: Ball -> Ball
; GIVEN: a ball
; RETURNS: the given ball except that the velocity is 0
; STRATEGY: use template of Ball
; Examples (puased-ball (make-ball 1 1 3 4)) => (make-ball 1 1 0 0)
(define (puased-ball b)
  (make-ball (ball-x b) (ball-y b) 0 0))
(begin-for-test
  (check-equal? (puased-ball (make-ball 1 1 3 4)) (make-ball 1 1 0 0) 
                "it returns wrong"))

; balls-collide-racket? : BallList Racket -> Boolean
; Given: a ball list and a racket
; Returns: true if any ball and the racket are collided.
; Strategy: Cases on collision
; Examles: (balls-collide-racket? (make-balls ball-23 empty) racket-23) => true
; (balls-collide-racket? (make-balls (make-ball 24 300 3 9) empty) racket-24) => false
(define (balls-collide-racket? bl r)
  (cond
    [(empty? bl) false]
    [(ball-collide-racket? (first bl) r) true]
    [else (balls-collide-racket? (rest bl) r)]))
(begin-for-test
  (check-equal? (balls-collide-racket? (make-balls ball-24 empty) racket-24) true)
  "it returns wrong item")

; ball-collide-racket? : Ball Racket -> Boolean
; Given: a ball and a racket
; Returns: true if the ball and the racket are collided.
; Strategy: Cases on collision
; Examles: (ball-collide-racket? ball-23 racket-23) => true
; (ball-collide-racket? (make-ball 24 300 3 9) racket-24) => false
(define (ball-collide-racket? b r)
  (cond
    [(ball-never-collide-racket? b r) false]
    [(collide-y? b r) (collide-x? b r)]
    [else false]))
; Test  
(define racket-24 (make-racket 24 300 0 0 false (list 0 0 0 0)))
(define ball-24 (make-ball 24 299 3 9))
(begin-for-test
  (check-equal? (ball-collide-racket? ball-24 racket-24) true 
                "it should be true")
  (check-equal? (ball-collide-racket? (make-ball 24 300 3 9) racket-24) false
                "it should return false")
  (check-equal? (ball-collide-racket? ball-at-80-75-1-5 racket-at-80-80-0-0) true
                "it should return true")
  (check-equal? (ball-collide-racket? ball-at-80-75-1-5 racket-at-80-80-0-5) true
                "it should return true"))

; ball-never-collide-racket?: Ball Racket -> Boolean
; Given: a ball and racket
; Returns: true if vy of ball less than 0 or the ball is on the racket
; Strategy: user observer template on Ball and combine simpler func
; Examples: (ball-never-collide-racket? (make-ball 24 300 3 9) racket-24) => true
(define (ball-never-collide-racket? b r)
  (or (< (ball-vy b) 0) (ball-on-racket-last-tick? b r)))
;Test
(begin-for-test
  (check-equal? (ball-never-collide-racket? (make-ball 24 300 3 9) racket-24) true))

; ball-on-racket-last-tick? Ball Racket -> Boolean
; Given: a ball and racket
; Returns: true if the ball is on the racket
; Strategy: user observer template on Ball
; Exampes: (ball-never-collide-racket? (make-ball 24 300 3 -3) racket-24) => true
(define (ball-on-racket-last-tick? b r)
  (and (= (ball-y b) (racket-y r)) 
       (<= (abs (- (ball-x b) (racket-x r))) HALF-RACKET-WIDTH)))
(begin-for-test
  (check-equal? (ball-never-collide-racket? (make-ball 24 300 3 -3) racket-24) true)
  "it should return true")

; helper functions on collision
; collide-y? : Ball Racket -> Boolean
; Given: a ball and a racket
; Returns: true if the track of the ball and racket position has the same point
; Strategy: formula the pos-y of racket is between 
; the start y the end y during a tick of the ball
; Examples: (collide-y? ball-at-20-20-1-1 racket-at-10-10-1-1) false
(define (collide-y? b r)
  (let ([y (+ (racket-vy r) (racket-y r))])
    (or (<= (ball-y b) y 
            (+ (ball-y b) (ball-vy b)))
        (>= (ball-y b) y
            (+ (ball-y b) (ball-vy b))))))
(begin-for-test
  (check-equal? (collide-y? ball-at-20-20-1-1 racket-at-10-10-1-1) false
                "it should return false"))

; collide-x? : Ball Racket -> Boolean
; Given: a ball and a racket
; Returns: true if the collide x is on the center line of racket 
; Strategy: use observer template on Racket
; Examples: (collide-x? ball-at-20-20-1-1 racket-at-10-10-1-1) true
(define (collide-x? b r)
  (<= (abs (- (+ (racket-vx r) (racket-x r)) (collide-x b r))) HALF-RACKET-WIDTH))
(begin-for-test
  (check-equal? (collide-x? ball-at-20-20-1-1 racket-at-10-10-1-1) true
                "it should return true"))

; collide-x : Ball Racket -> Boolean
; Given: a ball and a racket
; Returns: x of the line of ball's start position and end position
; when y is equal to the y of the racket
; Strategy: use formula (x2-x1)(y-y1)=(y2-y1)(x-x1)
; Examples: (collide-x ball-at-80-75-1-5 racket-at-80-80-0-5) -> 80
(define (collide-x b r)
  (let ([x1 (ball-x b)] [y1 (ball-y b)])
    (+ (* (/ (ball-vx b) (ball-vy b)) (- (+ (racket-y r) (racket-vy r)) y1)) x1)))
(begin-for-test
  (check-equal? (collide-x ball-at-80-75-1-5 racket-at-80-80-0-5) 80) "it should be 80")

;;; world-after-key-event : World KeyEvent -> World
;;; GIVEN: a world and a key event
;;; RETURNS: the world that should follow the given world
;;;     after the given key event
;;; Strategy: cases on the world state
;;; Examples
;;; (world-after-key-event world-initial NON-PAUSE-KEY-EVENT) -> world-initial
;;; (world-after-key-event world-initial PAUSE-KEY-EVENT) -> rally-world
;;; (world-after-key-event rally-world PAUSE-KEY-EVENT) -> pause-world
(define (world-after-key-event w ev)
  (let ([state (world-state w)])
    (cond
      [(equal? RALLY state) (rally-world-after-key-event w ev)]
      [(and (equal? READY-TO-SERVE state) (is-pause-key-event? ev))
       (world-to-rally w)]
      [else w])))
; Test
(begin-for-test 
  (check-equal? (world-after-key-event world-initial NON-PAUSE-KEY-EVENT)
                world-initial "it should result that nothing will change")
  (check-equal? (world-after-key-event world-initial PAUSE-KEY-EVENT)
                rally-world "it should result rally-world")
  (check-equal? (world-after-key-event rally-world PAUSE-KEY-EVENT)
                pause-world "it should result that world is paused")
  (check-equal? (world-after-key-event rally-world NON-PAUSE-KEY-EVENT)
                rally-world "it should result that world does nothing"))

; rally-world-after-key-event： World KeyEvent -> World
;;; GIVEN: a world and a key event
;;; RETURNS: the world that should follow the given world
;;;     after the given key event
;;; Strategy: cases on the world state
;;; Examples: (rally-world-after-key-event rally-world b-key-event)
;   => (press-b rally-world)
(define (rally-world-after-key-event w ev)
  (cond
    [(is-pause-key-event? ev) (press-space w)]
    [(is-b-key-event? ev) (press-b w)]
    [else (arrow-key-event w ev)]))
(begin-for-test 
  (check-equal? (rally-world-after-key-event rally-world b-key-event)
                (press-b rally-world)))

;; is-b-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a b instruction
;; Strategy: cases on key event if key is b return true
;; Examples: (is-b-key-event? "b") => true
(define (is-b-key-event? ev)
  (key=? ev "b")) 

(define b-key-event "b")
; press-b: World -> World
; Given: a world
; Returns: a world after b pressed
; Strategy: use template on World
; Examples: (press-b rally-wolrd) => 
(define (press-b w)
  (make-world (make-balls (make-ball X-POS Y-POS VX-INITIAL VY-INITIAL)
                          (world-balls w))
              (world-racket w)
              (world-state w)
              (world-speed w)
              (world-pause-time w)))
;Test
(define rally-world-two-balls 
  (make-world 
   (make-balls (make-ball X-POS Y-POS VX-INITIAL VY-INITIAL)
               (world-balls rally-world))
   (make-racket X-POS Y-POS 0 0 false '(0 0 0 0))
   RALLY SPEED 0))
(begin-for-test
  (check-equal? (press-b rally-world) rally-world-two-balls
                "it should return two balls"))

; arrow-key-event: World KeyEvent -> World
;;; GIVEN: a world and a key event
;;; RETURNS: the world that should follow the given world
;;;     after the given key event
;;; Strategy: cases on the arrow key and use template on World
;;; Examles: (arrow-key-event rally-world "a") ->rally-world
;;; (arrow-key-event rally-world "right") -> rally-world-right-event
(define (arrow-key-event w ev)
  (let* ([v (arrow-key-event? ev)]
         [vx (list-ref v 0)] [vy (list-ref v 1)] [r (world-racket w)])
    (if(= vx vy 0)
       w
       (make-world (world-balls w)
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
    [(key=? ev UP) '(0 -1)]
    [(key=? ev DOWN) '(0 1)]
    [(key=? ev LEFT) '(-1 0)]
    [(key=? ev RIGHT) '(1 0)]
    [else '(0 0)]))   
(begin-for-test
  (check-equal? (arrow-key-event? UP) '(0 -1)) 
  (check-equal? (arrow-key-event? DOWN) '(0 1)) 
  (check-equal? (arrow-key-event? LEFT) '(-1 0))
  (check-equal? (arrow-key-event? RIGHT) '(1 0)) 
  (check-equal? (arrow-key-event? NON-PAUSE-KEY-EVENT) '(0 0))) 
;; help function for key event
;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
(define (is-pause-key-event? ev)
  (key=? ev " "))   
;; examples KeyEvents for testing
(define PAUSE-KEY-EVENT " ")
(define NON-PAUSE-KEY-EVENT "q") 
;; example MouseEvents for testing:
(define BUTTON-DOWN-EVENT "button-down")
(define DRAG-EVENT "drag")
(define BUTTON-UP-EVENT "button-up")
(define OTHER-EVENT "enter") 

;;; world-after-mouse-event
;;;     : World Int Int MouseEvent -> World
;;; GIVEN: a world, the x and y coordinates of a mouse event,
;;;     and the mouse event
;;; RETURNS: the world that should follow the given world after
;;;     the given mouse event
;;; Strategy: cases on world state
;;; Examles:(world-after-mouse-event pause-world 1 2 BUTTON-DOWN-EVENT)
;    -> pause-world
(define (world-after-mouse-event w x y ev)
  (if (string=? RALLY (world-state w))
      (make-world (world-balls w)
                  (racket-after-mouse-event (world-racket w) x y ev)
                  (world-state w) (world-speed w) (world-pause-time w))
      w))    

; Test
(begin-for-test 
  (check-equal? (world-after-mouse-event pause-world 1 2 BUTTON-DOWN-EVENT) 
                pause-world
                "it should be the same world")
  (check-equal? (world-after-mouse-event rally-world 1 2 BUTTON-DOWN-EVENT) 
                rally-world
                "it should be the same world"))      
;;; racket-after-mouse-event
;;;     : Racket Int Int MouseEvent -> Racket
;;; GIVEN: a racket, the x and y coordinates of a mouse event,
;;;     and the mouse event
;;; RETURNS: the racket as it should be after the given mouse event
;;; Strategy cases on mouse event       
;;; Examles
;;; (racket-after-mouse-event racket-unselected X-POS Y-POS BUTTON-DOWN-EVENT)
;;; -> racket-selected
;;; (racket-after-mouse-event racket-selected X-POS Y-POS DRAG-EVENT)
;;; -> racket-selected    
(define (racket-after-mouse-event r x y ev)
  (cond
    [(mouse=? ev BUTTON-DOWN-EVENT) (racket-after-button-down r x y)]
    [(mouse=? ev DRAG-EVENT) (racket-after-drag r x y)]
    [(mouse=? ev BUTTON-UP-EVENT) (racket-after-button-up r x y)]
    [else r]))
; Test
(begin-for-test 
  (check-equal? (racket-after-mouse-event racket-unselected
                                          X-POS Y-POS BUTTON-DOWN-EVENT)
                racket-selected "the racket should be selected")
  (check-equal? (racket-after-mouse-event racket-unselected X-POS Y-POS "enter")
                racket-unselected "the racket should not be changed")
  (check-equal? (racket-after-mouse-event racket-selected X-POS Y-POS DRAG-EVENT)
                racket-selected "the racket should be dragged")
  (check-equal? (racket-after-mouse-event racket-selected X-POS
                                          Y-POS BUTTON-UP-EVENT)
                racket-unselected "the racket should be unselected")
  (check-equal? (racket-after-mouse-event racket-unselected X-POS
                                          Y-POS DRAG-EVENT)
                racket-unselected "the racket should be dragged")
  (check-equal? (racket-after-mouse-event racket-unselected X-POS
                                          Y-POS BUTTON-UP-EVENT)
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
  (check-equal? (in-racket? racket-at-80-80-0-5 1 1) false
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
