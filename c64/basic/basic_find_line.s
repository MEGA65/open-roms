	;; Find the BASIC line with number basic_line_number


basic_find_line:
	;; Get pointer to start of BASIC text
	lda basic_start_of_text_ptr+0
	sta basic_current_line_ptr+0
	lda basic_start_of_text_ptr+1
	sta basic_current_line_ptr+1

basic_find_line_loop:	
	;; Then search for line number
	;; Line number 
	ldy #2
	ldx #<basic_current_line_ptr
	jsr peek_under_roms
	cmp basic_line_number+0
	bne not_this_line
	iny
	jsr peek_under_roms
	cmp basic_line_number+1
	bne not_this_line

	clc
	rts
not_this_line:
	;; Not this line, so advance to next line
	ldy #0
	ldx #<basic_current_line_ptr
	jsr peek_under_roms
	bne more_lines_exist
	iny
	jsr peek_under_roms
	bne more_lines_exist
	;; no more lines exist, return failure
	sec
	rts
more_lines_exist:	
	;; A = high byte of line
	pha
	dey
	jsr peek_under_roms
	sta basic_current_line_ptr+0
	pla
	sta basic_current_line_ptr+1
	jmp basic_find_line_loop
