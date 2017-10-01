;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require 2htdp/universe)
(require 2htdp/image)
(require "extras.rkt")
(provide
 )

(check-location "03" "q1.rkt")
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
; vx, vy : Real  two components vx and vy of the ball 
;          telling how many pixels it moves on each tick 
;          in the x and y directions, respectively.

(define-struct ball (x y vx vy))
; Constructor template
; (make-ball Integer Integer Real Real)


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

; A Racket is represented as (make-racket x-pos y-pos vx vy)
; Interpretation:
; x, y   : Integer  the position of the center of the racket
;          in the scene 
; vx, vy : Real  two components vx and vy of the racket 
;          telling how many pixels it moves on each tick                                             
;          in the x and y directions, respectively.

(define-struct racket (x y vx vy))
; Constructor template
; (make-racket Integer Integer Real Real)

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
; Observer template
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
   (on-draw world-to-scene)
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
   0
   ))

; Tests
(begin-for-test
     (check-equal? (initial-world 1) (make-world 
   (make-ball X-POS Y-POS 0 0)
   (make-racket X-POS Y-POS 0 0)
   READY-TO-SERVE
   1
   0
   )))

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
       (place-images
        (list BALL-IMAGE
              RACKET-IMAGE)
        (list (make-posn (ball-x b) (ball-y b))
              (make-posn (racket-x r) (racket-y r)))
        COURT-IMAGE
        )
       )))
 
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
   0
   ))
(define initial-1 (initial-world 1))
(begin-for-test
     (check-equal? (world-to-rally initial-1)  
          (make-world 
   (make-ball X-POS Y-POS 3 -9)
   (world-racket initial-1)
   RALLY
   1
   0
   )))

;;; world-ready-to-serve? : World -> Boolean
;;; GIVEN: a world
;;; RETURNS: true iff the world is in its ready-to-serve state
;;; Stategy: cases on world state
(define (world-ready-to-serve? w)
  (equal? READY-TO-SERVE (world-state w)))



;;; world-after-tick : World -> World
;;; GIVEN: any world that's possible for the simulation
;;; RETURNS: the world that should follow the given world
;;;     after a tick
;;; Strategy: cases on world state if world is no longer in rally, treat it as
;;; press space

(define (world-after-tick w)
  (if (rally-end? w)
      (press-space w)
      (diff-world-state-after-tick w))
  )

;;; diff-world-state-after-tick : World -> World
;;; GIVEN: any world that's possible for the simulation
;;; RETURNS: the world that should follow the given world
;;;     after a tick 
;;; Strategy: cases on the world state
(define (diff-world-state-after-tick w)
  (let ([state (world-state w)])
    (cond
      [(equal? PAUSE state) (pause-world-after-tick w)]
      [(equal? RALLY state) (rally-world-after-tick w)]
      [else w])))
; rally-end? : World -> Bollean
; Given: any world that's possible for the simulation
; Returns: true if the ball collides the back wall or the racket
; collides the top wall
; Strategy: cases on whether the world is no longer in rally
(define (rally-end? w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (or (racket-collide-top-wall? r)
        (ball-collide-back-wall? b))))

; ball-collide-back-wall?: Ball -> Bollean
; Given: a ball of a world
; Returns: true if the ball collides the back wall
; Strategy: cases
(define (ball-collide-back-wall? b)
  (let ([y (+ (ball-y b) (ball-vy b))])
    (if(> y 649)
       true
       false)))

; rally-world-after-tick: World -> World
; Given: a world in rally state
; Returns: the world that should follow the given world
;;;     after a tick 
; Stategy : use constructor template on World 
; and combine simpler functions 
(define (rally-world-after-tick w)
  (make-world
   (ball-after-tick w)
   (racket-after-tick w)
   (world-state w) 
   (world-speed w)
   (world-pause-time w))
  )
(define w1 (initial-world 1/3))

