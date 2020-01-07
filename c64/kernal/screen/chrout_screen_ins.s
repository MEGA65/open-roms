
//
// CHROUT routine - screen support, INS key handling
//


// YYY does not work properly on growing logical line
// YYY implement LNMX


chrout_screen_INS:

	// First check if last character of the line is space
	
	jsr screen_check_space_ends_line
	beq chrout_screen_ins_possible

	// Not space, try to grow logical line and check once again

	jsr screen_grow_logical_line
	jsr screen_check_space_ends_line
	bne_far chrout_screen_done
	
	// FALLTROUGH

chrout_screen_ins_possible:

	// Move chars towards end of the line
	jsr screen_get_logical_line_end_ptr
!:
	// Note: While the following routine is obvious to any skilled
	// in the art as the most obvious simple and efficient solution,
	// if the screen writes are before the colour writes, it results
	// in a relatively long verbatim stretch of bytes when compared to
	// the C64 KERNAL.  Thus we have swapped the order, just to reduce
	// the potential for any argument of copyright infringement, even
	// though we really do not believe that the routine can be copyrighted
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
	sta (PNT), y

	jmp chrout_screen_done
