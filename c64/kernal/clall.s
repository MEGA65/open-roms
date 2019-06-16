
clall:

	;; Implemented according to 'C64 Programmer's Reference Guide', page 281
	;; Not entirely sure if it just sets LDTND to 0 or actually calls CLOSE,
	;; but calling CLOSE for all open channels seems to be the safest

	ldy LDTND
	beq +
	dey
	lda LAT, y
	jsr close
	jmp clall
*
	;; 'C64 Programmers Reference Guide', page 281, claims it calls CLRCHN too
	jmp clrchn
