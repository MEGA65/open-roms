
//
// IEC part of the LOAD routine
//


load_iec:

	// Display SEARCHING FOR + filename
	jsr lvs_display_searching_for

	// http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	// p13, 16; also p16 tells us this routine does not mess with the file
	// table in the C64, only in the drive.

	// Call device to LISTEN (p16)
	lda FA
	jsr LISTEN
	bcc !+
	jmp lvs_device_not_found_error // XXX deduplicate with other jumps in this routine
!:
	// Open channel 0 (reserved for file reading)
	lda #$00
	jsr iec_cmd_open
	bcc !+
	jmp lvs_device_not_found_error // XXX deduplicate with other jumps in this routine
!:
	// Send file name
	jsr lvs_send_file_name
	bcc !+
	jmp lvs_load_verify_error // XXX deduplicate with other jumps in this routine 
!:
	// Now command device to talk (p16)
	lda FA
	jsr TALK
	bcc !+
	jmp lvs_load_verify_error // XXX deduplicate with other jumps in this routine 
!:
	lda #$60 // open channel / data (p3) , required according to p13
	sta TBTCNT
	jsr iec_tx_command
	bcc !+
	jmp lvs_load_verify_error // XXX deduplicate with other jumps in this routine 
!:
	// We are currently talker, so do the IEC turn around so that we
	// are the listener (p16)
	jsr iec_turnaround_to_listen
	bcc !+
	jmp lvs_load_verify_error // XXX deduplicate with other jumps in this routine 
!:
	// Get load address and store it if secondary address is zero
	jsr iec_rx_byte
	bcc !+
	jmp kernalerror_FILE_NOT_FOUND // XXX deduplicate with other jumps in this routine
!:
	ldx SA
	beq !+
	sta STAL+0
!:
	jsr iec_rx_byte
	bcc !+
	jmp kernalerror_FILE_NOT_FOUND // XXX deduplicate with other jumps in this routine
!:
	ldx SA
	beq !+
	sta STAL+1
!:
	// Display start address
	jsr lvs_display_loading_verifying

iec_load_loop:
	// We are now ready to receive bytes
	jsr iec_rx_byte
	bcc !+
	jmp lvs_load_verify_error // XXX deduplicate with other jumps in this routine 
!:
	// Handle the byte (store in memory / verify)
	jsr lvs_handle_byte_load_verify
	bcc !+
	jmp lvs_load_verify_error // XXX deduplicate with other jumps in this routine 
!:	
	// Advance pointer to data
	jsr lvs_advance_pointer
	bcc !+
	jmp lvs_wrap_around_error
!:
	// Check for EOI - if so, this was the last byte
	lda IOSTATUS
	and #K_STS_EOI
	beq iec_load_loop

	// Display end address
	jsr lvs_display_done

	// Close file on drive

	lda FA
	jsr close_load

	// Return last address
	jmp lvs_return_last_address
