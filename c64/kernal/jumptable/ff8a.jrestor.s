#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Restore default IO vectors
// C64 Programmers Reference Guide Page 273

	jmp RESTOR


#endif // ROM layout
