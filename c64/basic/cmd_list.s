	;; LIST basic text.
	;; XXX - Doesn't currently support line number ranges

cmd_list:

	;; Set current line pointer to start of memory
	lda basic_start_of_text_ptr+0
	sta basic_current_line_ptr+0
	lda basic_start_of_text_ptr+1
	sta basic_current_line_ptr+1

list_loop:
	ldx #<basic_current_line_ptr
	ldy #1
	jsr peek_under_roms
	cmp #$00
	bne list_more_lines

	;; LIST terminates any running program,
	;; because it has fiddled with the current line pointer.
	;; (Confirmed by testing on a C64)
	jmp basic_main_loop

list_more_lines:
	;; Print line number
	ldy #3
	jsr peek_under_roms
	pha
	dey
	jsr peek_under_roms
	tax
	pla
	jsr print_integer
	lda #$20
	jsr $ffd2

	;; Iterate through printing out the line
	;; contents
	lda #0
	sta quote_mode_flag
	
	ldy #4
list_print_loop:	
	ldx #<basic_current_line_ptr
	jsr peek_under_roms	
	cmp #$00
	beq list_end_of_line
	cmp #$22
	bne list_not_quote
	lda quote_mode_flag
	eor #$ff
	sta quote_mode_flag
	lda #$22
	jmp list_is_literal
list_not_quote:	
	;; Check quote mode, and display as literal if required
	ldx quote_mode_flag
	bne list_is_literal
	
	cmp #$7f
	bcc list_is_literal

	;; Display a token

	;; Save registers
	tax
	pha
	tya
	pha

	;; Get pointer to compressed keyword list
	lda #<packed_keywords
	sta temp_string_ptr+0
	lda #>packed_keywords
	sta temp_string_ptr+1
	
	;; Subtract $80 from token to get offset in word
	;; list
	txa
	and #$7f
	tax

	;; Now ask for it to be printed
	ldy #$ff
	jsr packed_word_search

	pla
	tay
	pla

	cmp #$8f
	bne list_not_rem
	;; REM command locks quote flag on until the end of the line, allowing
	;; funny characters in REM statements without problem.
	inc $0427
	sta quote_mode_flag 	; Any value other than $00 or $FF will lock quote mode on, so the token value of REM is fine here
	;; FALL THROUGH
list_not_rem:		
	
	iny
	bne list_print_loop

list_is_literal:
	jsr $ffd2
	iny
	bne list_print_loop
	
list_end_of_line:
	;; Clear reverse flag
	lda #$92
	jsr $ffd2
	;; Print end of line
	lda #$0d
	jsr $ffd2

	;; Now link to the next line
	jsr basic_find_next_line
	jmp list_loop
	
