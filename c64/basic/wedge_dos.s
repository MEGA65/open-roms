
;; START wedge support

wedge_dos:

	;; Close all the channels, so that wedge has full control
	jsr $FFE7 ; XXX jump via ICLALL
	
	;; Take last device number, make sure it's a drive
	;; If not, set to 8 (first drive number)
	ldx current_device_number
	cpx #$07
	bpl +
	bcs +
	ldx #$08
*
	;; Set remaining file parameters
	lda #$0F
	ldy #$0F
	jsr $FFBA ; SETLFS

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

wedge_dos_command: ; default

	;; XXX - implement this
	jsr printf
	.byte "DBG: CMD", 0
	jmp do_NOT_IMPLEMENTED_error

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

	;; XXX - implement this
	jsr printf
	.byte "DBG: STATUS", 0
	jmp do_NOT_IMPLEMENTED_error

wedge_dos_directory:

	;; XXX - implement this
	jsr printf
	.byte "DBG: DIR", 0
	jmp do_NOT_IMPLEMENTED_error

;; END wedge support
