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
	ldy #0
	jsr peek_pointer_null_check
	bcs list_more_lines

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
	jmp list_is_literal
list_not_quote:	
	cmp #$7f
	bcc list_is_literal

	;; Display a token

	iny
	bne list_print_loop

list_is_literal:
	jsr $ffd2
	iny
	bne list_print_loop
	
list_end_of_line:	
	;; Print end of line
	lda #$0d
	jsr $ffd2

	;; Now link to the next line
	jsr basic_find_next_line
	jmp list_loop
	
