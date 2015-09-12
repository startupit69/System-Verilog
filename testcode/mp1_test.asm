ORIGIN 0
SEGMENT
CodeSegment:
; initialize registers
	AND R0, R0, 0
	AND R1, R0, 0
	AND R2, R0, 0
	AND R3, R0, 0
	AND R4, R0, 0
	AND R5, R0, 0
	AND R6, R0, 0
	AND R7, R0, 0

; testing jmp
	LEA R2, TEST_JMP
	JMP R2
	LDR R1, R0, BAD	;don't want this to load


TEST_JMP: 
	LEA R0, DataSegment 	; need for addressing
	LDR R3, R0, TMP_VAL 	; check ldr works
	JSR TEST_JSR			; testing jsr
	RSHFL R1, R1, 1 		; R1 <= 600d >> 1 = 
	LSHF R5, R1, 1 		; R5 <= 600c
	LEA R6, TEST_JSRR 		; testing jssr
	JSRR R6 				; calling TEST_JSSR

	BRnzp HALT

TEST_JSR:
	;; TEST_JSR ALSO TESTS LDR AND STR
	;; ALSO TESTS STI AND LDI
	LDR R2, R0, GOOD		; see if we made it to jsr
	LEA R3, TAR1			; R3 has address where we want to store
	STR R2, R0, TAR1 		; TAR1 should be filled with GOOD
	LDR R3, R0, TAR1		; R3 should have GOOD
	LEA R1, TAR3 			; R1 holds address of tar3
	STR R1, R0, TAR1		; [TAR1] = addr of TAR3 
	LDR R2, R0, TAR1 		; R2 == R1 should
	STI R3, R0, TAR1 		; [TAR3] = GOOD we want this
	ADD R5, R5, R3			; see whats in r3
	LDR R1, R0, TAR3 		; R1 <= GOOD 
	LEA R5, TAR3 			; R5 <= addr of TAR3
	LDI R2, R0, TAR1		; R2 <= GOOD
	RET

TEST_JSRR:
	;; This function validates stb/ldb
	LDB R4, R0, LEET 	; R4 should have 0037
	LEA R1, DataSegment ; for high byte offset
	ADD R1, R1, 1 		; high byte offset
 	LDB R5, R1, LEET 	; R5 should have 0013

 	LEA R3, TAR3
 	AND R6, R6, 0 		; clear R6
 	STR R6, R0, TAR3 	; TAR3 = 0
 	LDR R4, R0, AB 		; R4 = AB
 	LDR R2, R0, CD 		; R2 = CD

 	STB R4, R0, TAR3 	; TAR3 <= x00AB
 	LDR R6, R0, TAR3 	; R6 <= x0037 check if it works
 	STB R2, R1, TAR3 	; TAR3 = xCDAB
 	LDR R5, R0, TAR3 	; R6 = 1337 should work


	RET

HALT:
	BRnzp HALT

SEGMENT DataSegment:   
TMP_VAL: DATA2 4x0002   ; 54
BAD: DATA2 4x0bad    ; 56
GOOD: DATA2 4x600D   ; 58
LEET: DATA2 4x1337 	; 60
AB: DATA2 4x00AB
CD: DATA2 4x00CD
TAR1: DATA2 0
TAR2: DATA2 0
TAR3: DATA2 0