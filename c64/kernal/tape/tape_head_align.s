// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - reading speed calibration
//
// Needs pulse length in .A
//


#if CONFIG_TAPE_HEAD_ALIGN


tape_head_align:

#if (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

	jsr     map_KERNAL_1
	jsr_ind VK1__tape_head_align
	jmp     map_NORMAL

#else

	// Start by asking for tape playback

	// jsr tape_ask_play

	// Disable interrupts

	sei

	// Set IO to default values

	jsr IOINIT
	jsr cint_legacy

	// Clear color data ($0800)

	ldy #$00
!:
	lda #($10 + $06)    // XXX synchronize colors with setup_vicii

	sta $0800, y
	sta $0900, y
	sta $0A00, y
	sta $0B00, y

	iny
	bne !-

	// Clear bitmap data ($2000)

	lda #$20
	sta SAL+1
	tya                                // put 0 to .A
	sta SAL+0
!:
	sta (SAL), y
	iny
	bne !-

	inc SAL+1
	ldx SAL+1
	cpx #$40
	bne !-

	// Set graphics mode

	lda #$28                           // graphic memory start at $2000, color at $0800
	sta VIC_YMCSB

	lda #$3B                           // set bit 5 to enable graphic mode
	sta VIC_SCROLY

	// Set tape timing

	// XXX

tape_head_align_loop_1:

	// XXX waste pulse

tape_head_align_loop_2:

	// XXX get pulse
	// XXX put pulse
	// XXX check time; if not enough passed - next iteration tape_head_align_loop2
	// XXX check for STOP key; if pressed, quit
	// XXX scroll

	jmp tape_head_align_loop_1

tape_head_align_quit:

	// Clear screen, restore old display settings

	jsr cint_legacy

	// XXX restore COLOR, VIC_EXTCOL, VIC_BGCOL0, CIA2_PRA

	cli
	rts // XXX perform new after quit


#endif // ROM layout


#endif // CONFIG_TAPE_HEAD_ALIGN
