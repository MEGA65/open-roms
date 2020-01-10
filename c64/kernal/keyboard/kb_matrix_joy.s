#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Matrix for retrieving C64 joystick status and inject is as keyboard event
//


#if !CONFIG_LEGACY_SCNKEY && (CONFIG_JOY1_CURSOR || CONFIG_JOY2_CURSOR)


kb_matrix_joy_status:

	.byte %00001110                // up
	.byte %00001101                // down
	.byte %00001011                // left
	.byte %00000111                // right

kb_matrix_joy_keytab_idx:

	.byte $07                      // up
	.byte $07                      // down
	.byte $02                      // left
	.byte $02                      // right

kb_matrix_joy_keytab_lo:

	.byte <__kb_matrix_shift       // up
	.byte <__kb_matrix_normal      // down
	.byte <__kb_matrix_shift       // left
	.byte <__kb_matrix_normal      // right

kb_matrix_joy_keytab_hi:

	.byte >__kb_matrix_shift       // up
	.byte >__kb_matrix_normal      // down
	.byte >__kb_matrix_shift       // left
	.byte >__kb_matrix_normal      // right

#endif


#endif // ROM layout
