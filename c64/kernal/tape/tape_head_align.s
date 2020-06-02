// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape head alignemnt tool
//


#if CONFIG_TAPE_HEAD_ALIGN


.label __ha_start     = 3              // starting row of the chart
.label __ha_rows      = 20             // number of rows for scrolling

// Helper tables

.label __ha_offsets   = $1000;
.label __ha_masks     = $1100;

// Helper variables

.label __ha_lda_addr  = $1200;        // 2 bytes, for code generator
.label __ha_sta_addr  = $1202;        // 2 bytes, for code generator
.label __ha_counter   = $1204;        // 3 bytes

// Generated code location

.label __ha_scroll    = $1300;


tape_head_align:

#if (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

	jsr     map_KERNAL_1
	jsr_ind VK1__tape_head_align
	jmp     map_NORMAL

#else

	// Disable interrupts, set proper I/O values

	sei
	jsr CLALL
	jsr IOINIT
	jsr cint_legacy

	ldx #$02                  // set timer A to 3 ticks
	jsr tape_common_prepare_cia_by_x

	jsr tape_motor_on

	// Clear color data ($0800)

	ldy #$00
!:
	lda #(CONFIG_COLOR_TXT * $10 + CONFIG_COLOR_BG)

	sta $0800, y
	sta $0900, y
	sta $0A00, y
	sta $0B00, y

	iny
	bne !-

	// Make sure the row where the chart is being created is not visible

	lda #(CONFIG_COLOR_BG * $10 + CONFIG_COLOR_BG)
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

	lda #$28                           // graphics start at $2000, color at $0800
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

	// Generate helpercode for screen scrolling

	jsr tape_head_align_gen_code

tape_head_align_loop_1:

	// XXX check for STOP key, possibly terminate

	// Scroll the whole chart one line down

	ldx #$00
!:
	jsr __ha_scroll                    // scroll one column down, using fast generated code

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

#endif // ROM layout


#endif // CONFIG_TAPE_HEAD_ALIGN
