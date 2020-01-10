#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

// $FFFE - CPU IRQ Vector.
// This is non-controvertial, as it is a 6502 CPU requirement, and we just have to point
// it to whatever IRQ routine we make.

	.word hw_entry_irq


#endif // ROM layout
