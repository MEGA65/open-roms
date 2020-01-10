#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

// Skip the gap between $C000-$DFFF

	.fill $2000, $00


#endif // ROM layout
