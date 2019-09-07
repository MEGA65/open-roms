
//
// Official Kernal routine, described in:
//
// - [RG64] C64 Programmer's Reference Guide   - page 283
// - [CM64] Compute's Mapping the Commodore 64 - page 227/228
//
// CPU registers that has to be preserved (see [RG64]): .X, .Y
//

// XXX currently does not preserve registers, to be fixed!

GETIN:

	// Wait for a key
	lda keys_in_key_buffer
	bne !+

	// Nothing in keyboard buffer to read
	sec
	lda #$00
	rts
	
!:
	lda keyboard_buffer
	pha

	jsr pop_keyboard_buffer

	pla
	clc

	rts
