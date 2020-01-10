#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// read/set the bottom of memory
// C64 Programmers Reference Guide Page 272

	jmp MEMBOT


#endif // ROM layout