; pause-world-after-tick: World -> World
; Given: A world in pause state
; Returns: the world that should follow the given world
; after a tick
; Stategy: cases on the puase-time if time < 3 the world is still pausing 
(define (pause-world-after-tick w)
  (let* ([b (world-ball w)] [r (world-racket w)] [speed (world-speed w)])
    (if(< (world-pause-time w) 3)
       (make-world b r (world-state w)
                   speed
                   (+ (world-pause-time w) speed))
       (initial-world (world-speed w))
       )))

;ball-after-tick: World -> Ball
; Given: A world in rally state
; Returns: the ball of the world that should follow the given world
; after a tick
; Strtegy: cases on ball collision
(define (ball-after-tick w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (if (ball-collide-racket? b r)
        (ball-collide-racket b (racket-vy r))
        (ball-next-motion b)
        )))

; ball-next-motion: Ball -> Ball
; Given: A ball 
; Returns: the ball after
; Strtegy: cases on ball collision
(define (ball-next-motion b)
  (let ([type (ball-collide-wall? b)])
    (cond
      [(= 0 type) (ball-no-collide b)]
      [(= 1 type) (ball-collide-side-wall b)]
      [(= 2 type) (ball-collide-top-wall b)]
      [else (ball-collide-side-wall (ball-collide-top-wall b))])))

; ball-no-collide Ball -> Ball
; Given: a ball which does not collide any thing
; Returns: the ball in next movement by changing the pos of the ball.
; Strategy: use template on Ball
(define (ball-no-collide b)
     (make-ball (+ (ball-x b) (ball-vx b))
                             (+ (ball-y b) (ball-vy b)) 
                             (ball-vx b) (ball-vy b)))


; ball-collide-wall? Ball -> Bollean
; Given: a ball
; Returns: 0 if ball does not collide the wall
; 1 if ball collides side wall and 2 if collides top wall
; 3 if ball collides both walls.
; Stratagy : cases on the collision
(define (ball-collide-wall? b)
  (let ([y (+ (ball-y b) (ball-vy b))]
        [x (+ (ball-x b) (ball-vx b))])
    (+ (ball-collide-top-wall? y) (ball-collide-side-wall? x))))

; ball-collide-side-wall? Ball -> Bollean
; Given: a ball
; Returns: 1 if ball collide the side wall 0 if not
; Stratagy : cases on the collision
(define (ball-collide-side-wall? x)
  (if (or (< x 0) (> x 425))
      1
      0))

; ball-collide-top-wall? Ball -> Bollean
; Given: a ball
; Returns: 2 if ball collide the top wall 0 if not
; Stratagy : cases on the collision
(define (ball-collide-top-wall? y)
  (if(< y 0)
     2
     0))

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

; ball-collide-racket: Ball Real -> Ball
; Given: a ball colliding the racket
; Returns: a ball afrer colliding the racket
; Strategy: use template on Ball
(define (ball-collide-racket b vy)
  (make-ball (ball-x b) (ball-y b) 
             (ball-vx b) (- vy (ball-vy b)))
  )

; racket-collide-ball: Racket Real -> Racket
; Given: a racket colliding the ball
; Returns: a racket afrer colliding the ball
; Strategy: cases on vy of the racket and use template on Racket
(define (racket-collide-ball r)
  (if (< (racket-vy r) 0)
      (make-racket (racket-x r) (racket-y r) 
                   (racket-vx r) 0)
      r))

; racket-collide-side-wall? Racket -> Bollean
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
      (make-racket 23.5 (racket-y r) (racket-vx r) (racket-vy r))
      (make-racket 401.5 (racket-y r) (racket-vx r) (racket-vy r))
      ))

; racket-collide-top-wall: Racket -> Racket
; Given: a racket colliding the top wall
; Returns: a racket afrer colliding the top wall
; Strategy: cases
(define (racket-collide-top-wall? r)
  (let ([y (+ (racket-y r) (racket-vy r))])
    (< y 0)))


