.ORIG x3000
	

	;; REGISTER TABLE 
	;; R1 - Factorial result
	;; R2 - Holds negative one (-1)
	;; R3 - Counter for MULT loop
	;; R4 - Counter for LOOP loop (outer loop)
	;; R5 - Running product
	;; R6 - Flag to signal factorial is complete

	LD R1,  FIVE 	;; R1 <= n
	LD R2,  NEGONE	;; R2 <= -1
	ADD R3, R1, R2		; R3 <= n - 1	

OUTLOOP
	ADD R4, R0, R3;		; R4 <= Outer loop counter			
INLOOP
	ADD R5, R5, R1 		; R5 <= R5 + running sum
	ADD R4, R4, R2 		; decrement mult counter
	BRp INLOOP		; branch to OUTLOOP
	
	ADD R1, R0, R5 		; R1 <= product
	LD R5, ZERO		; Clear product 
	ADD R3, R3, R2 		; Decrement factorial counter
	BRp OUTLOOP		; Branch if not done
	LD R6, COMPLETE 	;; load complete flag into R6	

	HALT

FIVE .FILL x0005 	; Factorial we are computing 5!
NEGONE .FILL  xFFFF 	; Negative one to decrement the counter
ZERO .FILL x0000	; Zero to clear values
COMPLETE .FILL xAAAA 	; Flag value to signal it is complete


.END











