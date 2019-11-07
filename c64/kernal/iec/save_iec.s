
//
// IEC part of the SAVE routine
//


// XXX this is untested!
// test EAL/STAL - LOAD (tape, disk), SAVE - Open ROMs vs hybrid vs original



#if CONFIG_IEC


save_iec_dev_not_found:
	jmp lvs_device_not_found_error

save_iec_error:
	jmp lvs_device_not_found_error // XXX find a better error


save_iec:

	// Check file name
	lda FNLEN
	beq_far kernalerror_FILE_NAME_MISSING

	// Display SAVING
	jsr lvs_display_saving

	// Call device to LISTEN
	lda FA
	jsr LISTEN
	bcs save_iec_dev_not_found

	// Open channel 1 (reserved for file writing)
	lda #$01
	jsr iec_cmd_open
	bcs save_iec_dev_not_found

	// Send file name
	jsr iec_send_file_name
	bcs save_iec_error

	// Call device to LISTEN once again
	lda FA
	jsr LISTEN
	bcs save_iec_dev_not_found

	lda #$61 // open channel / data (p3) , required according to p13
	sta TBTCNT
	jsr iec_tx_command
	bcs save_iec_error

	// Save start address    XXX optimize this
	lda STAL+0
	sta TBTCNT
	clc
	jsr iec_tx_byte

	lda STAL+1
	sta TBTCNT
	clc
	jsr iec_tx_byte

	ldy #$00
iec_save_loop:

	// Retrieve byte to send
#if CONFIG_MEMORY_MODEL_60K
	ldx #<STAL+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (STAL),y
#endif

	// Check if end of saving
	ldx STAL+0
	cpx EAL+0
	bne !+
	ldx STAL+1
	cpx EAL+1
	beq iec_save_loop_end
!:
	// Send the byte and do next iteration
	sta TBTCNT
	clc
	jsr iec_tx_byte
	jsr lvs_advance_pointer
	jmp iec_save_loop

iec_save_loop_end:

	// Send last byte 
	sta TBTCNT
	clc                   // XXX really?
	jsr iec_tx_byte

	// Close file on drive      // XXX does not work properly
	lda FA
	jsr UNLSN

	lda FA
	jsr LISTEN

	lda #$E1 // CLOSE command
	sta TBTCNT
	jsr iec_tx_command
	jsr iec_tx_command_finalize

	// Tell drive to unlisten
	lda FA
	jsr UNLSN


	// Return success
	clc
	rts


#endif // CONFIG_IEC
