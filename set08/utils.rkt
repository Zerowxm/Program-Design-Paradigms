;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname utils) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")

(provide
 remove-duplicates)

; remove-duplicates: XList -> XList
; Given: a list of X which is any type
; Returns: a list like the given one except without repititions
; Examples: (remove-duplicates (list "x" "v" "x" "v"))
; => (list "x" "v") or (list "v" "x")
; Strategy: use HOF filter on XList followed by folder
(define (remove-duplicates st)
  ; String XList -> XList
  ; Returns: cons the given X to a list like the given XList except without X
  (foldr (lambda (x y) (cons x (filter 
                                ; X -> Boolean
                                ; Returns: true if the given X is equal to x
                                (lambda (z) (not (equal? x z))) y))) empty st))
; Test
(begin-for-test
  (check-equal? (remove-duplicates (list "x" "v" "x" "v")) (list "x" "v")
                "it should return (list \"x\" \"v\")"))
