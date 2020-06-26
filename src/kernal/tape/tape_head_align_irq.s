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

	// Ignore 2 first pulses, they can be garbage

	jsr tape_head_align_get_pulse
	jsr tape_head_align_get_pulse

	// Now, we can retrieve pulses for the chart

	ldx #$00

	// FALLTROUGH

tape_head_align_irq_loop:

	jsr tape_head_align_get_pulse

	// If we approached badlines again - we cannot use this measurement anymore

	lda VIC_SCROLY
	bmi !+                             // branch if lower border

	lda VIC_RASTER
	cmp #$33                           // first line where badline can occur
	bcs tape_head_align_irq_end
!:
	// Draw pulse on the screen

	cpy #$FF
	beq !+

	// Center the chart horizontaly, with some margin from top

	.label __ha_chart = $2000 + 8 * (40 * __ha_start + 4)

	phx_trash_a

	lda __ha_offsets, y
	tax
	lda __ha_masks, y
	ora __ha_chart + 7, x
	sta __ha_chart + 7, x

	plx_trash_a
!:
	// Next iteration

	inx
	cpx #$40
	bne tape_head_align_irq_loop

	// FALLTROUGH

tape_head_align_irq_end:

	jmp return_from_interrupt


#endif // CONFIG_TAPE_HEAD_ALIGN
