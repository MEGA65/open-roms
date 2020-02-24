// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


screen_check_space_ends_line:

	jsr screen_get_logical_line_end_ptr

	lda (PNT), y
	cmp #$20

	rts
