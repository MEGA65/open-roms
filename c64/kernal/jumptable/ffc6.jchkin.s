#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// Open channel for input
// C64 Programmers Reference Guide Page 272
// According to Computes Mapping the Commodore 64 (pages 74/75), this jump is indirect

	jmp (ICHKIN)


#endif // ROM layout
