#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)


screen_check_space_ends_line:

	jsr screen_get_logical_line_end_ptr

	lda (PNT), y
	cmp #$20

	rts


#endif // ROM layout
