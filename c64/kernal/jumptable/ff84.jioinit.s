#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Initialise input/output
// C64 Programmers Reference Guide Page 272

	jmp IOINIT


#endif // ROM layout
