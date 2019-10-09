	// Put the address of the screen current line
	// into the pointer at $D1 (PNT).
	// It must take into account the screen line link table
	// (Compute's Mapping the 64 p216)

screen_set_pointer_to_current_line:
	//  Get pointer to start of the screen
	lda HIBASE
	sta PNT+1
	lda #$00
	sta PNT+0

	// Now advance for the number of lines
	ldx TBLX

sptcl_l2:
	// XXX - Should we read the columns per line from
	// somewhere?
	ldy #<40
	// Double line length if line is linked
	lda LDTBL,x
	bpl sptcl_l1
	ldy #<80
sptcl_l1:
	tya
	clc
	adc PNT+0
	lda PNT+1
	adc #>40
	sta PNT+1

	dex
	bpl sptcl_l2
	
	rts
