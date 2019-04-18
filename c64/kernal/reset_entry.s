; Resources describing the C64 reset sequence:
; https://www.c64-wiki.com/wiki/Reset_(Process)


reset_entry:
	; The GPL program at https://github.com/Klaus2m5/6502_65C02_functional_tests/blob/master/6502_functional_test.a65
	; uses the following initial reset sequence
	cld
	ldx #$ff
	txs
	sei


	; The following routine is based on reading the public KERNAL jumptable routine
	; list, and making unimaginative assumptions about what should be done on reset.
	; Initialising IO is obviously required. 
	jsr ioinit
	; Setting up the screen is obviously required
	jsr ramtas
	; Resetting IO vectors is obviously required, if we want interrupts to run
	jsr restor

	; What do we do when finished?  A C64 jumps into the BASIC ROM
	jmp ($a000)
