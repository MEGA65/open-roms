				; Function defined on pp272-273 of C64 Programmers Reference Guide
	;; Compute's Mapping the 64, p228
	;;  Reads a byte of input, unless from keyboard.
	;; If from keyboard, then it gets a whole line of input, and returns the first char.
	;; Repeated calls after that read out the successive bytes of the line of input.
chrin:

	;; Do we have a line of input we are currently returning?
	;; If so, return the next byte, and clear the flag when we reach the end.
	;; XXX - Implement

	;; Do we have a line of input waiting?
	lda keyboard_input_ready
	beq read_from_keyboard

	;; Yes, we have input waiting at (start_of_keyboard_input)+keyboard_input_ready
	;; When keyboard_input_ready = end_of_input_line, then we return a carriage return
	;; and clear the flag
	cmp end_of_input_line
	bne not_end_of_input

	;; Return carriage return and clear pending input flag
	lda #$00
	sta keyboard_input_ready
	lda #$0d
	sec
	rts

not_end_of_input:
	;; Return next byte of waiting input and advance index
	tay
	lda (start_of_keyboard_input),y
	inc keyboard_input_ready
	sec
	rts
	

read_from_keyboard:	

	;; Wait for a key
	lda keys_in_key_buffer
	beq chrin

	lda keyboard_buffer
	cmp #$0d
	bne not_enter
	
	;; It was enter.
	;; Note that we have a line of input to return, and return the first byte thereof
	;; after computing and storing its length.
	;; (Compute's Mapping the 64, p96)

	;; Set pointer to line of input
	lda current_screen_line_ptr+0
	sta start_of_keyboard_input+0
	lda current_screen_line_ptr+1
	sta start_of_keyboard_input+1

	;; Calculate length
	jsr get_current_line_logical_length
	tay
	iny
*	dey
	beq empty_line
	lda (current_screen_line_ptr),y
	cmp #$20
	bne -
	sty keyboard_input_ready
	;; Print the carriage return
	lda #$0d
	jsr chrout
	;; Return first char of line
	ldy #$00
	lda (current_screen_line_ptr),y
	inc $d020
	sec
	rts

empty_line:
	;; For an empty line, just return the carriage return
	;; (and don't forget to actually print the carriage return, so that
	;; the cursor advances and screen scrolls as required)
	lda #$0d
	jsr chrout
	lda #$0d
	sec
	rts
	
not_enter:	
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
	cpy key_buffer_size
	bne -
	dec keys_in_key_buffer
	cli
	
	lda #$00
	clc
	rts
