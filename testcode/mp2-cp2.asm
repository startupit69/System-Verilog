ORIGIN 0
SEGMENT 0 CODE:
	LDR R1, R0, l1p
	LDR R2, R0, l2p
	LDR R3, R0, l3p
	LDR R4, R1, 0 ; cache miss, loads line1
	LDR R5, R2, 0 ; cache miss, loads line2
	LDR R6, R1, 0 ; cache hit,  sets line2 as LRU, hits line1	
	LDR R7, R3, 0 ; cache miss, evicts line2, loads line3
	LDR R4, R1, 0 ; cache hit,  sets line3 as LRU
	;; one block
	LDR R4, R0, GOOD ; Load GOOD
	STR R4, R1, X1 	; X1 <-- R1
	LDR R5, R2, Y 	; R5 <-- 2222
	LDR R6, R3, Z 	; R6 <-- 3333 
	LDR R5, R1, X1 	; R5 <-- GOOD
	LDR R1, R3, 0 ; cache hit,  sets line1 as LRU
	LDR R2, R2, 0 ; cache miss, evicts line1, loads line2
inf:
	BRnzp inf

l1p:	DATA2 line1
l2p:	DATA2 line2
l3p:	DATA2 line3
GOOD: 	DATA2 4x600D
BAD: 	DATA2 4xBAAD
DEED: 	DATA2 4xDEED
CAFE: 	DATA2 4xCAFE


SEGMENT 128 line1:
X:	DATA2 4x1111
X1: 	DATA2 4x0000
NOP
NOP
NOP
NOP
NOP
NOP


SEGMENT 128 line2:
Y:	DATA2 4x2222
NOP
NOP
NOP
NOP
NOP
NOP
NOP

SEGMENT 128 line3:
Z:	DATA2 4x3333
NOP
NOP
NOP
NOP
NOP
NOP
NOP


