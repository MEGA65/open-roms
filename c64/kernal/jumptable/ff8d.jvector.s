#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Read/set vectored I/O
// C64 Programmers Reference Guide Page 273

	jmp VECTOR


#endif // ROM layout
