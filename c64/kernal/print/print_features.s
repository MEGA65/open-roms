// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Print configured features on startup banner
//

#if CONFIG_SHOW_FEATURES

print_features:

	ldx #__MSG_KERNAL_FEATURES
!:
	jmp print_kernal_message

#endif // CONFIG_SHOW_FEATURES
