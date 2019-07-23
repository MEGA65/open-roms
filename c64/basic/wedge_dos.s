
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
	cmp #$20
	beq wedge_dos_status
	;; XXX consider SYNTAX ERROR if anything besides spaces is there
	
	;; Check if asked for a directory
	cmp #$24
	beq wedge_dos_directory
*
	;; Check if asked to change drive number, or if it is a regular command
	cmp #$30
	bmi wedge_dos_command ; char code before 0
	cmp #$3A
	bpl wedge_dos_command ; char code after 9
	iny
	lda (basic_current_statement_ptr), y
	beq wedge_dos_change_drive ; end of buffer
	cmp #$20
	beq wedge_dos_change_drive
	;; XXX consider SYNTAX ERROR if anything besides spaces is there
	jmp -

wedge_dos_command:

	;; Set remaining file parameters, open the channel
	lda #$00  ; empty file name
	jsr JSETNAM
	jsr via_IOPEN
	bcc +
	jmp do_DEVICE_NOT_PRESENT_error
*
	;; Set channel for output
	ldx #$0F
	jsr via_ICKOUT
*
	jsr JREADST ; retrieve errors
	;; XXX error in case of status != 0
*   
	;; XXX this loop does not seem to work, check it
	jsr basic_fetch_and_consume_character
	beq +
	jsr via_IBSOUT
	;; XXX check errors here
	jmp -
*
	;; XXX check status - print it if not OK
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
	bcc +
	jmp do_DEVICE_NOT_PRESENT_error
*
	;; Set channel for input
	ldx #$0F
	jsr via_ICHKIN
*
	jsr JREADST ; retrieve errors
	;; XXX error in case of status != 0
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
	jsr printf
	.byte "DBG: DIR", 0
	jmp do_NOT_IMPLEMENTED_error

wedge_dos_clean_exit:
	jsr via_ICLALL
	jsr via_ICLRCH
	jmp basic_end_of_line

;; END wedge support
