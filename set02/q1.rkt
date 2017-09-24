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
;; token: String(any string will do)     strings with an assigned and thus identified meaning of the input of a lexer
;; input: String(any string will do)     user input to a lexer
;; more information about lexer if you want to know, visit
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
;;; GIVEN: two strings s1 and s2(any string will do)
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
;;; GIVEN: an arbitrary string(any string will do)
;;; RETURNS: a Lexer lex whose token string is empty
;;;     and whose input string is the given string
;;; STRATEGY: Use constructor template for Lexer
(define (initial-lexer input)
  (make-lexer "" input))

(begin-for-test
  (check-equal? (lexer-token (make-lexer "abc" "1234")) "abc")
  (check-equal? (lexer-input (make-lexer "abc" "1234")) "1234")
  (check-equal? (initial-lexer "asb") (make-lexer "" "asb"))
  (check-equal? (initial-lexer "12312") (make-lexer "" "12312"))
  (check-equal? (initial-lexer "!@#$") (make-lexer "" "!@#$"))
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
;;; STRATEGY: combine simpler functions

(define (lexer-stuck? l)
  ( if (non-empty-input? l)
       (not (begin-with-letter-or-digit? (lexer-input l)))
       true ))
;; test data
(define lexer-input-empty (make-lexer "eqw" ""))
(define lexer-input-begin-letter (make-lexer "eff" "h@@@"))
(define lexer-input-begin-digit (make-lexer "" "2dd"))
;; TESTS
(begin-for-test
  (check-equal? (lexer-stuck? (make-lexer "abc" "1234")) false)
  (check-equal? (lexer-stuck? (make-lexer "abc" "+1234")) true)
  (check-equal? (lexer-stuck? (make-lexer "abc" "%$%f  sd#")) true)
  (check-equal? (lexer-stuck?  lexer-input-empty) true)
  (check-equal? (lexer-stuck?  lexer-input-begin-letter) false)
  (check-equal? (lexer-stuck?  lexer-input-begin-digit) false)
  )

;; non-empty-input?: Lexer => Boolen
;; RETURNS: true iff the input of the given lexer is not empty
;; STRATEGY: Use obserber template for Lexer
;; EXAMPLES: 
;; (non-empty-input? (make-lexer "abc" "1234")) => false
;; (non-empty-input? (make-lexer "abc" "")) => true
(define (non-empty-input? l)
  (< 0 (string-length (lexer-input l))))
(begin-for-test
  (check-equal? (non-empty-input? (make-lexer "abc" "1234")) true)
  (check-equal? (non-empty-input? (make-lexer "abc" "")) false)
  )

;; begin-with-letter-or-digit?: String -> Boolen
;; GIVEN: String(any string will do)
;; RETURNS: true iff the first char of the given string is English letter or digit
;; STRATEGY: combine simpler functions
;; EXAMPLES:
;; (begin-with-letter-or-digit? "dass") => true
;; (begi-withn-letter-or-digit? "1das") => true
;; (begin-with-letter-or-digit? "!@") => false
(define (begin-with-letter-or-digit? str)
  (or (letter? str)
      (digit? str)))
(begin-for-test
  (check-equal? (begin-with-letter-or-digit? "dass") true)
  (check-equal? (begin-with-letter-or-digit? "1das") true)
  (check-equal? (begin-with-letter-or-digit? "!@") false)
  )

;; letter?: String->Boolen
;; RETURNS: true iff the first char of the given string(any string will do)
;;          is English letter.
;; STRATEGY: if the first char of string is English letter return true
;; EXAMPLES:
;; (letter? "dass") => true
;; (letter? "1das") => false
(define (letter? str)
  (string-alphabetic? (first-char str) ))

;; first-char: String -> String
;; RETURNS: the first char of the given string(any string will do).
(define (first-char str)
  (string-ith str 0))

;; digit?: String -> Boolen
;; RETURNS: true iff the first char of the given string is digit.
;; STRATEGY: if the first char of string is digit return true
;; EXAMPLES:
;; (digit? "dass") => false
;; (digit? "1das") => true
(define (digit? str)
  (string-numeric?(first-char str)))
          
;;; lexer-shift : Lexer -> Lexer
;;; GIVEN: a Lexer
;;; RETURNS:
;;;   If the given Lexer is stuck, returns the given Lexer.
;;;   If the given Lexer is not stuck,then the token string
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
;;; STRATEGY: cons on the lexer is stuck or not && combine simpler functions
(define (lexer-shift l)
  (if (lexer-stuck? l)
      l
      (make-lexer (new-token l) (new-input l))))

;; new-token: Lexer -> String
;; RETURNS: the token string consists of the characters of the given
;;          Lexer's token string followed by the first character
;;          of that Lexer's input string
;; STRATEGY: combine simpler functions
;; EXAMPLES:
;; (new-token (make-lexer "abc" "1234")) => "abc1"
(define (new-token l)
  (string-append (lexer-token l)
                 (first-char (lexer-input l))))

;; new-input: Lexer -> String
;; RETURNS: the input string consists of all but the first character
;;          of the given Lexer's input string
;; STRATEGY: use template of Lexer
;; EXAMPLES:
;; (new-input "1234") => "234"
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

;; create-empty-token: String -> Lexer
;; RETURNS: a new lexer with the given input string(any string will do) and empty token
;; STRATEGY: Use constructor template for Lexer
(define (create-empty-token input)
  (make-lexer "" input))

;;TESTS
(begin-for-test
  (check-equal? (lexer-reset (make-lexer "abc" "")) (make-lexer "" ""))
  (check-equal? (lexer-reset (make-lexer "abc" "+1234")) (make-lexer "" "1234"))
  (check-equal? (lexer-reset (make-lexer "" "@+1234")) (make-lexer "" "+1234"))
  (check-equal? (lexer-reset (make-lexer "nothing" "1234")) (make-lexer "" "234"))
  )