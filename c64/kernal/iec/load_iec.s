
//
// IEC part of the LOAD routine
//


#if CONFIG_IEC


load_iec_dev_not_found:
	jmp lvs_device_not_found_error

load_iec_file_not_found:
	jmp kernalerror_FILE_NOT_FOUND

load_iec_error:
	lda FA
	jsr iec_close_load
	jmp lvs_load_verify_error 

load_break_error:
	pla
	lda FA
	jsr iec_close_load
	jmp kernalerror_ROUTINE_TERMINATED 


load_iec:

	// Display SEARCHING FOR + filename
	jsr lvs_display_searching_for

	// http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	// p13, 16; also p16 tells us this routine does not mess with the file
	// table in the C64, only in the drive.

	// Call device to LISTEN (p16)
	lda FA
	jsr LISTEN
	bcs load_iec_dev_not_found

	// Open channel 0 (reserved for file reading)
	lda #$00
	jsr iec_cmd_open
	bcs load_iec_dev_not_found

	// Send file name
	jsr iec_send_file_name
	bcs load_iec_error

	// Now command device to talk (p16)
	lda FA
	jsr TALK
	bcs load_iec_error

	lda #$60 // open channel / data (p3) , required according to p13
	sta TBTCNT
	jsr iec_tx_command
	bcs load_iec_error

	// We are currently talker, so do the IEC turn around so that we
	// are the listener (p16)
	jsr iec_turnaround_to_listen
	bcs load_iec_error

	// Get load address and store it if secondary address is zero
	jsr iec_rx_byte
	bcs load_iec_file_not_found

	ldx SA
	beq !+
	sta STAL+0
!:
	jsr iec_rx_byte
	bcs load_iec_file_not_found

	ldx SA
	beq !+
	sta STAL+1
!:
	// Display start address
	jsr lvs_display_loading_verifying

iec_load_loop:
	// We are now ready to receive bytes
	jsr iec_rx_byte
	bcs load_iec_error

	// Handle the byte (store in memory / verify)
	jsr lvs_handle_byte_load_verify
	bcs load_iec_error

	// Advance pointer to data
	jsr lvs_advance_pointer
	bcs_far lvs_wrap_around_error
	
	// Handle STOP key; it is probably an overkill to do it
	// with every byte, once per 32 bytes should be enough
	lda STAL
	and #$1F
	bne !+
	phx_trash_a
	jsr udtim_keyboard
	jsr STOP
	bcs load_break_error
	plx_trash_a
!:
	// Check for EOI - if so, this was the last byte
	lda IOSTATUS
	and #K_STS_EOI
	beq iec_load_loop

	// Display end address
	jsr lvs_display_done

	// Close file on drive

	lda FA
	jsr iec_close_load

	// Return last address
	jmp lvs_return_last_address


#endif // CONFIG_IEC
