// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape head alignemnt tool - draw pulses
//


#if CONFIG_TAPE_HEAD_ALIGN


tape_head_align_draw_pulse:

	// Put pulse on the screen; center the chart horizontaly, with some margin from top

	.label __ha_chart = $2000 + 8 * (40 * __ha_start + 4)

	tax
	lda __ha_offsets, x
	tay
	lda __ha_masks, x
	ora __ha_chart + 7, y
	sta __ha_chart + 7, y
!:
	rts


#endif
