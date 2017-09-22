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
(define (initial-lexer input)
  (make-lexer "" input))
(define letter "asb")
(define symbol "!@#$")
(define number "12312")

(begin-for-test
  (check-equal? (lexer-token (make-lexer "abc" "1234")) "abc")
  (check-equal? (lexer-input (make-lexer "abc" "1234")) "1234")
  (check-equal? (initial-lexer letter) (make-lexer "" letter))
  (check-equal? (initial-lexer number) (make-lexer "" number))
  (check-equal? (initial-lexer symbol) (make-lexer "" symbol))
  )
;;; lexer-stuck? : Lexer -> Boolean
;;; GIVEN: a Lexer
;;; RETURNS: false if and only if the given Lexer's input string
;;;     is non-empty and begins with an English letter or digit;
;;;     otherwise returns true.
;;; EXAMPLES:
;;;     (lexer-stuck? (make-lexer "abc" "1234"))  =>  false
;;;     (lexer-stuck? (make-lexer "abc" "+1234"))  =>  true
;;;     (lexer-stuck? (make-lexer "abc" ""))  =>  true

;; test data
(define lexer-empty (make-lexer "abc" ""))
(define lexer-letter (make-lexer "abc" "h@@@"))
(define lexer-digit (make-lexer "abc" "2dd"))

(define (lexer-stuck? l)
  ( if (non-empty-input? l)
       (not (begin-letter-or-digit? (lexer-input l)))
       true ))

;; non-empty-input?: Lexer => Boolen
;; RETURNS: true iff the input of given lexer is not empty
(define (non-empty-input? l)
  (< 0 (string-length (lexer-input l))))

;; begin-letter-or-digit?: String -> Boolen
;; GIVEN: String any string will do
;; RETURNS: true iff the first char of the given string is English letter or digit
;; STRATEGY: combile simpler functions
(define (begin-letter-or-digit? str)
  (or (letter? str)
      (digit? str)))
;; letter?: String->Boolen
;; RETURNS: true iff the first char of string is English letter.
(define (letter? str)
  (char-alphabetic? (first-char str) ))

;; first-char: String -> Char
;; RETURNS: the first char of the given string.
(define (first-char str)
  (string-ref str 0))

;; digit?: String -> Boolen
;; RETURNS: true iff the first char is digit.
(define (digit? str)
  (number? (string->number (substring str 0 1))))
  
;; TESTS
(begin-for-test
  (check-equal? (lexer-stuck? (make-lexer "abc" "1234")) false)
  (check-equal? (lexer-stuck? (make-lexer "abc" "+1234")) true)
  (check-equal? (lexer-stuck? (make-lexer "abc" "")) true)
  (check-equal? (lexer-stuck?  lexer-empty) true)
  (check-equal? (lexer-stuck?  lexer-letter) false)
  (check-equal? (lexer-stuck?  lexer-digit) false)
  )
 
          
;;; lexer-shift : Lexer -> Lexer
;;; GIVEN: a Lexer
;;; RETURNS:
;;;   If the given Lexer is stuck, returns the given Lexer.
;;;   If the given Lexer is not stuck, A(then the token string
;;;       of the result consists of the characters of the given
;;;       Lexer's token string followed by the first character
;;;       of that Lexer's input string), and B(the input string
;;;       of the result consists of all but the first character
;;;       of the given Lexer's input string).
;;; EXAMPLES:
;;;     (lexer-shift (make-lexer "abc" ""))
;;;         =>  (make-lexer "abc" "")
;;;     (lexer-shift (make-lexer "abc" "+1234"))
;;;         =>  (make-lexer "abc" "+1234")
;;;     (lexer-shift (make-lexer "abc" "1234"))
;;;         =>  (make-lexer "abc1" "234")
;;; STRATEGY: cons on the lexer is stuck or not && combine simpler functions
(define (lexer-shift l)
  (if (lexer-stuck? l)
      l
      (shift l)))
;; shift: Lexer -> Lexer
;; RETURNS: A and B (shown above)
(define (shift l)
  (make-lexer (new-token l) (new-input l)))

;; new-token: Lexer->Lexer
;; RETURNS: A (shown above)
(define (new-token l)
  (string-append (lexer-token l)
                (substring (lexer-input l) 0 1)))

;; new-input: Lexer->Lexer
;; RETURNS: B (shown above)
(define (new-input l)
  (substring (lexer-input l) 1))

;; TESTS
(begin-for-test
  (check-equal? (lexer-shift (make-lexer "abc" ""))  (make-lexer "abc" ""))
  (check-equal? (lexer-shift (make-lexer "abc" "dfg"))  (make-lexer "abcd" "fg"))
  (check-equal? (lexer-shift (make-lexer "abc" "+1234")) (make-lexer "abc" "+1234"))
  (check-equal? (lexer-shift (make-lexer "abc" "1234")) (make-lexer "abc1" "234"))
  (check-equal? (lexer-shift (make-lexer "abc" "1"))  (make-lexer "abc1" ""))
  )
  
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
;;; STRATEGY: combine simpler functions && cons on input of the lexer
(define (lexer-reset l)
  (if (non-empty-input? l)
      (create-empty-token (new-input l))
      (create-empty-token "")))

;; create-empty-token: String->Lexer
;; RETURNS: new lexer with the given input and empty token
(define (create-empty-token input)
  (make-lexer "" input))

;;TESTS
(begin-for-test
  (check-equal? (lexer-reset (make-lexer "abc" "")) (make-lexer "" ""))
  (check-equal? (lexer-reset (make-lexer "abc" "+1234")) (make-lexer "" "1234"))
  (check-equal? (lexer-reset (make-lexer "" "@+1234")) (make-lexer "" "+1234"))
  (check-equal? (lexer-reset (make-lexer "nothing" "1234")) (make-lexer "" "234"))
  )