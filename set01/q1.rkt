;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "01" "q1.rkt")

(provide pyramid-volume)

;; DATA DEFINITIONS:

;; A Lenth is represented as NonNegReal in m.
;; A Height is represented as NonNegReal in m.
;; A Volume is represented as NonNegReal in m^3.

;; pyramid-volume: Lenth Height -> Volume
;; GIVEN: the side length of the pyramid square bottom
;;        and the height of the pyramid.
;; RETURNS: the volume of the pyramid.
;; EXAMPLES:
;; (pyramid-volume 10.1 5.4) => 183.618
;; (pyramid-volume 0 5) => 0
;; (pyramid-volume 1 2) => 2/3

;; DESIGN STRATEGY: Transcribe Formula

(define (pyramid-volume x h)
  {* 1/3 (* x x) h})

;; TESTS
(begin-for-test
  (check-equal? (pyramid-volume 10.1 5.4) 183.618)
  (check-equal? (pyramid-volume 0 5) 0)
  (check-equal? (pyramid-volume 1 2) 2/3)
  )
