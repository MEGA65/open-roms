
//
// Tape (normal) helper routine - block reading
//
// Stores data starting from MEMUSS, Carry set means error, on 0 bit .A is 0 too
//


// XXX does not detect block end - find out why
// XXX improve error handling - do not ignore second copy, handle damaged checksum byte, handle damaged sync part


tape_normal_get_block:

	// Read the pilot and sync of the block

	jsr tape_normal_pilot
	ldy #$89
	jsr tape_normal_sync // XXX handle result
	
	// Initialize byte counter and block checksum (RIPRTY, see http://sta.c64.org/cbm64mem.html)
	ldy #$00
	sty RIPRTY

tape_normal_get_block_loop:

	jsr tape_normal_get_marker
	bcs tape_normal_get_block_checksum // end of data for the block
	jsr tape_normal_get_byte

	bcs tape_normal_get_block_done     // error reading byte - fatal for now

	// Store byte, calculate checksum
	sta (MEMUSS), y
	eor RIPRTY
	sta RIPRTY
	
	iny
	bne tape_normal_get_block_loop

	// FALLTROUGH - if we are here, it means the block is too long
	
tape_normal_get_block_done_fail:
	
	sec
	rts

tape_normal_get_block_checksum:
.break
	jsr tape_normal_get_byte
	bcs tape_normal_get_block_done     // cannot get block checksum - fatal for now

	eor RIPRTY
	cmp #$01
	bcs tape_normal_get_block_done     // checksum error - fatal for now

	// Read trailing pulses
	
	jsr tape_normal_sync // XXX handle result
	
	// Read the pilot and sync of the backup block

	jsr tape_normal_pilot
	ldy #$09
	jsr tape_normal_sync // XXX handle result
	
	// For now we ignore the backup block
	clc

	// FALLTROUGH

tape_normal_get_block_done:

	rts
