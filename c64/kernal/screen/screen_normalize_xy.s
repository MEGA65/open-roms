
//
// Normalise X and Y values
// If X < 0, then make X = X + 40 (or 80, if previous line is linked)
//

/* YYY disabled for rework

screen_normalize_xy:	

	lda PNTR
	bpl x_not_negative
	dec TBLX
	// Check that we didn't go backwards off the top of the screen
	bpl !+
	lda #0
	sta TBLX

!:	jsr screen_add_40_to_PNTR

	// Check if line is linked, if so, add 40 again
	ldy TBLX
	lda LDTBL,y
	bpl !+
	jsr screen_add_40_to_PNTR
!:

x_not_negative:
	// Work out if X is too big
	ldy TBLX
	lda LDTBL,y
	bpl !+
	lda #79
	skip_2_bytes_trash_nvz
!:	lda #39
	cmp PNTR
	bcs x_not_too_big

	// X value is too big, so subtract 40 and increment Y
	lda PNTR
	sec
	sbc #40
	sta PNTR
	inc TBLX

x_not_too_big:

	// Make sure Y isn't negative
	lda TBLX
	bpl !+
	lda #0
	sta TBLX
!:
	// Make sure Y isn't too large for absolute size of
	// screen
	cmp #24
	bcc !+
	lda #24
	sta TBLX
!:
	// Make sure Y isn't too much for the screen, taking
	// into account the line link table
	ldy #24 		// max allowable line
	ldx #0
link_count_loop:
	lda LDTBL,x
	bpl !+
	dey
!:	inx
	cpx #25
	bne link_count_loop
	tya
	cmp TBLX
	bcs y_ok
	sta TBLX
y_ok:
	rts

*/