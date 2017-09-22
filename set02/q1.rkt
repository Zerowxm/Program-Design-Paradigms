;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname q1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require rackunit)
(require "extras.rkt")
      
(provide
 make-lexer
 lexer-token
 lexer-input
 initial-lexer
 lexer-stuck?
 lexer-shift
 lexer-reset)



(check-location "02" "q1.rkt")

;; A Lexer is a stuct (make-lexer token input) with fields 
;; token: String    strings with an assigned and thus identified meaning of the input of a lexer
;; input: String    user input to a lexer
;; more information about lexer if you want to know visit
;; https://en.wikipedia.org/wiki/Lexical_analysis

(define-struct lexer (token input))
;; CONSTRUCTOR TEMPLATE:
;; (make-lexer String String)

;; OBSERVER TEMPLATE:
;; lexer-fn : Lexer -> ??
(define (lexer-fn l)
  (...
   (lexer-input l)
   (lexer-token l)
   (lexer-stuck? l)
   (lexer-shift l)
   (lexer-reset l)))



;;; make-lexer : String String -> Lexer
          ;;; GIVEN: two strings s1 and s2
          ;;; RETURNS: a Lexer whose token string is s1
          ;;;     and whose input string is s2
          ;;;
          ;;; lexer-token : Lexer -> String
          ;;; GIVEN: a Lexer
          ;;; RETURNS: its token string
          ;;; EXAMPLE:
          ;;;     (lexer-token (make-lexer "abc" "1234")) =>  "abc"
          ;;;
          ;;; lexer-input : Lexer -> String
          ;;; GIVEN: a Lexer
          ;;; RETURNS: its input string
          ;;; EXAMPLE:
          ;;;     (lexer-input (make-lexer "abc" "1234")) =>  "1234"
          ;;;
          ;;; initial-lexer : String -> Lexer
          ;;; GIVEN: an arbitrary string
          ;;; RETURNS: a Lexer lex whose token string is empty
          ;;;     and whose input string is the given string
          ;;;
(define (initial-lexer s)
  (s))
          ;;; lexer-stuck? : Lexer -> Boolean
          ;;; GIVEN: a Lexer
          ;;; RETURNS: false if and only if the given Lexer's input string
          ;;;     is non-empty and begins with an English letter or digit;
          ;;;     otherwise returns true.
          ;;; EXAMPLES:
          ;;;     (lexer-stuck? (make-lexer "abc" "1234"))  =>  false
          ;;;     (lexer-stuck? (make-lexer "abc" "+1234"))  =>  true
          ;;;     (lexer-stuck? (make-lexer "abc" ""))  =>  true
(define lexer-empty (make-lexer "abc" ""))
(define lexer-letter (make-lexer "abc" "h@@@"))
(define lexer-digit (make-lexer "abc" "2dd"))
(define (lexer-stuck? l)
  ( if (non-empty-input? l)
       (not (begin-letter-or-digit? (lexer-input l)))
       true ))

(define (non-empty-input? l)
  (< 0 (string-length (lexer-input l))))

(define (begin-letter-or-digit? str)
  (or (letter? str)
      (digit? str)))

(define (letter? str)
  (char-alphabetic? (first-char str) ))

(define (first-char str)
  (string-ref str 0))



(define (digit? str)
  (number? (string->number (substring str 0 1))))
  
(define test (lexer-input lexer-digit))
  
(begin-for-test
  (check-equal? (lexer-stuck? (make-lexer "abc" "1234")) false)
  (check-equal? (lexer-stuck? (make-lexer "abc" "+1234")) true)
  (check-equal? (lexer-stuck? (make-lexer "abc" "")) true)
  (check-equal? (lexer-stuck?  lexer-empty) true)
  (check-equal? (lexer-stuck?  lexer-letter) false)
  (check-equal? (lexer-stuck?  lexer-digit) false)
  )
 
          ;;;
          ;;; lexer-shift : Lexer -> Lexer
          ;;; GIVEN: a Lexer
          ;;; RETURNS:
          ;;;   If the given Lexer is stuck, returns the given Lexer.
          ;;;   If the given Lexer is not stuck, then the token string
          ;;;       of the result consists of the characters of the given
          ;;;       Lexer's token string followed by the first character
          ;;;       of that Lexer's input string, and the input string
          ;;;       of the result consists of all but the first character
          ;;;       of the given Lexer's input string.
          ;;; EXAMPLES:
          ;;;     (lexer-shift (make-lexer "abc" ""))
          ;;;         =>  (make-lexer "abc" "")
          ;;;     (lexer-shift (make-lexer "abc" "+1234"))
          ;;;         =>  (make-lexer "abc" "+1234")
          ;;;     (lexer-shift (make-lexer "abc" "1234"))
          ;;;         =>  (make-lexer "abc1" "234")
          ;;;
(define (lexer-shift l)
  ( l))
          ;;; lexer-reset : Lexer -> Lexer
          ;;; GIVEN: a Lexer
          ;;; RETURNS: a Lexer whose token string is empty and whose
          ;;;     input string is empty if the given Lexer's input string
          ;;;     is empty and otherwise consists of all but the first
          ;;;     character of the given Lexer's input string.
          ;;; EXAMPLES:
          ;;;     (lexer-reset (make-lexer "abc" ""))
          ;;;         =>  (make-lexer "" "")
          ;;;     (lexer-reset (make-lexer "abc" "+1234"))
          ;;;         =>  (make-lexer "" "1234")
(define (lexer-reset l)
  (l))