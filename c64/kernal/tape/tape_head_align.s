// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - reading speed calibration
//
// Needs pulse length in .A
//


#if CONFIG_TAPE_HEAD_ALIGN


.label __ha_start     = 3              // starting row of the chart

// Helper tables

.label __ha_offsets   = $1000;
.label __ha_masks     = $1100;

// Helper variables

.label __ha_counter   = $1200;        // 3 bytes


tape_head_align:

#if (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

	jsr     map_KERNAL_1
	jsr_ind VK1__tape_head_align
	jmp     map_NORMAL

#else

	// Start by asking for playback

	// XXX jsr tape_ask_play

	// Disable interrupts, set proper I/O values

	sei
	jsr IOINIT
	jsr cint_legacy
	jsr tape_motor_on
	ldx #$02                  // set timer A to 3 ticks
	jsr tape_common_prepare_cia_by_x

	// Clear color data ($0800)

	ldy #$00
!:
	lda #($01 * $10 + $06)    // XXX synchronize colors with setup_vicii

	sta $0800, y
	sta $0900, y
	sta $0A00, y
	sta $0B00, y

	iny
	bne !-

	// Make sure the row where the chart is created is not visible

	lda #($06 * $10 + $06)    // XXX synchronize colors with setup_vicii
	ldy #$28
!:
	sta $0800 + __ha_start * 40 - 1, y
	dey
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

	// Prepare lookup tables - to speed drawing, we are going to use two of them:
	// - byte offset table will tell us which byte in memory to alter
	// - mask will allow us to quickly put the pixel

	ldx #$00                           // loop index
	ldy #$00                           // temporary value for mask calculation
!:
	// Byte offset is simple, just zero the 3 least significant bits

	txa
	and #%11111000
	sta __ha_offsets, x

	// Mask changes with each iteration, use our temporary value in .Y

	tya
	clc
	ror
	bne !+
	lda #%10000000
!:
	tay
	sta __ha_masks, x

	// Next iteration

	inx
	bne !--

tape_head_align_loop_1:

	// XXX check for STOP key, possibly terminate

	// Scroll the whole chart one line down

	ldx #$00
!:
	jsr tape_head_align_scroll_column

	txa
	clc
	adc #$08
	tax
	bne !-

	// XXX draw helper lines

	// Initialize counter

	lda #$80
	sta __ha_counter + 1
	lda #$00
	sta __ha_counter + 0
	sta __ha_counter + 2

	// Skip 2 pulses, these measurements will be too imprecise

	jsr tape_head_align_get_pulse
	jsr tape_head_align_get_pulse

tape_head_align_loop_2:

	// Retrieve actual pulse length

	jsr tape_head_align_get_pulse
	cmp #$FF
	beq tape_head_align_drawn          // skip drawing for too long pulses

	// Put pulse on the screen; center the chart horizontaly, with some margin from top

	.label __ha_chart = $2000 + 8 * (40 * __ha_start + 4)

	tax
	lda __ha_offsets, x
	tay
	lda __ha_masks, x
	ora __ha_chart + 7, y
	sta __ha_chart + 7, y

	// FALLTROUGH

tape_head_align_drawn:

	lda __ha_counter + 2
	beq tape_head_align_loop_2
	bne tape_head_align_loop_1

tape_head_align_quit:

	// Clear screen, restore old display settings

	jsr cint_legacy

	// XXX restore COLOR, VIC_EXTCOL, VIC_BGCOL0, CIA2_PRA

	cli
	rts // XXX perform new after quit

tape_head_align_get_pulse:

	// This routine differs a lot from the one used to read pulse during tape reading:
	// - it is not as precise
	// - it terminates when timer reaches $FF
	// - it updates

	lda #$10
!:
	// Loop to detect signal

	ldy CIA2_TIMBLO // $DD06
	bit CIA1_ICR    // $DC0D
	bne !+

	cpy #$FF
	bne !-
!:
	// Start timer again, force latch reload, count timer A underflows

	ldx #%01010001
	stx CIA2_CRB    // $DD0F

	// Update time counter

	tya
	clc
	adc __ha_counter + 0
	sta __ha_counter + 0
	bcc !+
	inc __ha_counter + 1
	bne !+
	inc __ha_counter + 2
!:
	// Return with time elapsed

	tya
	rts

