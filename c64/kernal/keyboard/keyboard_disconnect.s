#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Helper routine - disconnects the keyboard from CIA1_PRB,
// leaves $FF in .X (behavior needed in some places)
//


#if !CONFIG_LEGACY_SCNKEY


keyboard_disconnect:

	ldx #$FF
	stx CIA1_PRA  // disconnect all the rows
#if CONFIG_KEYBOARD_C128
	stx VIC_XSCAN
#endif

	rts


#endif


#endif // ROM layout
