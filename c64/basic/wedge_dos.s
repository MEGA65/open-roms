
;; START wedge support

wedge_dos:

	;; Close all the channels, so that wedge has full control
	jsr via_ICLALL

	;; Set file parameters,  channel 15 is a typical one for commands
	jsr select_device ; sets X register
	lda #$0F
	ldy #$0F
	jsr JSETFLS

	;; Now we have to check what the user wants us to do

	;; Check if user asked for a status
	ldy #$00
	lda (basic_current_statement_ptr), y
	beq wedge_dos_status
	
	;; Check if asked for a directory
	cmp #$24
	beq wedge_dos_directory
*
	;; Check if asked to change drive number, or if it is a regular command
	cmp #$30
	bcc wedge_dos_command ; char code before 0
	cmp #$3A
	bcs wedge_dos_command ; char code after 9
	iny
	lda (basic_current_statement_ptr), y
	beq wedge_dos_change_drive ; end of buffer
	cmp #$20
	beq wedge_dos_change_drive
	jmp -

wedge_dos_command:

	;; Set remaining file parameters, open the channel
	lda #$00  ; empty file name
	jsr JSETNAM
	jsr via_IOPEN
	bcs wedge_dos_basic_error
*
	;; Set channel for output
	ldx #$0F
	jsr via_ICKOUT
	bcs wedge_dos_basic_error
*   
	jsr basic_fetch_and_consume_character
	cmp #$00
	beq +

	jsr via_IBSOUT
	bcs wedge_dos_basic_error
	jmp -
*
	;; Finalize command
	lda #$0D
	jsr via_IBSOUT
	bcs wedge_dos_basic_error

	;; XXX close here, check status - print it if not OK
	;; Clean-up and exit
	jmp wedge_dos_clean_exit

wedge_dos_change_drive:

	;; Reuse the line number parser for device number retrieval
	jsr basic_parse_line_number
	lda basic_line_number+1
	beq +
	jmp do_ILLEGAL_QUANTITY_error
*
	lda basic_line_number+0
	cmp #$08
	bpl +
	bcs +
	jmp do_ILLEGAL_DEVICE_NUMBER_error
*
	sta current_device_number
	jmp basic_end_of_line

wedge_dos_status:

	;; Here the flow is mostly the same as in the example from
	;; https://codebase64.org/doku.php?id=base:reading_the_error_channel_of_a_disk_drive

	;; Set remaining file parameters, open the channel
	lda #$00  ; empty file name
	jsr JSETNAM
	jsr via_IOPEN
	bcs wedge_dos_basic_error

	;; Set channel for input
	ldx #$0F
	jsr via_ICHKIN
	bcs wedge_dos_basic_error
*
	jsr JREADST ; retrieve errors
	;; XXX error in case of status != EOF
	;; Print out everything retrieved from the drive
	bne +
	jsr via_IBASIN
	jsr via_IBSOUT
	jmp -
*
	;; Print new line
	lda #$0D
	jsr via_IBSOUT

	;; Clean-up and exit
	jmp wedge_dos_clean_exit

wedge_dos_directory:

	;; XXX - implement this
	jmp do_NOT_IMPLEMENTED_error

wedge_dos_clean_exit:
	jsr via_ICLALL
	jsr via_ICLRCH
	jmp basic_end_of_line

wedge_dos_basic_error:
	tax
	dex
	jsr do_basic_error
	jsr via_ICLALL
	jsr via_ICLRCH
	jmp basic_end_of_line

;; END wedge support