tape_head_align_scroll_column:

	// XXX autogenerate this code somewhere

	lda __ha_chart + 9 * (8 * 40) + 6, x
	sta __ha_chart + 9 * (8 * 40) + 7, x

	lda __ha_chart + 9 * (8 * 40) + 5, x
	sta __ha_chart + 9 * (8 * 40) + 6, x

	lda __ha_chart + 9 * (8 * 40) + 4, x
	sta __ha_chart + 9 * (8 * 40) + 5, x

	lda __ha_chart + 9 * (8 * 40) + 3, x
	sta __ha_chart + 9 * (8 * 40) + 4, x

	lda __ha_chart + 9 * (8 * 40) + 2, x
	sta __ha_chart + 9 * (8 * 40) + 3, x

	lda __ha_chart + 9 * (8 * 40) + 1, x
	sta __ha_chart + 9 * (8 * 40) + 2, x

	lda __ha_chart + 9 * (8 * 40) + 0, x
	sta __ha_chart + 9 * (8 * 40) + 1, x

	lda __ha_chart + 8 * (8 * 40) + 7, x
	sta __ha_chart + 9 * (8 * 40) + 0, x

	lda __ha_chart + 8 * (8 * 40) + 6, x
	sta __ha_chart + 8 * (8 * 40) + 7, x

	lda __ha_chart + 8 * (8 * 40) + 5, x
	sta __ha_chart + 8 * (8 * 40) + 6, x

	lda __ha_chart + 8 * (8 * 40) + 4, x
	sta __ha_chart + 8 * (8 * 40) + 5, x

	lda __ha_chart + 8 * (8 * 40) + 3, x
	sta __ha_chart + 8 * (8 * 40) + 4, x

	lda __ha_chart + 8 * (8 * 40) + 2, x
	sta __ha_chart + 8 * (8 * 40) + 3, x

	lda __ha_chart + 8 * (8 * 40) + 1, x
	sta __ha_chart + 8 * (8 * 40) + 2, x

	lda __ha_chart + 8 * (8 * 40) + 0, x
	sta __ha_chart + 8 * (8 * 40) + 1, x

	lda __ha_chart + 7 * (8 * 40) + 7, x
	sta __ha_chart + 8 * (8 * 40) + 0, x

	lda __ha_chart + 7 * (8 * 40) + 6, x
	sta __ha_chart + 7 * (8 * 40) + 7, x

	lda __ha_chart + 7 * (8 * 40) + 5, x
	sta __ha_chart + 7 * (8 * 40) + 6, x

	lda __ha_chart + 7 * (8 * 40) + 4, x
	sta __ha_chart + 7 * (8 * 40) + 5, x

	lda __ha_chart + 7 * (8 * 40) + 3, x
	sta __ha_chart + 7 * (8 * 40) + 4, x

	lda __ha_chart + 7 * (8 * 40) + 2, x
	sta __ha_chart + 7 * (8 * 40) + 3, x

	lda __ha_chart + 7 * (8 * 40) + 1, x
	sta __ha_chart + 7 * (8 * 40) + 2, x

	lda __ha_chart + 7 * (8 * 40) + 0, x
	sta __ha_chart + 7 * (8 * 40) + 1, x

	lda __ha_chart + 6 * (8 * 40) + 7, x
	sta __ha_chart + 7 * (8 * 40) + 0, x

	lda __ha_chart + 6 * (8 * 40) + 6, x
	sta __ha_chart + 6 * (8 * 40) + 7, x

	lda __ha_chart + 6 * (8 * 40) + 5, x
	sta __ha_chart + 6 * (8 * 40) + 6, x

	lda __ha_chart + 6 * (8 * 40) + 4, x
	sta __ha_chart + 6 * (8 * 40) + 5, x

	lda __ha_chart + 6 * (8 * 40) + 3, x
	sta __ha_chart + 6 * (8 * 40) + 4, x

	lda __ha_chart + 6 * (8 * 40) + 2, x
	sta __ha_chart + 6 * (8 * 40) + 3, x

	lda __ha_chart + 6 * (8 * 40) + 1, x
	sta __ha_chart + 6 * (8 * 40) + 2, x

	lda __ha_chart + 6 * (8 * 40) + 0, x
	sta __ha_chart + 6 * (8 * 40) + 1, x

	lda __ha_chart + 5 * (8 * 40) + 7, x
	sta __ha_chart + 6 * (8 * 40) + 0, x

	lda __ha_chart + 5 * (8 * 40) + 6, x
	sta __ha_chart + 5 * (8 * 40) + 7, x

	lda __ha_chart + 5 * (8 * 40) + 5, x
	sta __ha_chart + 5 * (8 * 40) + 6, x

	lda __ha_chart + 5 * (8 * 40) + 4, x
	sta __ha_chart + 5 * (8 * 40) + 5, x

	lda __ha_chart + 5 * (8 * 40) + 3, x
	sta __ha_chart + 5 * (8 * 40) + 4, x

	lda __ha_chart + 5 * (8 * 40) + 2, x
	sta __ha_chart + 5 * (8 * 40) + 3, x

	lda __ha_chart + 5 * (8 * 40) + 1, x
	sta __ha_chart + 5 * (8 * 40) + 2, x

	lda __ha_chart + 5 * (8 * 40) + 0, x
	sta __ha_chart + 5 * (8 * 40) + 1, x

	lda __ha_chart + 4 * (8 * 40) + 7, x
	sta __ha_chart + 5 * (8 * 40) + 0, x

	lda __ha_chart + 4 * (8 * 40) + 6, x
	sta __ha_chart + 4 * (8 * 40) + 7, x

	lda __ha_chart + 4 * (8 * 40) + 5, x
	sta __ha_chart + 4 * (8 * 40) + 6, x

	lda __ha_chart + 4 * (8 * 40) + 4, x
	sta __ha_chart + 4 * (8 * 40) + 5, x

	lda __ha_chart + 4 * (8 * 40) + 3, x
	sta __ha_chart + 4 * (8 * 40) + 4, x

	lda __ha_chart + 4 * (8 * 40) + 2, x
	sta __ha_chart + 4 * (8 * 40) + 3, x

	lda __ha_chart + 4 * (8 * 40) + 1, x
	sta __ha_chart + 4 * (8 * 40) + 2, x

	lda __ha_chart + 4 * (8 * 40) + 0, x
	sta __ha_chart + 4 * (8 * 40) + 1, x

	lda __ha_chart + 3 * (8 * 40) + 7, x
	sta __ha_chart + 4 * (8 * 40) + 0, x

	lda __ha_chart + 3 * (8 * 40) + 6, x
	sta __ha_chart + 3 * (8 * 40) + 7, x

	lda __ha_chart + 3 * (8 * 40) + 5, x
	sta __ha_chart + 3 * (8 * 40) + 6, x

	lda __ha_chart + 3 * (8 * 40) + 4, x
	sta __ha_chart + 3 * (8 * 40) + 5, x

	lda __ha_chart + 3 * (8 * 40) + 3, x
	sta __ha_chart + 3 * (8 * 40) + 4, x

	lda __ha_chart + 3 * (8 * 40) + 2, x
	sta __ha_chart + 3 * (8 * 40) + 3, x

	lda __ha_chart + 3 * (8 * 40) + 1, x
	sta __ha_chart + 3 * (8 * 40) + 2, x

	lda __ha_chart + 3 * (8 * 40) + 0, x
	sta __ha_chart + 3 * (8 * 40) + 1, x

	lda __ha_chart + 2 * (8 * 40) + 7, x
	sta __ha_chart + 3 * (8 * 40) + 0, x

	lda __ha_chart + 2 * (8 * 40) + 6, x
	sta __ha_chart + 2 * (8 * 40) + 7, x

	lda __ha_chart + 2 * (8 * 40) + 5, x
	sta __ha_chart + 2 * (8 * 40) + 6, x

	lda __ha_chart + 2 * (8 * 40) + 4, x
	sta __ha_chart + 2 * (8 * 40) + 5, x

	lda __ha_chart + 2 * (8 * 40) + 3, x
	sta __ha_chart + 2 * (8 * 40) + 4, x

	lda __ha_chart + 2 * (8 * 40) + 2, x
	sta __ha_chart + 2 * (8 * 40) + 3, x

	lda __ha_chart + 2 * (8 * 40) + 1, x
	sta __ha_chart + 2 * (8 * 40) + 2, x

	lda __ha_chart + 2 * (8 * 40) + 0, x
	sta __ha_chart + 2 * (8 * 40) + 1, x

	lda __ha_chart + 1 * (8 * 40) + 7, x
	sta __ha_chart + 2 * (8 * 40) + 0, x

	lda __ha_chart + 1 * (8 * 40) + 6, x
	sta __ha_chart + 1 * (8 * 40) + 7, x

	lda __ha_chart + 1 * (8 * 40) + 5, x
	sta __ha_chart + 1 * (8 * 40) + 6, x

	lda __ha_chart + 1 * (8 * 40) + 4, x
	sta __ha_chart + 1 * (8 * 40) + 5, x

	lda __ha_chart + 1 * (8 * 40) + 3, x
	sta __ha_chart + 1 * (8 * 40) + 4, x

	lda __ha_chart + 1 * (8 * 40) + 2, x
	sta __ha_chart + 1 * (8 * 40) + 3, x

	lda __ha_chart + 1 * (8 * 40) + 1, x
	sta __ha_chart + 1 * (8 * 40) + 2, x

	lda __ha_chart + 1 * (8 * 40) + 0, x
	sta __ha_chart + 1 * (8 * 40) + 1, x

	lda __ha_chart + 0 * (8 * 40) + 7, x
	sta __ha_chart + 1 * (8 * 40) + 0, x

	lda #$00
	sta __ha_chart + 0 * (8 * 40) + 7, x

	rts

#endif // ROM layout


#endif // CONFIG_TAPE_HEAD_ALIGN
