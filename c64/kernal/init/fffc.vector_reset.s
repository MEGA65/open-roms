#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// $FFFC - CPU Reset Vector
// Uncontrovertial, as it is a CPU requirement, and nothing else.

	.word hw_entry_reset


#endif // ROM layout
