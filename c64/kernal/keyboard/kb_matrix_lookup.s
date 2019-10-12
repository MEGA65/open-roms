
//
// Work out if normal, shifted, control or Vendor modified keyboard. 
// Table contains the offsets into keyboard_matrixes that should be used
// for different values of the bottom 3 bits of key_bucky_state XXX
// Interaction is simple to work out when playing with a C64:
// CTRL trumps SHIFT or VENDOR
// VENDOR + SHIFT = DOES NOTHING
// All 3 does CONTROL
//

kb_matrix_lookup:

	.byte (__kb_matrix_normal - kb_matrix)  // Normal
	.byte (__kb_matrix_shift  - kb_matrix)  // SHIFT
	.byte (__kb_matrix_ctrl   - kb_matrix)  // CTRL
	.byte (__kb_matrix_ctrl   - kb_matrix)  // CTRL + SHIFT
	.byte (__kb_matrix_vendor - kb_matrix)  // VENDOR
	.byte (__kb_matrix_vendor - kb_matrix)  // VENDOR + SHIFT
	.byte (__kb_matrix_ctrl   - kb_matrix)  // VENDOR + CTRL
	.byte (__kb_matrix_ctrl   - kb_matrix)  // VENDOR + CTRL + SHIFT
