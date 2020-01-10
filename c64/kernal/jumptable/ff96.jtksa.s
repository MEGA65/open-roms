#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Send secondary address after talk
// C64 Programmers Reference Guide Page 273

	jmp TKSA


#endif // ROM layout
