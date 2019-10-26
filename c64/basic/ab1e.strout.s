// Print string at $YYAA
// Compute's Mapping the 64 p101

// print string routine

STROUT:
	// Setup pointer
	sty FRESPC+1
	sta FRESPC+0
	
	phx_trash_a

	// Get offset ready
	ldy #$00
!:
	// Save Y in X, since X is preserved by chrout, but Y is not
	tya
	tax

	lda (FRESPC),y
	beq !+

	jsr JCHROUT

	txa
	tay

	iny
	bne !-
!:
	pla // XXX can we use plx_trash_a here?
	tax
	rts
