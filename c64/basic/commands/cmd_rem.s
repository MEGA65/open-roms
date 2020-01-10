#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

// REM statement just skips to the next line

cmd_rem:
	jmp basic_end_of_line


#endif // ROM layout
