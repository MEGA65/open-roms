// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape head alignemnt tool - interrupt routine
//


#if CONFIG_TAPE_HEAD_ALIGN


tape_head_align_irq:

	// inc $d020 // XXX for debug only

	// Acknowledge interrupt

	asl VIC_IRQ

	// Clear table of pulses stored

	lda #$FF
	ldy #$0F
!:
	sta __ha_pulses, y
	dey
	bpl !-

	// Ignore 2 first pulses, they can be garbage

	jsr tape_head_align_get_pulse
	jsr tape_head_align_get_pulse

	// Now, we can retrieve a pulse for real

	ldx #$00
!:
	jsr tape_head_align_get_pulse
	tya
	sta __ha_pulses, x

	// XXX terminate ion case VIC_RASTER went too far

	inx
	cpx #$10
	bne !- 

	// dec $d020 // XXX for debug only

	jmp return_from_interrupt


#endif // CONFIG_TAPE_HEAD_ALIGN
