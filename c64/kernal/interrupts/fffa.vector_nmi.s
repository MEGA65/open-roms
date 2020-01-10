#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// $FFFA - CPU NMI Hanlder
// Uncontrovertial as this is also a CPU requirement.

	.word hw_entry_nmi


#endif // ROM layout
