
//
// Simple text mode head alignment tool
//

// XXX this is experimental only - make it useable!


#if CONFIG_HEAD_FIT_TOOL


head_fit:
	
	// Start by disabling interrupts and preparing screen

	sei
	jsr clear_screen

	// Now we need to create screen pointers on zero page, we can safely reuse some BASIC variables
	// The 6 vectors below completely fills variables: TEMPPT, LASTPT, TEMPST

	.var HF_SCREEN_PTR1_A = TEMPPT+0  // $16-$17
	.var HF_SCREEN_PTR1_B = TEMPPT+2  // $18-$19
	.var HF_SCREEN_PTR2_A = TEMPPT+4  // $1A-$1B
	.var HF_SCREEN_PTR2_B = TEMPPT+6  // $1C-$1D
	.var HF_SCREEN_PTR3_A = TEMPPT+8  // $1E-$1F
	.var HF_SCREEN_PTR3_B = TEMPPT+10 // $20-$21

	ldx #11
!:
	lda head_fit_ptr_table, x
	clc
	adc HIBASE
	sta HF_SCREEN_PTR1_A, x

	dex
	lda head_fit_ptr_table, x
	sta HF_SCREEN_PTR1_A, x

	dex
	bpl !-

	// Reuse BASIC variable for Normal/Turbo switching

	.var HF_IS_TURBO = RESHO+0

	inx                                // puts 0 into .X
	sta HF_IS_TURBO

	// Setup CIA #2 timers (this will provide desired resolution), start motor

	jsr head_fit_setup_timers
	jsr tape_motor_on

	// Again, reuse 3 BASIC variables

	.var HF_TMP         = RESHO+1
	.var HF_SCROLL_CNT  = RESHO+2
	.var HF_RASTER_MARK = RESHO+3

	// FALLTROUGH

head_fit_loop:

	// Store raster mark

	lda VIC_SCROLY
	and #%10000000
	sta HF_RASTER_MARK

	lda #$80
	sta HF_SCROLL_CNT

	jsr tape_normal_get_pulse          // ignore this pulse - too much time passed

head_fit_loop_inner:

	jsr tape_normal_get_pulse

	// Normalize pulse length value to 0-79
	sec
	adc #$08

	sta HF_TMP
	lda #$FF
	sec
	sbc HF_TMP

	cmp #80
	bcc !+
	lda #79
!:

	// Display value

	tax

	clc
	ror
	tay                                // .Y now contains character offset

	lda (HF_SCREEN_PTR1_A), y
	cmp #$A0                           // is inversed space?
	beq head_fit_char_displayed        // if so, do not display anything
	cmp #$20
	bne !+
	lda #$00
	beq head_fit_store_bits
!:
	cmp #$61
	bne !+
	lda #$01
	bne head_fit_store_bits
!:
	// Has to be #$E1
	lda #$02

	// FALLROUGH

head_fit_store_bits:

	sta HF_TMP

	txa
	and #$01
	asl
	bne !+
	lda #$01
!:                                     // .A is now %10 or %01 - depending on the desired pulse position
	ora HF_TMP
	tax                                // .X contains now character index, 0-4

	lda head_fit_gfx_table, x
	sta (HF_SCREEN_PTR1_A), y

head_fit_char_displayed:

	// Check whether to decrement scroll countdown

	lda VIC_SCROLY
	and #%10000000                     // retrieve highest bit of raster
	cmp HF_RASTER_MARK
	beq head_fit_loop_inner

	// Decrement scroll countdown

	dec HF_SCROLL_CNT
	bne head_fit_loop_inner

	// Scan keys

	jsr udtim_keyboard
	lda STKEY
	bmi !+ 

	// Stop pressed - quit

	jsr tape_motor_off
	jsr clear_screen
	cli
	rts
!:
	// If space, toggle system

	cmp #$EF
	bne !+
	jsr head_fit_switch_system
!:
	// Scroll down the screen

	ldy #240
!:
	lda (HF_SCREEN_PTR3_A), y
	sta (HF_SCREEN_PTR3_B), y

	lda (HF_SCREEN_PTR2_A), y
	sta (HF_SCREEN_PTR2_B), y

	lda (HF_SCREEN_PTR1_A), y
	sta (HF_SCREEN_PTR1_B), y

	dey
	cpy #$FF
	bne !-

	// Clear the first line

	lda #$20
	ldy #39
!:
	sta (HF_SCREEN_PTR1_A), y
	dey
	cpy #$FF
	bne !-

	// Continue

	jmp head_fit_loop


#endif // CONFIG_HEAD_FIT_TOOL
