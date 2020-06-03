// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape head alignemnt tool
//


#if CONFIG_TAPE_HEAD_ALIGN


.label __ha_start     = 11             // starting row of the chart
.label __ha_rows      = 10             // number of rows for scrolling

// Helper tables

.label __ha_offsets   = $1000;
.label __ha_masks     = $1100;

// Helper variables

.label __ha_lda_addr  = $1200;        // 2 bytes, for code generator
.label __ha_sta_addr  = $1202;        // 2 bytes, for code generator
.label __ha_gfxflag   = $1204;

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

	ldx #$FF                  // timer to control scroll speed
	stx CIA1_TIMBLO // $DC06
	stx CIA1_TIMBHI // $DC07

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

	lda #(CONFIG_COLOR_TXT * $10 + CONFIG_COLOR_TXT)
	ldy #$24
!:
	sta $0800 + __ha_start * 40 + 1, y
	sta $0800 + __ha_start * 40 + 1 + (__ha_rows + 1) * 40, y
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

	// Initialize flag for additional GFX effects

	stx __ha_gfxflag

	// Generate helper code for screen scrolling

	jsr tape_head_align_gen_code

tape_head_align_loop_1:

	jsr udtim_keyboard
	jsr STOP
	bcs tape_head_align_quit

	// XXX check for STOP, go to tape_head_align_quit

	// Launch the timer

	ldx #%00011001                     // start timer, one-shot force latch reload, count system ticks
	stx CIA1_CRB    // $DC0F

	// Scroll the whole chart one line down

	ldx #$00
!:
	jsr __ha_scroll                    // scroll one column down, using fast generated code

	txa
	clc
	adc #$08
	tax
	bne !-

	// Draw helpers and decorators

	jsr tape_head_align_apply_gfx

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

	lda CIA1_TIMBLO
	and CIA1_TIMBHI
	eor #$FF

	bne tape_head_align_loop_2
	beq tape_head_align_loop_1



tape_head_align_quit:

	// It makes no sense to return to system, as we already destroyed
	// a lot of memory; fust clear initial BASIC text area to prevent
	// data recovery attempts, and reset

	ldx #$00
	txa
!:
	sta $0800, x
	inx
	bne !-

	jmp hw_entry_reset



tape_head_align_apply_gfx:

	// Apply GFX effects XXX improve it

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

	lda #%00010000
	ora __ha_chart + 7 + 8 * 1
	sta __ha_chart + 7 + 8 * 1

	lda #%00001000
	ora __ha_chart + 7 + 8 * 30
	sta __ha_chart + 7 + 8 * 30

	// For normal  XXX check values

	lda #%00000100
	ora __ha_chart + 7 + 8 * 6
	sta __ha_chart + 7 + 8 * 6

	lda #%00010000
	ora __ha_chart + 7 + 8 * 13
	sta __ha_chart + 7 + 8 * 13

	// For turbo   XXX check values

	lda #%01000000
	ora __ha_chart + 7 + 8 * 21
	sta __ha_chart + 7 + 8 * 21
!:
	rts


#endif // ROM layout


#endif // CONFIG_TAPE_HEAD_ALIGN
