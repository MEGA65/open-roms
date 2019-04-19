				; Function defined on pp272-273 of C64 Programmers Reference Guide
	;; Compute's Mapping the 64, p228
	;;  Reads a byte of input, unless from keyboard.
	;; If from keyboard, then it gets a whole line of input, and returns the first char.
	;; Repeated calls after that read out the successive bytes of the line of input.
chrin:
	;; XXX - Not yet implemented, so infinite loop for now
	inc $d020
	jmp chrin
	
	lda #$00
	clc
	rts
