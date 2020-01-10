#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)


ready_message:
	// See src/make_error_tables.c for packed message handling
	// information.
	ldx #29
	jmp print_packed_message


#endif // ROM layout
