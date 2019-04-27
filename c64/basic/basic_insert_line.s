	;; Insert the tokenised line stored at $0200.
	;; First work out where in the list to put it
	;; (basic_find_line with the line number can be used to work
	;; out the insertion point, as it should abort once it finds a
	;; line number too high).
	;; Then all we have to do is push the rest of the BASIC text up,
	;; and update the pointers in all following basic lines.
basic_insert_line:

	;; ASSUMES basic_find_line has been called to set the insert point.
	;; We need to insert space for the link link token, the line number,
	;; and the zero-terminated line itself.  This means 2+2+1 plus length
	;; of tokenised string after the line number

	;; But first, remember where the pointer will be, so that we can
	;; put the line in there after.
	lda basic_current_line_ptr+0
	pha
	lda basic_current_line_ptr+1
	pha
	
	;; Get number of bytes in tokenised line after line number
	lda tokenise_work2
	sec
	sbc tokenise_work1
	;; Add on the four bytes space we need
	clc
	adc #5
	pha
	tax
	
	;; Make the space
	jsr basic_shift_mem_up_and_relink

	;; Now increase top of BASIC mem
	pla
	clc
	adc basic_end_of_text_ptr+0
	sta basic_end_of_text_ptr+0
	lda basic_end_of_text_ptr+1
	adc #0
	sta basic_end_of_text_ptr+1
	
	;; Get pointer back
	pla
	sta basic_current_line_ptr+1
	pla
	sta basic_current_line_ptr+0

	inc $0427
	;; Write the line number
	ldy #2
	ldx #<basic_current_line_ptr
	lda basic_line_number+0
	jsr poke_under_roms
	iny
	lda basic_line_number+1
	jsr poke_under_roms

	;; Now store the line body itself
line_store_loop:
	ldx tokenise_work1
	lda $0200,x
	inc tokenise_work1
	ldx #<basic_current_line_ptr
	iny
	jsr poke_under_roms
	lda tokenise_work1
	cmp tokenise_work2
	bne line_store_loop
	
	
	sec
	rts
	
