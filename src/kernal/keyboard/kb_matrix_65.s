// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Extended keyboard matrix for Commodore 65 keyboards, based on
//
// - https://github.com/MEGA65/c65-specifications/blob/master/c65manualupdated.txt
//


#if CONFIG_KEYBOARD_C65 && !CONFIG_LEGACY_SCNKEY


kb_matrix_65:

	.byte $00, KEY_C64_TAB_FW, $00, KEY_HELP, KEY_F9,  KEY_F11, KEY_F13, KEY_ESC

kb_matrix_65_shifted:

	.byte $00, KEY_C64_TAB_BW, $00, KEY_HELP, KEY_F10, KEY_F12, KEY_F14, KEY_ESC


#endif // CONFIG_KEYBOARD_C65 and no CONFIG_LEGACY_SCNKEY
