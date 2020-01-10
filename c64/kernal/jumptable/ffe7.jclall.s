#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// $FFE7 - Close all files vector
// (http://codebase64.org/doku.php?id=base:kernalreference)
// According to Computes Mapping the Commodore 64 (pages 74/75), this jump is indirect

	jmp (ICLALL)


#endif // ROM layout
