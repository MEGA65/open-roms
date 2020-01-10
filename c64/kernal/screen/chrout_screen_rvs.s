#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// RVS ON/OFF handling within CHROUT
//


chrout_screen_RVS_ON:

	lda #$80
	bne !+ // branch always

chrout_screen_RVS_OFF:

	lda #$00
!:
	sta RVS
	jmp chrout_screen_done


#endif // ROM layout
