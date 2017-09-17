;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
(check-location "01" "q2.rkt")

(provide furlongs-to-barleycorns)

;; DATA DEFINITIONS:
;; A Length is represented as a NonNegReal in furlongs
;; INTERP: a length of a country
;; A Barleycorns is represented as NonNegReal
;; INTERP: the corresponding numbers of barleycorns
;; in that length.

;; furlongs-to-barleycorns: Length -> Barleycorns
;; GIVEN: the length of a country which has not converted
;; to the metric system
;; RETURNS: the correspongding numbers of barleycorns
;; in given length.
;; EXAMPLES:
;; (furlongs-to-barleycorns 10) => 237600
;; (furlongs-to-barleycorns 3.5) => 83160
;;  (furlongs-to-barleycorns 6.9999) => 20789703/125

;; DESIGN STRATEGY: Transcribe Formula

(define (furlongs-to-barleycorns l)
  (* l 10 4 16.5 12 3))

;; TESTS
(begin-for-test
  (check-equal? (furlongs-to-barleycorns 10) 237600)
  (check-equal? (furlongs-to-barleycorns 3.5) 83160)
  (check-equal? (furlongs-to-barleycorns 6.9999) 20789703/125)
  )