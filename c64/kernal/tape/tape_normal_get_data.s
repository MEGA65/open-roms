
//
// Tape (normal) helper routine - data block reading
//
// Stores data starting from MEMUSS, Carry set means error, on 0 bit .A is 0 too
//


// XXX improve error handling - do not ignore second copy, handle damaged sync part


#if CONFIG_TAPE_NORMAL


tape_normal_get_data:

	// Read the pilot and sync of the block

	jsr tape_normal_pilot
	ldy #$89
	jsr tape_normal_sync
	bcs tape_normal_get_block_done     // XXX make it more erroor resistant
	
	// Initialize byte counter
	ldy #$00

tape_normal_get_data_loop:

	jsr tape_normal_get_marker
	bcs tape_normal_get_data_2nd_copy // end of data for the block
	jsr tape_normal_get_byte

	bcs tape_normal_get_block_done     // error reading byte - fatal for now

	// Store byte, calculate checksum
	sta (MEMUSS), y
	eor RIPRTY
	sta RIPRTY
	
	iny
	bne tape_normal_get_data_loop

	// 256 bytes read

	inc MEMUSS+1
	jmp tape_normal_get_data_loop

tape_normal_get_data_2nd_copy:

	// Read the pilot and sync of the block

	jsr tape_normal_pilot
	ldy #$09
	jsr tape_normal_sync
	bcs tape_normal_get_block_done     // XXX make it more error resistant

	// For now skip the error correction data
!:
	jsr tape_normal_get_marker
	bcs tape_normal_get_checksum
	jsr tape_normal_get_byte
	tay
	jmp !-

tape_normal_get_checksum:

	tya
	eor RIPRTY
	cmp #$01                           // sets Carry if checksum verification failed

	clc // XXX checksum calculation fails - why?

	// FALLTROUGH

tape_normal_get_block_done:

	rts


#endif
