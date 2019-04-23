; Function defined on pp272-273 of C64 Programmers Reference Guide
ioinit:

	; Set $00/$01 port mode and value
	; We want BASIC and KERNAL ROMs mapped, and datasette motor off
	; (https://www.c64-wiki.com/wiki/Zeropage)
	LDA #$2F
	STA $00
	LDA #$27
	STA $01

	;; Compute's Mapping the 64, p156
	;; We use a different colour scheme of white text on all blue
	lda #$06
	sta $D020
	sta $D021

	;; Enable CIA1 IRQ and ~50Hz timer
	;; (https://csdb.dk/forums/?roomid=11&topicid=69037)
	lda #$7f
	sta $DC0D 		; First disable all

	;; Set timer interval to ~1/60th of a second
	;; (This value was calculated by running a custom IRQ haandler on a C64
	;; with original KERNAL, and writing the values of $DC04/5 to the screen
	;; in the IRQ handler to see roughly what value the timers must be set to)
	lda #<16380
	sta $dc04
	lda #>16380
	sta $dc05

	;; Enable timer interrupt
	lda #$81
	sta $dc0d

	;; Enable timer A to run continuously
	;; (http://codebase64.org/doku.php?id=base:timerinterrupts)
	lda #$11
	sta $dc0e
	lda $dc0d
	
	rts
