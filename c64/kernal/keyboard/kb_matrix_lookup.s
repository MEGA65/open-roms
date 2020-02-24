// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Helper table for determining keyboard matrix decoding table on the C64 keyboard
//
// When more than one bucky keey is pressed, decoding keys is asking for trouble,
// so never allow this.
//


#if !CONFIG_LEGACY_SCNKEY 

kb_matrix_lookup:

	.byte (__kb_matrix_normal - kb_matrix)  // %000 Normal
	.byte (__kb_matrix_shift  - kb_matrix)  // %001 SHIFT
	.byte (__kb_matrix_vendor - kb_matrix)  // %010 VENDOR	
	.byte $FF                               // %011 SHIFT+VENDOR
	.byte (__kb_matrix_ctrl   - kb_matrix)  // %100 CTRL
	.byte $FF                               // %101 SHIFT+CTRL
	.byte $FF                               // %110 VENDOR+CTRL
	.byte $FF                               // %111 SHIFT+VENDOR+CTRL

#endif
