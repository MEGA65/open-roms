#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Initialise RAM, allocate tape buffer, set screen to $0400
// C64 Programmers Reference Guide Page 273

	jmp RAMTAS


#endif // ROM layout
