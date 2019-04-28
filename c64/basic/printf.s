	;; printf()-like routine for simplifying debugging

	;; Prints the literal zero-terminated string that follows,
	;; which may also include special tokens that allow
	;; printing of hex byte and word values stored at the indicated
	;; addresses.

printf:
	;; Temporary storage is between end of screen at $0400
	;; and the sprite pointers at $7f8
	sta $7f0
	stx $7f1
	sty $7f2
	php
	pla
	sta $7f3

	;; Set up read routine
	lda #$ad 		; LDA $nnnn
	sta $7f4
	lda #$60
	sta $7f7		; RTS
	
	;; Get PC of caller from the stack, so that
	;; we can parse through it
	pla
	clc
	adc #$01
	sta $7f5
	pla
	adc #$00
	sta $7f6

printf_loop:
	jsr $7f4
	cmp #$00
	bne printf_continues
	;; Put return address on stack and restore
	;; registers
	lda $7f6
	pha
	lda $7f5
	pha
	lda $7f3
	pha
	lda $7f0
	ldx $7f1
	ldy $7f2
	plp
	rts

printf_continues:
	;; Print character
	jsr $ffd2

printf_nextchar:
	;; Advance pointer to next character
	inc $7f5
	bne +
	inc $7f6
*
	jmp printf_loop
