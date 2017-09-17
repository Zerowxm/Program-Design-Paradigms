;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q4) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "01" "q4.rkt")

(provide flopy)

;;DATA DEFINITIONS
;; A Speed is represented as NonNegInt in FLOPS/s
;; which means the number of floating point operations that
;; a microprocessor can perform per second.


;; CONSTANTS
;; A SECONDS-YEAR is representedd as PosInteger in second
;; INTERP
;; The total seconds that a 365-days year contain.
(define SECONDS-YEAR (* 365 24 60 60))

;; flopy: Speed -> NonNegInt
;; GIVEN: the speed of a microprocessor.
;; RETURNS: the number of floating point operations it
;; can perform on one 365-day year.
;; EXAMPLES:
;;(flopy 5) => 157680000
;;(flopy 10) => 315360000
;;(flopy 1) => 31536000

;; DESIGN STRATEGY: Transcribe Formula

(define (flopy speed)
  (* speed SECONDS-YEAR))

;; TESTS
(begin-for-test
  (check-equal? (flopy 5) 157680000)
  (check-equal? (flopy 9) 283824000)
  (check-equal? (flopy 1) 31536000)
  (check-equal? (flopy 2) 63072000)
  )