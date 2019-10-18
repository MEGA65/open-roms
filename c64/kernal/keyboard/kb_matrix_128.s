
//
// Extended keyboard matrix for Commodore 128 keyboards, based on
//
// - [CM128] Compute's Mapping the Commodore 128 - page 290
// - http://commodore128.mirkosoft.sk/keyboard.html
//


#if CONFIG_KEYBOARD_C128 && !CONFIG_LEGACY_SCNKEY


kb_matrix_128:

	.byte KEY_HELP,$38,$38,KEY_TAB_FW,$32,$34,$37,$31
	.byte KEY_ESC,$2B,$2D,$8D,$0D,$36,$39,$33
	.byte $00,$30,$2E,$91,$11,$9D,$1D,$00


kb_matrix_128_bucky_filter:

	// values for OR with CIA1_PRB content to filter out bucky keys

	.byte %00000000
	.byte %00000000 
	.byte %10000001 // ALT, NO_SCRL



#endif // CONFIG_KEYBOARD_C128 and no CONFIG_LEGACY_SCNKEY
