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
	
	;; Try to load an IEC file
	lda #0			; use supplied load address, not the one from the file
	sta current_secondary_address
	lda #$00 		; LOAD not verify
	ldx #<$0801		; LOAD address = $0801
	ldy #>$0801

	;; Set filename and length
	lda #$24
	sta $0400
	lda #$01
	sta current_filename_length
	lda #<$0400
	sta current_filename_ptr+0
	lda #>$0401
	sta current_filename_ptr+1
	
	jsr $ffd5
	bcc +

	;; A = KERNAL error code, which also almost match
	;; basic ERROR codes, so we can just copy the
	;; error code to X, decrement, and handle normally
	tax
	dex
	jmp do_basic_error
	
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

	;; Try to keep executing
	jmp basic_execute_statement


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
