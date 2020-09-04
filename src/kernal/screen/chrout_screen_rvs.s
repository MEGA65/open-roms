// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// RVS ON/OFF handling within CHROUT
//


chrout_screen_RVS_ON:

	lda #$80
	skip_2_bytes_trash_nvz

	// FALLTROUGH

chrout_screen_RVS_OFF:

	lda #$00

	sta RVS
	jmp chrout_screen_done
