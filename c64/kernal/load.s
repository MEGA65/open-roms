	; Function defined on pp272-273 of C64 Programmers Reference Guide
	;; IEC reference at http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf

	;; Definition of function from Compute's Mapping the 64 p231
	;; Expects that SETLFS and SETNAM are called before hand.
	;; $YYXX = load address.
	;; (ignored if SETLFS channel = 1, i.e., like ,8,1)
	;; If A=1 then VERIFY instead of LOAD.
	;; On exit, $YYXX is the highest address into which data
	;; will have been placed.

	;; Searching through Compute's Mapping the 64, we find the following
	;; things are used:
	;; $93 = kernal_load_or_verify_flag
	;; $AC = current pointer for loading/verifying
	;; $C1 = similar to the above.

	;; XXX honor MSGFLG bit 6, add VERIFY support
	;; XXX rework the message print-out to be shared with SAVE
	;; XXX add VERIFY support

load:

	;; Are we loading or verifying?
	sta kernal_load_or_verify_flag

	;; Store start address of LOAD
	stx load_save_start_ptr+0
	sty load_save_start_ptr+1

	;; Reset status
	jsr kernalstatus_reset

	;; We need our helpers to get to filenames under ROMs or IO area
	jsr install_ram_routines

	;; Display SEARCHING FOR + filename
	lda MSGFLG
	bpl +
	jsr printf
	.byte $0D,"SEARCHING FOR ",0
	ldy #$00
print_filename_loop:

	cpy current_filename_length
	beq +
	ldx #<current_filename_ptr
	jsr peek_under_roms
	jsr JCHROUT
	iny
	jmp print_filename_loop
*
	;; http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;; p13, 16; also p16 tells us this routine doesn't mess with the file table
	;; in the C64, only in the drive.
	
	;; Call device to LISTEN (p16)
	lda current_device_number
	jsr listen
	bcs load_device_not_found_error

	;; Open channel #0 (p16)
	lda #$00
	jsr tksa
	bcs load_error
	
	;; Send filename (p16)
	ldy #0

send_filename:

	cpy current_filename_length
	beq sent_filename
	
	ldx #<current_filename_ptr
	jsr peek_under_roms
	iny

	;; Save Y because iec_tx_byte will corrupt it
	tax
	tya
	pha

	;; Set Carry flag on the last file name character, to mark EOI
	cmp current_filename_length
	clc
	bne +
	sec
*
	txa
	jsr iec_tx_byte

	pla
	tay
	jmp send_filename

sent_filename:

	;; Command device to unlisten to indicate end of file name. (p16)
	jsr unlsn
	bcs load_error
	jsr iec_set_idle ;; XXX is it needed?

	;; Now command device to talk (p16)
	lda current_device_number
	jsr talk
	bcs load_error

	lda #$60 ; open channel / data (p3) , required according to p13
	jsr iec_tx_command
	bcs load_error

	;; We are currently talker, so do the IEC turn around so that we
	;; are the listener (p16)
	jsr iec_turnaround_to_listen
	bcs load_error

	;; Get load address and store it if secondary address is zero
	jsr iec_rx_byte
	bcs load_file_not_found_error
	ldx current_secondary_address
	beq +
	sta load_save_start_ptr+0
*
	jsr iec_rx_byte
	bcs load_file_not_found_error
	ldx current_secondary_address
	beq +
	sta load_save_start_ptr+1
*
	;; Display LOADING / VERIFYING and start address
	lda MSGFLG
	bpl load_loop
	lda kernal_load_or_verify_flag
	beq +
	jsr printf
	.byte $0D, "VERIFYING", 0
	jmp load_print_start_addr
*
	jsr printf
	.byte $0D, "LOADING", 0
load_print_start_addr:
	jsr printf
	.byte " FROM $",0
	lda load_save_start_ptr+1
	jsr printf_printhexbyte
	lda load_save_start_ptr+0
	jsr printf_printhexbyte
	
load_loop:
	;; We are now ready to receive bytes
	jsr iec_rx_byte
	bcs load_error

	;; Save it and advance pointer.
	;; As with our BASIC, we want to enable LOADing
	;; anywhere in memory, including over the IO space.
	;; Thus we have to use a helper routine in low memory
	;; to do the memory access

	;; Save byte under ROMs and IO if required
	php
	sei
	ldx #$33
	stx $01
	ldy #0
	sta (load_save_start_ptr),y
	ldx #$37
	stx $01
	plp

	;; Advance pointer
	inc load_save_start_ptr
	bne +
	inc load_save_start_ptr+1
	;; If we wrap around to $0000, then this is bad.
	beq load_wrap_around_error
*
	;; Check for EOI - if so, this was the last byte
	lda IOSTATUS
	and #K_STS_EOI
	beq load_loop

load_done:
	;; Display end address
	lda MSGFLG
	bpl +
	jsr printf
	.byte " TO $",0
	lda load_save_start_ptr+1
	jsr printf_printhexbyte
	lda load_save_start_ptr+0
	jsr printf_printhexbyte
	lda #$0D
	jsr JCHROUT
*
	;; Close file on drive

	;; Command drive to stop talking and to close the file
	jsr untlk

	;; Turnaround to talker - according to https://www.pagetable.com/?p=1135
	;; the turnaround only happens after a command
	jsr iec_turnaround_to_talk

	lda current_device_number
	jsr listen

	lda #$e0
	jsr iec_tx_command

	;; Tell drive to unlisten
	jsr unlsn
	
	;; Set IEC status back to idle
	jsr iec_set_idle

	;; Return last address - Compute's Mapping the 64 says without the '+1',
	;; checked (short test program) on original ROMs that this is really the case
	ldx load_save_start_ptr+0
	ldy load_save_start_ptr+1

	clc
	rts

load_wrap_around_error:

	;; This error is probably not even detected by C64 Kernal;
	;; report BASIC error code that looks the most sane
	lda #B_ERR_OVERFLOW
	sec
	rts

load_device_not_found_error:

	jsr kernalstatus_DEVICE_NOT_FOUND
	jmp kernalerror_DEVICE_NOT_FOUND

load_file_not_found_error:

	jmp kernalerror_FILE_NOT_FOUND

load_error:

	;; XXX should we really return BASIC error code here?
	lda kernal_load_or_verify_flag
	beq load_verify_error
	lda #B_ERR_LOAD
	bne +
load_verify_error:
	lda #B_ERR_VERIFY
*	
	sec
	rts

