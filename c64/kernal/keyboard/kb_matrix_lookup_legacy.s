#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Work out if normal, shifted, control or Vendor modified keyboard. 
// Table contains the offsets into keyboard_matrixes that should be used
// for different values of the bottom 3 bits of key_bucky_state XXX
// Interaction is simple to work out when playing with a C64:
// CTRL trumps SHIFT or VENDOR
// VENDOR + SHIFT = DOES NOTHING
// All 3 does CONTROL
//

// This lookup table is used by TWW/CTR keyboard routine only!


#if CONFIG_LEGACY_SCNKEY

kb_matrix_lookup:

	.byte $00 		// Normal
	.byte $40		// Shifted
	.byte $80		// Control
	.byte $80		// Control + SHIFT
	.byte $C0		// Vendor
	.byte $C0 		// Vendor + SHIFT
	.byte $80		// Vendor + CTRL
	.byte $80		// Vendor + CTRL + SHIFT

#endif // CONFIG_LEGACY_SCNKEY


#endif // ROM layout
