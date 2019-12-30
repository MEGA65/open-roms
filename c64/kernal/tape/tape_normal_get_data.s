
//
// Tape (normal) helper routine - data block reading
//
// Stores data starting from MEMUSS, Carry set means error, on 0 bit .A is 0 too
// .Y not equal to 0 - returns error if data block is longer (length includes checksum)


// XXX improve error handling - do not ignore second copy, handle damaged sync part


#if CONFIG_TAPE_NORMAL


tape_normal_get_data:

	// Store block size limit
	sty XSAV

	// Initialize checksum (RIPRTY, see http://sta.c64.org/cbm64mem.html)
	lda #$00
	sta RIPRTY

	// Read the pilot and sync of the block
	ldy #$89
	jsr tape_normal_sync
	bcs tape_normal_get_block_done     // XXX make it more error resistant
	jsr tape_normal_get_marker

tape_normal_get_data_loop:

	jsr tape_normal_get_byte
	bcs tape_normal_get_block_done     // error reading byte - fatal for now
	jsr tape_normal_get_marker
	bcs tape_normal_get_checksum       // end of data for the block

	// Store byte, calculate checksum
	lda INBIT
	ldy #$00                           // XXX probably can be optimized out for 65C02
	sta (MEMUSS), y
	eor RIPRTY
	sta RIPRTY
	
	// Advance pointer
#if !HAS_OPCODES_65CE02
	jsr lvs_advance_MEMUSS
#else
	inw MEMUSS+0
#endif

	// Check block length limit
	lda XSAV
	beq tape_normal_get_data_loop      // no limit requested
	dec XSAV
	bne tape_normal_get_data_loop

	sec
	rts

tape_normal_get_checksum: // XXX handle second copy, with pilot starting from $09

	lda INBIT
	eor RIPRTY
	cmp #$01                           // sets Carry if checksum verification fails

	// FALLTROUGH

tape_normal_get_block_done:

	rts


#endif
