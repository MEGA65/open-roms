#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Command devices on the serial bus to listen
// C64 Programmers Reference Guide Page 272

	jmp LISTEN


#endif // ROM layout
