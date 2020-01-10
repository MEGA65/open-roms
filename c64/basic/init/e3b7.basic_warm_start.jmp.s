#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

// Clear screen etc, show READY prompt.

basic_warm_start:

	jmp basic_warm_start_real


#endif // ROM layout
