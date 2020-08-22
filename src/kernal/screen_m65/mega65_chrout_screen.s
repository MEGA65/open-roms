// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// CHROUT routine - screen support (character output), MEGA65 native mode version
//


m65_chrout_screen:

	// XXX hide cursor if visible

	lda SCHAR
	tax

	// All the PETSCII control codes are within $0x, $1x, $8x, $9x, remaining
	// ones are always printable characters; separate away control codes

	and #$60
	beq_16 m65_chrout_screen_control
	txa

	// Literals - first convert PETSCII to screen code

	jsr chrout_to_screen_code

	// FALLTROUGH

m65_chrout_screen_literal: // entry point for m65_chrout_screen_quote

	// Write normal character on the screen

	tax                                // store screen code, we need .A for calculations

	// Preserve .Z on stack, use it toi store screen columnt

	phz
	ldz M65__TXTCOL

	// Start from setting M65_LPNT_SCR to point colour memory (starts from $FF80000)

	lda #$0F
	sta M65_LPNT_SCR+3
	lda #$F8
	sta M65_LPNT_SCR+2

	lda M65_COLVIEW+1
	sta M65_LPNT_SCR+1
	lda M65_COLVIEW+0
	sta M65_LPNT_SCR+0

	// Add screen row to the address

	ldy M65__TXTROW
	clc
	lda m65_scrtab_rowoffset_lo,y
	adc M65_LPNT_SCR+0
	sta M65_LPNT_SCR+0	
	lda m65_scrtab_rowoffset_hi,y
	adc M65_LPNT_SCR+1
	sta M65_LPNT_SCR+1	

	// Store the new color in screen memory

	lda COLOR
	sta_lp (M65_LPNT_SCR),z

	// Now change M65_LPNT_SCR to point to screen memory

	// XXX deduplicate this part
	lda M65_SCRSEG+1
	sta M65_LPNT_SCR+3
	lda M65_SCRSEG+0
	sta M65_LPNT_SCR+2

	clc
	lda M65_SCRBASE+0
	adc M65_LPNT_SCR+0
	sta M65_LPNT_SCR+0
	lda M65_SCRBASE+1
	adc M65_LPNT_SCR+1
	sta M65_LPNT_SCR+1

	// Store the new character in screen memory, restore .Z

	txa
	sta_lp (M65_LPNT_SCR),z
	plz

	// Increment screen column by 1

	inc M65__TXTCOL

	// XXX continue the implementation - fix the cursor position

m65_chrout_screen_done:

	// XXX reenable cursor

	rts
