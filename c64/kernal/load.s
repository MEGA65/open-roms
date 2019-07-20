
;;
;; Official Kernal routine, described in:
;;
;; - [RG64] C64 Programmer's Reference Guide   - page 286
;; - [CM64] Compute's Mapping the Commodore 64 - page 231
;; - IEC reference at http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
;;
;; CPU registers that has to be preserved (see [RG64]): none
;;


	;; Expects that SETLFS and SETNAM are called before hand.
	;; $YYXX = load address.
	;; (ignored if SETLFS channel = 1, i.e., like ,8,1)
	;; If A=1 then VERIFY instead of LOAD.
	;; On exit, $YYXX is the highest address into which data
	;; will have been placed.

	;; XXX honor MSGFLG bit 6
	;; XXX add VERIFY support

load:

	;; Are we loading or verifying?
	sta VERCK

	;; Store start address of LOAD
	stx STAL+0
	sty STAL+1

	;; Reset status
	jsr kernalstatus_reset

	;; We need our helpers to get to filenames under ROMs or IO area
	jsr install_ram_routines

	;; Allow platform-specific routine to takeover the flow
	`PLATFORM_HOOK_LOAD

	;; Display SEARCHING FOR + filename
	jsr lvs_display_searching_for

	;; http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;; p13, 16; also p16 tells us this routine doesn't mess with the file table
	;; in the C64, only in the drive.
	
	;; Call device to LISTEN (p16)
	lda current_device_number
	jsr listen
	bcs lvs_device_not_found_error

	;; Open channel #0 (p16)
	lda #$00
	jsr tksa
	bcs lvs_load_verify_error

	;; Send filename (p16)
	ldy #0

load_send_filename:

	cpy FNLEN
	beq load_filename_sent

	ldx #<current_filename_ptr
	jsr peek_under_roms
	iny

	;; Set Carry flag on the last file name character, to mark EOI
	cpy FNLEN
	clc
	bne +
	sec
*
	;; Transmit one character
	sta BSOUR
	jsr iec_tx_byte

	jmp load_send_filename

load_filename_sent:

	;; Command device to unlisten to indicate end of file name. (p16)
	jsr unlsn
	bcs lvs_load_verify_error
	jsr iec_set_idle ;; XXX is it needed?

	;; Now command device to talk (p16)
	lda current_device_number
	jsr talk
	bcs lvs_load_verify_error

	lda #$60 ; open channel / data (p3) , required according to p13
	sta BSOUR
	jsr iec_tx_command
	bcs lvs_load_verify_error

	;; We are currently talker, so do the IEC turn around so that we
	;; are the listener (p16)
	jsr iec_turnaround_to_listen
	bcs lvs_load_verify_error

	;; Get load address and store it if secondary address is zero
	jsr iec_rx_byte
	bcs lvs_file_not_found_error
	ldx current_secondary_address
	beq +
	sta STAL+0
*
	jsr iec_rx_byte
	bcs lvs_file_not_found_error
	ldx current_secondary_address
	beq +
	sta STAL+1
*
	;; Display start address
	jsr lvs_display_loading_verifying

load_loop:
	;; We are now ready to receive bytes
	jsr iec_rx_byte
	bcs lvs_load_verify_error

	;; Handle the byte (store in memory / verify)
	jsr lvs_handle_byte_load_verify
	bcs lvs_load_verify_error
	
	;; Advance pointer to data
	jsr lvs_advance_pointer
	bcs lvs_wrap_around_error

	;; Check for EOI - if so, this was the last byte
	lda IOSTATUS
	and #K_STS_EOI
	beq load_loop

	;; Display end address
	jsr lvs_display_done

	;; Close file on drive

	;; Command drive to stop talking and to close the file
	jsr untlk

	;; Turnaround to talker - according to https://www.pagetable.com/?p=1135
	;; the turnaround only happens after a command
	jsr iec_turnaround_to_talk

	lda current_device_number
	jsr listen

	lda #$E0
	sta BSOUR
	jsr iec_tx_command

	;; Tell drive to unlisten
	jsr unlsn
	
	;; Set IEC status back to idle
	jsr iec_set_idle

	;; Return last address
	jmp lvs_return_last_address
