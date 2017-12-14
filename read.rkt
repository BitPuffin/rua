#lang racket

(require parser-tools/lex
				 (prefix-in : parser-tools/lex-sre)
				 parser-tools/yacc)

(define-tokens datums (symbol))

(define-empty-tokens delim (add
														sub
														mul
														div
														mod
														pow
														idiv
														band
														bor
														bxor
														bnot
														shl
														shr
														concat
														len
														eq
														lt
														le
														gt
														ge
														ass
														op
														cp
														oc
														cc
														os
														cs
														lab
														endstmt
														miv
														com
														acc
														vararg))

(define-empty-tokens keywords (and
															 break
															 do
															 else
															 elseif
															 end
															 false
															 for
															 function
															 goto
															 if
															 in
															 local
															 nil
															 not
															 or
															 repeat
															 return
															 then
															 true
															 until
															 while))

(define keyword-strings '("and"
											  	"break"
											  	"do"
											  	"else"
											  	"elseif"
											  	"end"
											  	"false"
											  	"for"
											  	"function"
											  	"goto"
											  	"if"
											  	"in"
											  	"local"
											  	"nil"
											  	"not"
											  	"or"
											  	"repeat"
											  	"return"
											  	"then"
											  	"true"
											  	"until"
											  	"while"))
(define lua-lexer
	(lexer-src-pos
	 [(:or lua-whitespace comment) (return-without-pos (lua-lexer input-port))]

	 ;; Operators / Punctuation
	 [#\+ (token-add)]
	 [#\- (token-sub)]
	 [#\* (token-mul)]
	 [#\/ (token-div)]
	 [#\% (token-mod)]
	 [#\^ (token-pow)]
	 ["//" (token-idiv)]
	 [#\& (token-band)]
	 [#\| (token-bor)]
	 [#\~ (token-bxor)]
	 ["<<" (token-shl)]
	 [">>" (token-shr)]
	 [".." (token-concat)]
	 [#\# (token-len)]
	 ["==" (token-eq)]
	 [#\< (token-lt)]
	 ["<=" (token-le)]
	 [#\> (token-gt)]
	 [">=" (token-ge)]
	 [#\= (token-ass)]
	 [#\( (token-op)]
	 [#\) (token-cp)]
	 [#\{ (token-oc)]
	 [#\} (token-cc)]
	 [#\[ (token-os)]
	 [#\] (token-cs)]
	 ["::" (token-lab)]
	 [#\; (token-endstmt)]
	 [#\: (token-miv)]
	 [#\, (token-com)]
	 [#\. (token-acc)]
	 ["..." (token-vararg)]

	 

	 [symbol (if (member lexeme keyword-strings)
							 (string->symbol lexeme)
							 (token-symbol lexeme))]
	 [(eof) (display "eof!")]))

(define-lex-abbrevs
	[lua-whitespace (:or #\newline #\return #\tab #\space #\vtab)]
	[comment (:: "--" (:* (:~ #\newline)) #\newline)]
	[symbol (:* (:or (:/ #\a #\z)) (:/ #\A #\Z))]
	)

; Temporary to test in repl
(define prt (open-input-string "a + b"))

