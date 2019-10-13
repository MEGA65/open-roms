
//
// Print video system on startup banner
//

#if CONFIG_SHOW_PAL_NTSC

print_pal_ntsc:

	ldx #__MSG_KERNAL_NTSC
	lda TVSFLG
	beq !+
	ldx #__MSG_KERNAL_PAL
!:
	jmp print_kernal_message

#endif // CONFIG_SHOW_PAL_NTSC