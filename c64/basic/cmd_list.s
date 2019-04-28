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

	;; Print end of line
	lda #$0d
	jsr $ffd2

	;; Now link to the next line
	jsr basic_find_next_line
	jmp list_loop
	
