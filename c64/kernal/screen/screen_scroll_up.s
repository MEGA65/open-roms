
//
// Scroll the whole screen up by 1 logical line
//


screen_scroll_up:

	// Preserve SAL and EAL

	lda SAL+0
	pha
	lda SAL+1
	pha	
	lda EAL+0
	pha
	lda EAL+1
	pha	

screen_scroll_up_next:

#if CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C65

	// Do not scroll if NO_SCRL is pressed and interrupts are enabled
!:
	php
	pla
	and #%00000010
	bne !+                             // branch if IRQs disabled, we cannot detect NO_SCRL status

	lda SHFLAG
	and #KEY_FLAG_NO_SCRL
	bne !-
!:
#endif

	// Check if CTRL key pressed - if so, perform a delay

	lda SHFLAG
	and #KEY_FLAG_CTRL
	beq screen_scroll_up_delay_done

	ldy #$03
!:
	ldx #$FF
	jsr wait_x_bars
	dey
	bne !-

screen_scroll_up_delay_done:

	// First scroll the LDTBL (line link table)

	ldy #$00
!:
	lda LDTBL+1, y
	sta LDTBL+0, y
	iny
	cpy #24
	bne !-

	lda #$80
	sta LDTBL+24

	// Now, we need to scroll both screen memory and color memory



	// YYY implement




	// Clear the newly introduced line

	ldx #24
	jsr screen_clear_line

	// Decrement the current physical line number

	dec TBLX

	// If the first line is linked, scroll once more

	bit LDTBL+0
	bpl screen_scroll_up_next

	// Restore SAL and EAL
	
 	pla
 	sta EAL+1
 	pla
 	sta EAL+0
 	pla
 	sta SAL+1
 	pla
 	sta SAL+0

 	// Return

	rts






/* YYY disabled for rework, add CTRL and NO_SCROLL support

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

	// FALLTHROUGH to screen_scroll_up



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