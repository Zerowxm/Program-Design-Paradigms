;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "01" "q3.rkt")

(provide kelvin-to-fahrenheit)

;; Data definitions:
;; A KelvinTemp is represented as NonNegReal in Kelvin.
;; A FahrenTemp is represented as a Real.

;; kelvin-to-fahrenheit: KelvinTemp -> FahrenTemp
;; GIVEN: a temperature in Kelvin.
;; RETURNS: the equivalent temperature in fahrenheit.
;; EXAMPLES:
;; (kelvin-to-fahrenheit 300) => 88.33
;; (kelvin-to-fahrenheit 0) => -459.67
;; (kelvin-to-fahrenheit 10) => -441.67

;;DESIGN STRATEGY: Transcribe Formula

(define (kelvin-to-fahrenheit k)
  (- (* 9/5 k) 459.67))

;;TESTS
(begin-for-test
  (check-equal? (kelvin-to-fahrenheit 300) 80.33)
  (check-equal? (kelvin-to-fahrenheit 0) -459.67)
  (check-equal? (kelvin-to-fahrenheit 10) -441.67)
  (check-equal? (kelvin-to-fahrenheit 55) -360.67)
  )