; Function defined on pp272-273 of C64 Programmers Reference Guide
getin:

	;; Wait for a key
	lda keys_in_key_buffer
	bne +

	;; Nothing in keyboard buffer to read
	lda #$00
	sec
	rts
	
*
	lda keyboard_buffer
	pha

	jsr pop_keyboard_buffer

	pla
	clc

	rts
