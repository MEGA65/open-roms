// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape head alignemnt tool - interrupt routine
//


#if CONFIG_TAPE_HEAD_ALIGN


tape_head_align_irq:

	// Acknowledge interrupt

	asl VIC_IRQ

	// Clear table of pulses stored

	lda #$FF
	ldy #$3F
!:
	sta __ha_pulses, y
	dey
	bpl !-

	// Ignore 2 first pulses, they can be garbage

	jsr tape_head_align_get_pulse
	jsr tape_head_align_get_pulse

	// Now, we can retrieve a pulse for the charts

	ldx #$00
!:
	jsr tape_head_align_get_pulse

	// If we approached badlines again - we cannot use this measurement anymore

	lda VIC_SCROLY
	bmi !+                             // branch if lower border

	lda VIC_RASTER
	cmp #$33                           // first line where badline can occur
	bcs tape_head_align_irq_end
!:
	// Store measurement

	tya
	sta __ha_pulses, x

	// Next iteration

	inx
	cpx #$40
	bne !--

	// FALLTROUGH

tape_head_align_irq_end:

	jmp return_from_interrupt


#endif // CONFIG_TAPE_HEAD_ALIGN
