basic_follow_link_to_next_line:
	ldy #0
	ldx #<basic_current_line_ptr
	jsr peek_under_roms
	pha
	iny
	jsr peek_under_roms
	sta basic_current_line_ptr+1
	pla
	sta basic_current_line_ptr+0
	rts
