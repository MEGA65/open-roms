// #LAYOUT# STD *        #TAKE
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape head alignemnt tool
//


#if CONFIG_TAPE_HEAD_ALIGN


.label __ha_start       = 12           // starting row of the chart
.label __ha_rows        = 11           // number of rows for scrolling

// Helper tables

.label __ha_offsets     = $1000;
.label __ha_masks       = $1100;

// Generated code location

.label __ha_scroll      = $1300;

// Flag for GFX effects - reuse BASIC numeric work area on zero page

.label __ha_gfxflag     = TEMPF2;       // 1 byte


tape_head_align:

	// Make sure user really wants to launch the tool

	jsr tape_ask_play

	// Disable interrupts, set proper I/O values

	jsr CLALL

	sei

	jsr IOINIT
	// jsr CINT

	jsr nmi_lock

	// Prepare CIA timers

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

	// Print help message

	jsr tape_head_align_print_help

	// Make sure the row where the chart is being created is not visible

	lda #(CONFIG_COLOR_TXT * $10 + CONFIG_COLOR_TXT)
	ldy #$24
!:
	sta $0800 + __ha_start * 40 + 1, y
	sta $0800 + __ha_start * 40 + 1 + (__ha_rows + 1) * 40, y
	
	dey
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

	stx __ha_gfxflag                   // .X is 0 at this moment

	// Generate helper code for screen scrolling

	jsr tape_head_align_gen_code

	// Provide new IRQ routine address

	lda #<tape_head_align_irq
	sta CINV+0
	lda #>tape_head_align_irq
	sta CINV+1

	// Setup raster interrupt routine - see https://www.c64-wiki.com/wiki/Raster_interrupt

	lda #%01111111                     // prevent CIA from generating interrupts
	sta CIA1_ICR   // $DC0D

 	and VIC_SCROLY                     // clear the highest bit of RASTER 
	sta VIC_SCROLY // $D011

 	lda #$FB                           // we want no badlines during the interrupt, this raster is 100% safe
	sta VIC_RASTER

 	lda #%00000001                     // enable raster interrupts
	sta VIC_IRQMSK // $D01A
	cli

tape_head_align_loop_1:

	// Check for STOP key

	jsr udtim_keyboard
	jsr STOP
	bcs tape_head_align_quit

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

	// Draw decorations

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
	// FALLTROUGH

tape_head_align_loop_2:

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


#endif // CONFIG_TAPE_HEAD_ALIGN
