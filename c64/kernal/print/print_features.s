
//
// Print configured features on startup banner
//

#if CONFIG_SHOW_FEATURES

print_features:

	ldx #__MSG_KERNAL_FEATURES
!:
	jmp print_kernal_message

#endif // CONFIG_SHOW_FEATURES
