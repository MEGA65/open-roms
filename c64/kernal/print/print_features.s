#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Print configured features on startup banner
//

#if CONFIG_SHOW_FEATURES

print_features:

	ldx #__MSG_KERNAL_FEATURES
!:
	jmp print_kernal_message

#endif // CONFIG_SHOW_FEATURES


#endif // ROM layout
