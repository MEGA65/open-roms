
//
// Extended keyboard matrix for Commodore 128 keyboards, based on
//
// - [CM128] Compute's Mapping the Commodore 128 - page 290
// - http://commodore128.mirkosoft.sk/keyboard.html
//


#if CONFIG_KEYBOARD_C128


kb_matrix_128:

	// XXX fill-in the matrix properly!!!
	.byte $41,$42,$43,$44,$45,$46,$47,$48
	.byte $51,$52,$53,$54,$55,$56,$57,$58
	.byte $61,$62,$63,$64,$65,$66,$67,$68

kb_matrix_128_bucky_filter:

	// values for OR with CIA1_PRB content to filter out bucky keys

	.byte %00000000
	.byte %00000000 
	.byte %00000000 // XXX ALT, NO_SCRL - probably here



#endif // CONFIG_KEYBOARD_C128
