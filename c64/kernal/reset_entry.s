; Resources describing the C64 reset sequence:
; https://www.c64-wiki.com/wiki/Reset_(Process)


reset_entry:
	; The GPL program at https://github.com/Klaus2m5/6502_65C02_functional_tests/blob/master/6502_functional_test.a65
	; uses the following initial reset sequence
	; affirmed by c64 PRG p269
	cld
	ldx #$ff
	txs
	sei

	; C64 PRG p269
	jsr cartridge_check

	; The following routine is based on reading the public KERNAL jumptable routine
	; list, and making unimaginative assumptions about what should be done on reset.
	; Initialising IO is obviously required.  also indicated by c64 prg p269.
	jsr ioinit
	; Setting up the screen and testing ram is obviously required
	; also affirmed by p269 of c64 prg
	jsr ramtas
	; Resetting IO vectors is obviously required, if we want interrupts to run
	; also affirmed by c64 prg p269
	jsr restor

	; What do we do when finished?  A C64 jumps into the BASIC ROM
	; c64 prg p269
	jmp ($a000)
