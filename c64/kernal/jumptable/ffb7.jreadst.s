#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Read I/O statusjmp
// C64 Programmers Reference Guide Page 273

	jmp READST


#endif // ROM layout
