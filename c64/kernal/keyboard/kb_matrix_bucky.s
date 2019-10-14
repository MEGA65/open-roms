
//
// Matrix for retrieving bucky key status on the C64 keyboard
//
// Values based on:
// - [CM64] Compute's Mapping the Commodore 64 - pags 58 (SHFLAG), 173 (matrix)
//


#if !CONFIG_LEGACY_SCNKEY


kb_matrix_bucky_confmask: // values to be written to CIA1_PRA

	.byte %11111101 // SHIFT (left)
	.byte %10111111 // SHIFT (right)
	.byte %01111111 // VENDOR      
	.byte %01111111 // CTRL


kb_matrix_bucky_testmask: // for AND with CIA1_PRB value

	.byte %10000000 // SHIFT (left)
	.byte %00010000 // SHIFT (right)
	.byte %00100000 // VENDOR
	.byte %00000100 // CTRL


kb_matrix_bucky_shflag: // mask to be ORed to SHFLAG to mark key status
	.byte KEY_FLAG_SHIFT
	.byte KEY_FLAG_SHIFT
	.byte KEY_FLAG_VENDOR
	.byte KEY_FLAG_CTRL


#endif // no CONFIG_LEGACY_SCNKEY
