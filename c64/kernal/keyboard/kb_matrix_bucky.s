
//
// Matrix for retrieving bucky key status on the C64 keyboard
//
// Values based on:
// - [CM64]  Compute's Mapping the Commodore 64 - pages 58 (SHFLAG), 173 (matrix)
// - [CM128] Compute's Mapping the Commodore 128 - pages 212 (SHFLAG), 290 (matrix)
//

#if !CONFIG_LEGACY_SCNKEY


kb_matrix_bucky_confmask: // values to be written to CIA1_PRA

	.byte %11111101 // SHIFT (left)
	.byte %10111111 // SHIFT (right)
	.byte %01111111 // VENDOR      
	.byte %01111111 // CTRL
#if CONFIG_KEYBOARD_C128
	.byte %11111111 // C128 extra keys
	.byte %11111111
#endif


__kb_matrix_bucky_confmask_end:


#if CONFIG_KEYBOARD_C128

kb_matrix_bucky_confmask_c128: // values to be written to VIC_XSCAN

	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

	.byte %11111011 // ALT
	.byte %11111011 // NO_SCRL

#endif


kb_matrix_bucky_testmask: // for AND with CIA1_PRB value

	.byte %10000000 // SHIFT (left)
	.byte %00010000 // SHIFT (right)
	.byte %00100000 // VENDOR
	.byte %00000100 // CTRL
#if CONFIG_KEYBOARD_C128
	.byte %10000000 // ALT
	.byte %00000001 // NO_SCRL
#endif


kb_matrix_bucky_shflag: // mask to be ORed to SHFLAG to mark key status

	.byte KEY_FLAG_SHIFT
	.byte KEY_FLAG_SHIFT
	.byte KEY_FLAG_VENDOR
	.byte KEY_FLAG_CTRL
#if CONFIG_KEYBOARD_C128
	.byte KEY_FLAG_ALT
	.byte KEY_FLAG_NO_SCRL
#endif


#endif // no CONFIG_LEGACY_SCNKEY