;racket-after-tick: World -> racket
; Given: A world in rally state
; Returns: the racket of the world that should follow the given world
; after a tick
; Strtegy: cases on racket collision
(define (racket-after-tick w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (cond 
      [(and (ball-collide-racket? b r) (racket-collide-side-wall? r)) 
       (racket-collide-side-wall (racket-collide-ball r))]
      [(ball-collide-racket? b r) (racket-collide-ball r)]
      [(racket-collide-side-wall? r) (racket-collide-side-wall r)]
      [else (make-racket (+ (racket-x r) (racket-vx r))
                         (+ (racket-y r) (racket-vy r))
                         (racket-vx r) (racket-vy r))]
      )))

; press-space: World -> World
; Given: A world is not paused
; Returns: a world which is paused and the ball and racket do not move
; Strategy: use template on World , Ball and Racket.
(define (press-space w)
  (let ([b (world-ball w)] [r (world-racket w)])
    (make-world (make-ball (ball-x b) (ball-y b) 0 0)
                (make-racket (racket-x r) (racket-y r) 0 0)
                PAUSE
                (world-speed w)
                0)))

; ball-collide-racket? : Ball Racket -> Bollean
; Given: a ball and a racket
; Returns: true if the ball and the racket are collided.
; Strategy: Cases on collision
(define (ball-collide-racket? b r)
  (and (collide-y? b r) (collide-x? b r)))  

; helper functions on collision
; collide-y? : Ball Racket -> Bollean
; Given: a ball and a racket
; Returns: true the pos-y of racket is between 
; the start y the end y during a tick of the ball
; Strategy: formula 
(define (collide-y? b r)
  (or (< (ball-y b) (racket-y r) (+ (ball-y b) (ball-vy b)))
      (> (ball-y b) (racket-y r) (+ (ball-y b) (ball-vy b)))))

; collide-x : Ball Racket -> Bollean
; Given: a ball and a racket
; Returns: x of the line of ball's start position and end position
; when y is equal to the y of the racket
; Strategy: formula 
(define (collide-x b r)
  (let ([x1 (ball-x b)] [y1 (ball-y b)])
    (+ (* (/ (ball-vx b) (ball-vy b)) (- (racket-y r) y1)) x1)))

; collide-x? : Ball Racket -> Bollean
; Given: a ball and a racket
; Returns: true if the collide x is on the center line of strategy 
; Strategy: cases 
(define (collide-x? b r)
  (< (abs (- (racket-x r) (collide-x b r))) 23.5))

;;; world-after-key-event : World KeyEvent -> World
;;; GIVEN: a world and a key event
;;; RETURNS: the world that should follow the given world
;;;     after the given key event
;;; Strategy: cases on the world state
(define (world-after-key-event w ev)
  (let ([state (world-state w)])
    (cond
      [(equal? RALLY state) (rally-world-after-key-event w ev)]
      [(equal? READY-TO-SERVE state) (world-to-rally w)]
      [else w])))

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
(define (arrow-key-event w ev)
  (let* ([v (arrow-key-event? ev)]
         [vx (list-ref v 0)] [vy (list-ref v 1)] [r (world-racket w)])
    (if(null? v)
       w
       (make-world (world-ball w)
                   (make-racket (racket-x r) (racket-y r)
                                (+ (racket-vx r) vx) (+ (racket-vy r) vy))
                   (world-state w)
                   (world-speed w)
                   (world-pause-time w)))))  

;;; arrow-key-event? KeyEvent -> List
;;; GIVEN: a key event
;;; RETURNS: the list containing 
;;; vx and vy that should be added to the racket
;;; after the given key event
;;; Strategy: cases on the arrow key
(define (arrow-key-event? ev)
  (cond
    [(key=? ev "up") '(0 -1)]
    [(key=? ev "down") '(0 1)]
    [(key=? ev "left") '(-1 0)]
    [(key=? ev "right") '(1 0)]
    [else '()]))   

;; help function for key event
;; is-pause-key-event? : KeyEvent -> Boolean
;; GIVEN: a KeyEvent
;; RETURNS: true iff the KeyEvent represents a pause instruction
(define (is-pause-key-event? ev)
  (key=? ev " "))   
;; examples KeyEvents for testing
(define pause-key-event " ")
(define non-pause-key-event "q")  

(simulation 1/23)