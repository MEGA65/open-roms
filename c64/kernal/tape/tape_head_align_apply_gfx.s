// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape head alignemnt tool - draw helper symbols
//


#if CONFIG_TAPE_HEAD_ALIGN


tape_head_align_apply_gfx:

	// Apply GFX effects

	lda __ha_gfxflag
	inc __ha_gfxflag
	clc
	adc #$08
	and #%00001100
	bne !+
	ldy #%11110001
	lda #%10001111
	bne !++
!:
	ldy #%00000001
	lda #%10000000
!:
	ora __ha_chart + 7 + 8 * 0
	sta __ha_chart + 7 + 8 * 0

	tya
	ora __ha_chart + 7 + 8 * 31
	sta __ha_chart + 7 + 8 * 31

	// Draw helper lines

	lda __ha_gfxflag
	and #%00000010
	beq !+

	// For 'normal'

	lda #%00000001
	ora __ha_chart + 7 + 8 * 6
	sta __ha_chart + 7 + 8 * 6

	lda #%00000001
	ora __ha_chart + 7 + 8 * 13
	sta __ha_chart + 7 + 8 * 13

	// For 'turbo'

	lda #%00010000
	ora __ha_chart + 7 + 8 * 21
	sta __ha_chart + 7 + 8 * 21
!:
	rts


#endif
