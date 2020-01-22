// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Tape (normal) helper routine - data block reading
//
// Stores data starting from MEMUSS, Carry set means error, on 0 bit .A is 0 too
// .Y not equal to 0 - returns error if data block is longer (length includes checksum)


// XXX improve error handling - do not ignore second copy, handle damaged sync part


#if CONFIG_TAPE_NORMAL


tape_normal_get_data:

	// Initialize checksum (RIPRTY, see http://sta.c64.org/cbm64mem.html)
	// and pointers for error log and correction mechanism
	lda #$00
	sta RIPRTY
	sta PTR1
	sta PTR2

	// FALLTROUGH

tape_normal_get_data_block_1:

	//
	// Read the 1st copy of the block
	//

	// Read sync of the block
	ldy #$89
	jsr tape_normal_sync
	bcs tape_normal_get_data_fail
	jsr tape_normal_get_marker

tape_normal_get_data_loop_1:

	jsr tape_normal_get_byte
	bcc tape_normal_get_data_loop_1_byte_OK
	
	// Problem reading a byte, try to add it to the error log

	tsx
	cpx #$20                           // just to be on a safe side
	bcc tape_normal_get_data_fail      // branch if no more space in error log

	ldx PTR1
	lda MEMUSS+0
	sta STACK, x
	inx
	lda MEMUSS+1
	sta STACK, x
	inx
	sta PTR1 

	// Addres added to error log, check if this was a checksum
	jsr tape_normal_get_marker
	bcc tape_normal_get_data_loop_1_advance
	bcs tape_normal_get_data_block_2


tape_normal_get_data_loop_1_byte_OK:

	jsr tape_normal_get_marker
	bcc !+

	// End of the block
	jsr tape_normal_update_checksum
	jmp tape_normal_get_data_block_2

!:
	// Store byte, calculate checksum
	lda INBIT
	ldy #$00
	sta (MEMUSS), y
	jsr tape_normal_update_checksum
	
	// FALLTROUGH

tape_normal_get_data_loop_1_advance:

	// Advance pointer
#if !HAS_OPCODES_65CE02
	jsr lvs_advance_MEMUSS
#else
	inw MEMUSS+0
#endif

	jmp tape_normal_get_data_loop_1


tape_normal_get_data_block_2:

	//
	// Read the 2nd copy of the block
	//

	// First check if there is a need to read anything

	// XXX

	// Read sync of the block
	ldy #$09
	jsr tape_normal_sync
	bcs tape_normal_get_data_fail
	jsr tape_normal_get_marker

	// XXX implement the second pass


	lda PTR1
	beq tape_normal_get_data_checksum

	jmp tape_normal_get_data_fail




tape_normal_get_data_checksum:

	lda RIPRTY
	cmp #$01                           // sets Carry if checksum verification fails

	// FALLTROUGH

tape_normal_get_data_done:

	rts

tape_normal_get_data_fail:

	sec
	rts


#endif
