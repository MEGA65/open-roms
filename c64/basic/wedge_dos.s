
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
	bcs wedge_dos_basic_error
	jsr via_IBSOUT
	jmp -
*
	;; Print new line
	lda #$0D
	jsr via_IBSOUT

	;; Clean-up and exit
	jmp wedge_dos_clean_exit

wedge_dos_directory:

	;; First change the secondary address to the one suitable for
	;; directory loading
	lda #$00
	sta current_secondary_address

	;; Now determine the length of the 'file' name
	ldy #$FF
*
	iny
	lda (basic_current_statement_ptr), y
	bne -
	
	;; Set the name to open
	tya
	ldx basic_current_statement_ptr+0
	ldy basic_current_statement_ptr+1
	jsr JSETNAM

	;; Open the file
	jsr via_IOPEN
	bcs wedge_dos_basic_error

	;; Set channel for input
	ldx #$0F
	jsr via_ICHKIN
	bcs wedge_dos_basic_error

	;; Ignore start address (2 first bytes) - XXX check for errors
	jsr via_IBASIN
	bcs wedge_dos_basic_error
	jsr via_IBASIN
	bcs wedge_dos_basic_error

wedge_dos_directory_line:

	;; Load a single line, reuse BASIC input buffer
	ldy #$FF
*
	iny
	jsr via_IBASIN
	bcs wedge_dos_basic_error
	sta BUF, y
	cpy #$50
	beq + ; line too long, terminate loading file
	jsr JREADST
	beq + ; end of file
	lda BUF, y
	bne -
	;; End of line, but not end of file
	beq wedge_dos_directory_display
*
	lda #K_STS_END_OF_FILE
	sta IOSTATUS ; make sure end of file is marked
	;; FALLTROUGH

wedge_dos_directory_display:

	lda #$00 ; extra protection
	sta BUF, y

	;; Display line
	ldx #<BUF
	jsr list_single_line

	;; Read & display next line or quit
	lda IOSTATUS
	beq wedge_dos_directory_line
	;; FALLTROUGH

wedge_dos_clean_exit:
	jsr via_ICLALL
	jmp basic_end_of_line

wedge_dos_basic_error:
	tax
	dex
	jsr do_basic_error
	jsr via_ICLALL
	jmp basic_end_of_line

;; END wedge support
