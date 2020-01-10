#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// $FFEA - Update jiffy clock vector
// (http://codebase64.org/doku.php?id=base:kernalreference)

	jmp UDTIM


#endif // ROM layout
