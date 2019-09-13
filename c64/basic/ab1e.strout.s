// Print string at $YYAA
// Compute's Mapping the 64 p101

// print string routine

STROUT:
	// Setup pointer
	sty temp_string_ptr+1
	sta temp_string_ptr+0

	txa	
	pha

	// Get offset ready
	ldy #$00
!:
	// Save Y in X, since X is preserved by chrout, but Y is not
	tya
	tax

	lda (temp_string_ptr),y
	beq !+

	jsr JCHROUT

	txa
	tay

	iny
	bne !-
!:
	pla
	tax
	rts
