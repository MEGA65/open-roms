

screen_advance_to_next_line:
.break
	rts

/* YYY disabled for rework

	//  Go to start of line
	lda #0
	sta PNTR
	//  Advance line number
	ldy TBLX

	// Do quick fix to line pointer to work out if it is off
	// the bottom of the screen.
	ldx #40
	lda LDTBL,y
	bmi !+
	.byte $2c
!:	ldx #80
	txa
	clc
	adc PNT+0
	sta PNT+0
	lda PNT+1
	adc #0
	sta PNT+1

	inc TBLX

	// Check if it will trigger scrolling
	// Work out if we have gone off the bottom of the screen?
	// 1040 > 1024, so if high byte of screen pointer is >= (HIBASE+4),
	// then we are off the bottom of the screen
	lda PNT+1
	sec
	sbc HIBASE
	cmp #3
	bcc !+
	lda PNT+0
	cmp #$e7
	bcc !+

	// Off the bottom of the screen
	jsr scroll_screen_up	
!:

	jmp chrout_screen_calc_lptr_done

*/
