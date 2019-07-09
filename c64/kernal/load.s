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

;; XXX rework this, according to pagetable.com

load:

	;; Are we loading or verifying?
	sta kernal_load_or_verify_flag

	;; Store start address of LOAD
	stx load_save_start_ptr+0
	sty load_save_start_ptr+1

	;; We need our helpers to get to filenames under ROMs or IO area
	jsr install_ram_routines
	
	;; Disable IRQs, since timing matters!
	SEI

	;; Display SEARCHING FOR
	jsr printf
	.byte "SEARCHING FOR ",0

	ldy #$00
print_filename_loop:

	cpy current_filename_length
	beq +
	ldx #<current_filename_ptr
	jsr peek_under_roms
	jsr $ffd2
	iny
	jmp print_filename_loop
*
	lda #$0d
	jsr $ffd2

	;; XXX - Use default device number
	;; http://www.zimmers.net/anonftp/pub/cbm/programming/serial-bus.pdf
	;; p13, 16.
	;; also p16 tells us this routine doesn't mess with the file table in the C64,
	;; only in the drive.
	
	;; Call device to LISTEN (p16)
	lda current_device_number
	jsr listen
	bcs load_error

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
	jsr iec_set_idle

	;; Now command device to talk (p16)
	lda current_device_number
	jsr talk
	bcs load_error

	lda #$60 ; open channel / data (p3) , required according to p13
	jsr iec_tx_command
	bcs load_error

	;; We are currently talker, so do the IEC turn around so that we
	;; are the listener (p16)
	;; An error here means FILE NOT FOUND ?
	jsr iec_turnaround_to_listen
	bcs load_error

	;; Get load address and store it if secondary address is zero
	jsr iec_rx_byte
	bcs file_not_found_error
	ldx current_secondary_address
	beq +
	sta load_save_start_ptr+0
*
	jsr iec_rx_byte
	bcs file_not_found_error
	ldx current_secondary_address
	beq +
	sta load_save_start_ptr+1
*
	jsr printf
	.byte "LOADING",$0d,0

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
	ldx #$33
	stx $01
	ldy #0
	sta (load_save_start_ptr),y
	ldx #$37
	stx $01

	;; Advance pointer
	inc load_save_start_ptr
	bne +
	inc load_save_start_ptr+1
	;; If we wrap around to $0000, then this is bad.
	beq load_error	
*
	;; Check for EOI -- if so, read one last byte
	lda IOSTATUS
	and #$40
	beq load_loop

load_done:
	;; Close file on drive

	;; Command drive to stop talking and to close the file
	jsr untlk
	lda current_device_number
	jsr listen
	lda #$e0
	jsr iec_tx_command
	;; Tell drive to unlisten
	jsr unlsn

	;; Return last address written to +1
	;; (Even though Compute's Mapping the 64 says without the +1.
	;; I'm suspicious. Will have to check behavour on an original C64)
	ldx load_save_start_ptr+0
	ldy load_save_start_ptr+1

	clc
	cli
	rts
	
load_error:

	;; XXX - Indicate KERNAL (not BASIC) LOAD error condtion
	sec
	lda #28
	
	;; Re-enable interrupts and return
	cli
	;; (iec_tx_byte will have set/cleared C flag and put result code
	;; in A if it was an error).
	rts

file_not_found_error:
	;; Indicate KERNAL error condition for file not found
	sec
	lda #$04
	cli
	rts
