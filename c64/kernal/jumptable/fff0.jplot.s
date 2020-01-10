#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// $FFF0 - Get/Set cursor location vector
// (http://codebase64.org/doku.php?id=base:kernalreference)
// To set: C=0, to get, C=1
// X=row, Y=column

	jmp PLOT


#endif // ROM layout
