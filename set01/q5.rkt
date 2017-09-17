;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q5) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "01" "q5.rkt")

(provide years-to-test)

;; DATA DEFINITIONS
;; A Speed is represented as NonNegInt in FLOPS/s
;; which means the number of floating point operations per second.
;; A Years is represented as NonNegReal
;; indicates the number of 365-day years

;; CONSTANTS
;; A ADDTIONS is represented as a Constant
;; INTERP:
;; The numbers of addtions need to test when
;; testing the double prision addtion operation of Java double type
;; (i.e. 2^128)
(define ADDTIONS (expt 2 128))

;; years-to-test: Speed -> Years
;; GIVEN: the speed of a microprocessor.
;; RETURNS: the years the microprocessor would take to test
;; the double prision addition operation involving 2^128 additions(i.e. Java double type).
;; EXAMPLES:
;; (years-to-test (expt 2 128)) => 1/31536000
;; (years-to-test (expt 2 100)) => 8.51203247
;; (years-to-test (expt 2 93)) => 1089.54015626

;; DATA STRATEGY: Transcribe Formula and combine simpler fuctions
(define (years-to-test speed)
  (seconds-to-years (/ ADDTIONS speed)))

(begin-for-test
  (check-= (years-to-test (expt 2 128)) 1/31536000 0.00000001)
  (check-= (years-to-test (expt 2 100)) 8.51203247 0.00000001)
  (check-= (years-to-test (expt 2 93)) 1089.54015626 0.00000001)
  (check-= (years-to-test (expt 2 88)) 34865.285000507 0.00000001))

;; seconds-to-years: PosReal -> PosReal
;; GIVEN: Seconds needed to be converted to years.
;; RETURNS: the corresponding years of seconds.
;; EXAMPLES:
;; (seconds-to-years 31536000) => 1
;; (seconds-to-years 43242344) => 5405293/3942000
;; (seconds-to-years 60) => 1/525600
(define (seconds-to-years s)
  (/ s 60 60 24 365))

;; TESTS
(begin-for-test
  (check-equal? (seconds-to-years 31536000) 1)
  (check-equal? (seconds-to-years 60) 1/525600)
  (check-equal? (seconds-to-years 43242344) 5405293/3942000)
  (check-equal? (seconds-to-years 2000) 1/15768)
  )