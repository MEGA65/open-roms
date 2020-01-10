#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// $FFED - Return screen size (X=columns, Y=rows)
// (http://codebase64.org/doku.php?id=base:kernalreference)

	jmp SCREEN


#endif // ROM layout
