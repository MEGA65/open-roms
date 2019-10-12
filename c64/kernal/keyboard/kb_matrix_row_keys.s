
//
// Single row key codes for scanning the C64 keyboard
//
// Values based on:
// - [CM64] Compute's Mapping the Commodore 64 - pags 58 (SHFLAG), 173 (matrix)
//


#if !CONFIG_SCNKEY_TWW_CTR


kb_matrix_row_keys:

	// values for CIA1_PRA to connect only the given row

	.byte %01111111
	.byte %10111111
	.byte %11011111
	.byte %11101111
	.byte %11110111
	.byte %11111011
	.byte %11111101
	.byte %11111110


#endif // no CONFIG_SCNKEY_TWW_CTR
