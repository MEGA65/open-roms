
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 277/278
;; - [CM64] Compute's Mapping the Commodore 64 - page 228
;;
;; CPU registers that has to be preserved (see [RG64]): .Y
;;


	;;  Reads a byte of input, unless from keyboard.
	;; If from keyboard, then it gets a whole line of input, and returns the first char.
	;; Repeated calls after that read out the successive bytes of the line of input.
chrin:
	;; Save X
	txa
	pha

chrin_repeat:	
	;; Do we have a line of input we are currently returning?
	;; If so, return the next byte, and clear the flag when we reach the end.

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
	pla
	tax
	clc
	lda #$0d
	rts

not_end_of_input:
	;; Return next byte of waiting input and advance index
	tay
	pla
	tax
	lda (start_of_keyboard_input),y
	jsr screen_code_to_petscii
	inc keyboard_input_ready
	clc
	rts
	

read_from_keyboard:	

	jsr enable_cursor
	
	;; Wait for a key
	lda keys_in_key_buffer
	beq chrin_repeat

	lda keyboard_buffer
	cmp #$0d
	bne not_enter

	jsr disable_cursor
	
	jsr pop_keyboard_buffer

	jsr hide_cursor_if_visible
	
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
	bmi empty_line
	lda (current_screen_line_ptr),y
	cmp #$20
	beq -
	iny
	sty end_of_input_line
	lda #$01
	sta keyboard_input_ready
	;; Return first char of line
	ldy #$00
	pla
	tax
	lda (start_of_keyboard_input),y
	jsr screen_code_to_petscii
	clc
	rts

empty_line:
	;; For an empty line, just return the carriage return
	;; (and don't forget to actually print the carriage return, so that
	;; the cursor advances and screen scrolls as required)
	pla
	tax
	clc
	lda #$0d
	rts
	
not_enter:	
	;; Print character
	lda keyboard_buffer
	jsr chrout

	jsr pop_keyboard_buffer

	;; Keep looking for input from keyboard until carriage return
	jmp chrin_repeat

pop_keyboard_buffer:	
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

	rts
	
screen_code_to_petscii:
	cmp #$1b
	bcs not_alpha

	clc
	adc #$40
	rts
	
not_alpha:
	cmp #$40
	bcs not_punctuation

	rts

not_punctuation:	
	cmp #$5b
	bcs not_shifted

	clc
	adc #$80

	rts
	
not_shifted:	

	cmp #$80
	bcs not_vendor

	;; $60-$7F -> $A0-$BF

	clc
	adc #$40
	
	rts
not_vendor:	
	
	rts
