#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Set realtime clock
// C64 Programmers Reference Guide Page 273

	jmp SETTIM


#endif // ROM layout
