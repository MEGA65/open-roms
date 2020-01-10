#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Send secondary address after LISTEN
// C64 Programmers Reference Guide Page 273

	jmp SECOND


#endif // ROM layout
