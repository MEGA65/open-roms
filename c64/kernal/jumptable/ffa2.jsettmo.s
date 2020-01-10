#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Set timeout on serial bus
// C64 Programmers Reference Guide Page 273

	jmp SETTMO


#endif // ROM layout
