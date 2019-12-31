
/* YYY disabled for rework

screen_calculate_line_pointer:
	jsr screen_normalize_xy
	
	//  Reset pointer to start of screen
	lda HIBASE
	sta PNT+1
	lda #0
	sta PNT+0

	// Add 40 for every line, or 80 if the lines are linked
	ldx TBLX

!:
	// Stop if we have counted enough lines
	beq !+

	// Add 40 or 80 based on whether the line is linked
	// or not.
	ldy #40
	// -1 offset is because we count down from N to 1, not
	// N-1 to 0.
	lda LDTBL-1,x
	bpl sclp_l1
	ldy #80
sclp_l1:
	// Add computed line length to pointer value
	tya
	clc
	adc PNT+0
	sta PNT+0
	lda PNT+1
	adc #0
	sta PNT+1
	
	// Loop back to next line
	dex
	jmp !-
!:

	// FALLTHROUGH

update_colour_line_pointer:
	// Now setup pointer to colour RAM
	lda PNT+0
	sta USER+0
	lda PNT+1
	sec
	sbc HIBASE
	clc
	adc #>$d800
	sta USER+1

	rts
*/