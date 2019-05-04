cmd_load:

	;; Parse filename
	;; (we can tell the KERNAL where it is in memory directly, since the
	;; KERNAL will be able to peek under ROMs to read it, since it will have
	;; to be able to peek under the ROMs for SAVE and VERIFY).
	;; Parse optional device #
	;; Parse optional secondary address
	
	;; XXX - C64 BASIC apparently doesn't clear variables after a LOAD in the
	;; middle of a program. For safety, we do.
	jsr basic_do_clr
	
	;; Set filename and length
	lda #$00
	sta current_filename_length

	;; Without tape support, LOAD must have a filename
	;; (This also skips any leading spaces)
	jsr basic_end_of_statement_check
	bcc +
	jmp do_MISSING_FILENAME_error
*
	jsr basic_fetch_and_consume_character
	cmp #$22
	beq +
	jmp do_SYNTAX_ERROR
*
	;; Filename starts here so set pointer
	lda basic_current_statement_ptr+0
	sta current_filename_ptr+0
	lda basic_current_statement_ptr+1
	sta current_filename_ptr+1
	
	;; Now search for end of line or closing quote
	;; so that we know the length of the filename
getting_filename:	
	jsr basic_fetch_and_consume_character
	cmp #$22
	beq got_filename
	cmp #$00
	bne +
	jsr basic_unconsume_character

	jmp got_filename
*
	inc current_filename_length
	jmp getting_filename
	
got_filename:	

	;; Try to load an IEC file
	lda #0			; use supplied load address, not the one from the file
	sta current_secondary_address
	lda #$00 		; LOAD not verify
	ldx #<$0801		; LOAD address = $0801
	ldy #>$0801

	jsr $ffd5
	bcc +

	;; A = KERNAL error code, which also almost match
	;; basic ERROR codes, so we can just copy the
	;; error code to X, decrement, and handle normally
	tax
	dex
	jmp do_LOAD_error
	
*
	;; $YYXX is the last loaded address, so store it
	stx basic_end_of_text_ptr+0
	sty basic_end_of_text_ptr+1

	;; Now relink the loaded program, as we cannot trust the line
	;; links supplied. For example, the VICE virtual drive emulation
	;; always supplies $0101 as the address of the next line.
	jsr basic_relink_program
	
	;; After LOADing, we either start the program from the beginning,
	;; or go back to the READY prompt if LOAD was called from direct mode.

	;; Reset to start of program
	lda basic_start_of_text_ptr+0
	sta basic_current_line_ptr+0
	lda basic_start_of_text_ptr+1
	sta basic_current_line_ptr+1

	;; XXX - should run program if LOAD was used in program mode
	jmp basic_main_loop


basic_relink_program:
	
	;; Start by getting pointer to the first line
	lda basic_start_of_text_ptr+0
	sta basic_current_line_ptr+0
	lda basic_start_of_text_ptr+1
	sta basic_current_line_ptr+1

basic_relink_loop:	
	;; Is the pointer to the end of the program
	ldy #1
	ldx #<basic_current_line_ptr+0
	jsr peek_under_roms
	cmp #$00
	bne +

	;; End of program
	rts
*
	;; Now search forward to find the end of the line
	;; Skip forward pointer and line number
	ldy #4
end_of_line_search:
	ldx #<basic_current_line_ptr+0
	jsr peek_under_roms
	cmp #$00
	beq +

	;; Not yet end of line
	iny
	bne end_of_line_search

	;; line too long
	jmp do_STRING_TOO_LONG_error

	*
	;; Found end of line, so update pointer

	;; First, skip over the $00 char
	iny
	
	;; Now overwrite the pointer (carefully)
	;; 
	tya
	clc
	adc basic_current_line_ptr+0
	pha
	php
	ldy #0
	ldx #<basic_current_line_ptr+0
	jsr poke_under_roms
	plp
	lda basic_current_line_ptr+1
	adc #0
	ldy #1
	jsr poke_under_roms
	sta basic_current_line_ptr+1
	pla
	sta basic_current_line_ptr+0

	

	jmp basic_relink_loop
