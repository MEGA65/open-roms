
//
// Helper functions for various LOAD/VERIVY/SAVE routine variants (IEC / U64 / etc.)
//

lvs_send_file_name:
	ldy #0
lvs_send_file_name_loop:
	cpy FNLEN
	beq lvs_send_file_name_done
	ldx #<current_filename_ptr
	jsr peek_under_roms
	iny
	// Set Carry flag on the last file name character, to mark EOI
	cpy FNLEN
	clc
	bne !+
	sec
!:
	// Transmit one character
	sta IEC_TMP2
	jsr iec_tx_byte
	jmp lvs_send_file_name_loop
lvs_send_file_name_done:
	jsr UNLSN
	rts

lvs_handle_byte_load_verify:

	// XXX add VERIFY support

	// Save it and advance pointer.
	// As with our BASIC, we want to enable LOADing
	// anywhere in memory, including over the IO space.
	// Thus we have to use a helper routine in low memory
	// to do the memory access

	// Save byte under ROMs and IO if required
	php
	sei
	// XXX behavior should depend on address
	ldx #$33
	stx $01
	ldy #0
	sta (STAL),y
	ldx #$37
	stx $01
	plp
	rts

lvs_advance_pointer:
	// Advance pointer
	inc STAL
	beq !+
	jmp lvs_success_end
!:
	inc STAL+1
	// If we wrap around to $0000, then this is bad.
	bne !+
	jmp lvs_error_end
!:
	clc
	rts

lvs_display_searching_for:
	lda MSGFLG
	bpl lvs_display_end
	jsr printf // XXX don't use printf, use packed message
	.byte $0D
	.text "SEARCHING FOR "
	.byte 0
	ldy #$00
!:
	cpy FNLEN
	beq lvs_display_end
	ldx #<current_filename_ptr
	jsr peek_under_roms
	jsr JCHROUT
	iny
	jmp !-

lvs_display_end:
	rts

lvs_display_loading_verifying:
	// Display LOADING / VERIFYING and start address
	lda MSGFLG
	bpl lvs_display_end
	lda VERCK
	beq !+
	jsr printf // XXX don't use printf, use packed message
	.byte $0D
	.text "VERIFYING"
	.byte 0
	jmp lvs_display_start_addr
!:
	jsr printf // XXX don't use printf, use packed message
	.byte $0D
	.text "LOADING"
	.byte 0
	// FALLTHROUGH

lvs_display_start_addr:
	jsr printf // XXX don't use printf, use packed message
	.text " FROM $"
	.byte 0
	lda STAL+1
	jsr printf_printhexbyte
	lda STAL+0
	jmp printf_printhexbyte

lvs_display_done:
	// Display end address
	lda MSGFLG
	bpl lvs_display_end
	jsr printf // XXX don't use printf, use packed message
	.text " TO $"
	.byte 0
	lda STAL+1
	jsr printf_printhexbyte
	lda STAL+0
	jsr printf_printhexbyte
	lda #$0D
	jmp JCHROUT

lvs_wrap_around_error:
	// This error is probably not even detected by C64 Kernal;
	// report BASIC error code that looks the most sane
	lda #B_ERR_OVERFLOW
lvs_error_end:
	sec
	rts

lvs_return_last_address:
	// Return last address - Compute's Mapping the 64 says without the '+1',
	// checked (short test program) on original ROMs that this is really the case
	ldx STAL+0
	ldy STAL+1
	// FALLTHROUGH

lvs_success_end:
	clc
	rts

lvs_device_not_found_error:

	jsr kernalstatus_DEVICE_NOT_FOUND
	jmp kernalerror_DEVICE_NOT_FOUND

lvs_illegal_device_number:

	jsr kernalstatus_DEVICE_NOT_FOUND
	jmp kernalerror_ILLEGAL_DEVICE_NUMBER

.label lvs_file_not_found_error = kernalerror_FILE_NOT_FOUND

lvs_load_verify_error:
	// XXX should we really return BASIC error code here?
	lda VERCK
	bne lvs_verify_error
	lda #B_ERR_LOAD
	bne lvs_error_end
	// FALLTHROUGH

lvs_verify_error:
	lda #B_ERR_VERIFY
	sec
	rts
