
//
// Matrix for filtering out bucky keys while scanning the C64 keyboard
//
// Values based on:
// - [CM64] Compute's Mapping the Commodore 64 - pags 58 (SHFLAG), 173 (matrix)
//


#if !CONFIG_SCNKEY_TWW_CTR


kb_matrix_bucky_filter:

	// values for OR with CIA1_PRB content to filter out bucky keys

	.byte %00100100 // VENDOR + CONTROL
	.byte %00010000 // SHIFT (right)
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10000000 // SHIFT (left)
	.byte %00000000


#endif // no CONFIG_SCNKEY_TWW_CTR
