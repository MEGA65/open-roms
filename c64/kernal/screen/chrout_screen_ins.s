
//
// CHROUT routine - screen support, INS key handling
//

chrout_screen_ins:

	// Insert (shift-DELETE)
	
	// Abort if line already max length, ie 79th char is not a space
	jsr screen_get_current_line_logical_length
	cmp #79
	bne !+
	tay
	lda (PNT),y
	cmp #$20
	beq !+

	// Line is too long to extend
	jmp chrout_done

!:
	// Work out if line needs to be expanded, and if so expand it
	ldy #39
	lda (PNT),y
	cmp #$20
	beq !+

	jsr screen_grow_logical_line
	
!:	
	// Shuffle chars towards end of line
	jsr screen_get_current_line_logical_length
	tay
!:
	// Note: While the following routine is obvious to any skilled
	// in the art as the most obvious simple and efficient solution,
	// if the screen writes are before the colour writes, it results
	// in a relatively long verbatim stretch of bytes when compared to
	// the C64 KERNAL.  Thus we have swapped the order, just to reduce
	// the potential for any argument of copyright infringement, even
	// though we really don't believe that the routine can be copyrighted
	// due to the lack of creativity.
	dey
	lda (USER),y
	iny
	sta (USER),y
	dey
	lda (PNT),y
	iny
	sta (PNT),y

	dey
	cpy PNTR
	bne !-

	// Increase insert mode count (which causes quote-mode like behaviour)
	inc INSRT

	// Put space in the inserted gap
	lda #$20
	sta (PNT),y

	jmp chrout_done
