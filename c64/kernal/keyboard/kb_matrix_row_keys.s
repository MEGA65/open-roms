// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Single row key codes for scanning the C64 keyboard
//
// Values based on:
// - [CM64] Computes Mapping the Commodore 64 - pags 58 (SHFLAG), 173 (matrix)
//


#if !CONFIG_LEGACY_SCNKEY


kb_matrix_row_keys:

	// - values for CIA1_PRA to connect only the given row
	// - first 3 values also meant for VIC_XSCAN for C128 keyboards
	// - also used to scan a single row

	.byte %11111110
	.byte %11111101
	.byte %11111011
	.byte %11110111
	.byte %11101111
	.byte %11011111
	.byte %10111111
	.byte %01111111


#endif // no CONFIG_LEGACY_SCNKEY
