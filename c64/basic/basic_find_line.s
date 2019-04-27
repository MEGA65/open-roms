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
	
	ldy #3
	ldx #<basic_current_line_ptr
	jsr peek_under_roms
	cmp basic_line_number+1
	beq +
	bcs line_num_too_high
	bne not_this_line
*
	
	dey
	jsr peek_under_roms
	cmp basic_line_number+0
	beq +
	bcs line_num_too_high
	bne not_this_line
*
	clc
	rts
not_this_line:
	;; Not this line, so advance to next line
	ldx #<basic_current_line_ptr
	jsr peek_pointer_null_check
	bcs more_lines_exist

	;; no more lines exist, return failure
line_num_too_high:
	sec
	rts
more_lines_exist:	

	;; XXX - Add program mangled check here to be triggered
	;; if the link goes backwards.
	;; Follow link to next line
	ldy #0
	ldx #<basic_current_line_ptr
	jsr peek_under_roms
	sta $0100
	iny
	jsr peek_under_roms
	sta basic_current_line_ptr+1
	lda $0100
	sta basic_current_line_ptr+0

	jmp basic_find_line_loop
