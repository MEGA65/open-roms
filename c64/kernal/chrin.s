				; Function defined on pp272-273 of C64 Programmers Reference Guide
	;; Compute's Mapping the 64, p228
	;;  Reads a byte of input, unless from keyboard.
	;; If from keyboard, then it gets a whole line of input, and returns the first char.
	;; Repeated calls after that read out the successive bytes of the line of input.
chrin:
	;; XXX - Not yet implemented, so infinite loop for now
	lda keys_in_key_buffer
	beq chrin

	;; Print character
	lda keyboard_buffer
	jsr chrout

	;; Pop key out of keyboard buffer
	;; Disable interrupts while reading from keyboard buffer
	;; so that no race conditions can occur
	sei
	ldx #$00
	ldy #$01
*	lda keyboard_buffer,y
	sta keyboard_buffer,x
	inx
	iny
	cpy keys_in_key_buffer
	bne -
	dec keys_in_key_buffer
	cli
	
	lda #$00
	clc
	rts
