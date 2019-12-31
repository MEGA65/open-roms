
/* YYY disabled for rework

not_last_line:
	rts

screen_scroll_up_if_on_last_line:

	// Colour RAM is always in fixed place, so is easiest
	// to use to check if we are on the last line.
	// The last line is at $D800 + 24*40 = $DBC0
	lda USER+1
	cmp #>$DBC0
	bne not_last_line

	lda USER+0
	cmp #<$DBC0
	beq is_last_line

	jsr screen_get_current_line_logical_length
	clc
	adc USER+0
	cmp #<$DBE7-1
	bcc not_last_line

is_last_line:

	dec TBLX

	// FALLTHROUGH

scroll_screen_up:

	// Preserve EAL
	lda EAL+0
	pha
	lda EAL+1
	pha	

	// Now scroll the whole screen up either one or two lines
	// based on whether the first screen line is linked or not.

	// Get pointers to start of screen + colour RAM
	lda HIBASE
	sta PNT+1
	sta SAL+1
	lda #>$D800
	sta USER+1
	sta EAL+1
	lda #$00
	sta PNT+0
	sta USER+0
	
	//  Get pointers to screen/colour RAM source
	lda LDTBL+0
	bmi !+
	lda #40
	.byte $2C 		// BIT $nnnn to skip next instruction
!:
	lda #80
	sta SAL+0
	sta EAL+0

	//  Copy first three pages
	ldy #$00
	ldx #3
scroll_copy_loop:
	lda (EAL),y
	sta (USER),y
	lda (SAL),y
	sta (PNT),y

	iny
	bne scroll_copy_loop

	inc SAL+1
	inc PNT+1
	inc EAL+1
	inc USER+1
	dex
	bne scroll_copy_loop

	// Copy last partial page
	// We need to copy 1000-(3*256)-line length
	// = 232 - line length
	lda SAL+0
	lda #232
	sec
	sbc SAL+0
	tax
scroll_copy_loop2:
 	lda (EAL),y
 	sta (USER),y
 	lda (SAL),y
 	sta (PNT),y
 	iny
 	dex
 	bne scroll_copy_loop2

 	// Restore EAL
 	pla
 	sta EAL+1
 	pla
 	sta EAL+0

	// Fill in scrolled up area
	ldx SAL+0
scroll_copy_loop3:
	lda COLOR
	sta (USER),y
	lda #$20
	sta (PNT),y
	iny
	dex
	bne scroll_copy_loop3

	// Shift line linkage list
	ldy #0
	ldx #24
link_copy:
	lda LDTBL+1,y
	sta LDTBL+0,y
	iny
	dex
	bne link_copy
	// Clear line link flag of last line
	stx LDTBL+24

	// Restore correct line pointers
	jmp screen_calculate_line_pointer
*/