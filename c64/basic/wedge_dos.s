
;; START wedge support

wedge_dos:

	;; Close all the channels, so that wedge has full control
	jsr $FFE7 ; CLALL
	
	;; Take last device number, make sure it's a drive
	;; If not, set to 8 (first drive number)
	lda current_device_number
	cmp #$07
	bpl +
	lda #$08	
*
	;; Set remaining file parameters
	ldx #$0F
	ldy #$0F
	jsr $FFBA ; SETLFS

	;; Now we have to check what the user wants us to do

	;; Check if user asked for a status
	ldy #$00
	lda (basic_current_statement_ptr), y
	beq wedge_dos_status
	cmp #$20
	beq wedge_dos_status
	
	;; Check if asked for a directory
	cmp #$24
	beq wedge_dos_directory
*
	;; XXX Check if asked to change drive number

wedge_dos_command: ; default

	;; XXX - implement this
	jsr printf
	.byte "DBG: CMD", 0
	jmp do_NOT_IMPLEMENTED_error

wedge_dos_change_drive:

	;; XXX - implement this
	jsr printf
	.byte "DBG: CHANGE DRIVE", 0
	jmp do_NOT_IMPLEMENTED_error

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

