ORIGIN 4x0000
SEGMENT CodeSegment:
	
	;; REGISTER TABLE 
	;; R1 - Factorial result
	;; R2 - Holds negative one (-1)
	;; R3 - Counter for OUT loop
	;; R4 - Counter for IN loop
	;; R5 - Running product
	;; R6 - Flag to signal factorial is complete

	LDR R1, R0, FIVE 	; R1 <= n
	LDR R2, R0, NEGONE	; R2 <= -1
	ADD R3, R1, R2		; R3 <= n - 1	

OUTLOOP:
	ADD R4, R0, R3;		; R4 <= Outer loop counter			
INLOOP:
	ADD R5, R5, R1 		; R5 <= R5 + running sum
	ADD R4, R4, R2 		; decrement mult counter
	BRp INLOOP		; branch to OUTLOOP
	
	ADD R1, R0, R5 		; R1 <= product
	LDR R5, R0, ZERO	; Clear product 
	ADD R3, R3, R2 		; Decrement factorial counter
	BRp OUTLOOP		; Branch if not done
	LDR R6, R0, COMPLETE 	; load complete flag into R6	

HALT:			; Infinite loop to keep processor
	BRnzp HALT 	; from executing data below


FIVE: DATA2 4x0005 	; Factorial we are computing 5!
NEGONE: DATA2 4xFFFF 	; Negative one to decrement the counter
ZERO: DATA2 4x0000	; Zero to clear values
COMPLETE: DATA2 4xAAAA 	; Flag value to signal it is complete












