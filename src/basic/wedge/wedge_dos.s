// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if CONFIG_DOS_WEDGE


// .X has to contain size of the buffer

wedge_dos:

	// Prepare buffer - finish it with '0'

	lda #$00
	sta BUF,x

	// Close all the channels, so that wedge has full control
	jsr JCLALL

	// Set file parameters,  channel 15 is a typical one for commands
	jsr select_device // sets .X register
	lda #$0F
	ldy #$0F
	jsr JSETFLS

	// Setup necessary part of BASIC

	jsr prepare_direct_execution
	jsr fetch_character

	// Now we have to check what the user wants us to do

	// Check if user asked for a status

	ldy #$00
	lda (TXTPTR), y
	beq_16 wedge_dos_status

	// Check if asked for a directory

	cmp #$24
	beq_16 wedge_dos_directory

	// Check if asked to change drive number, or if it is a regular command
	
	jsr is_09
	bcc wedge_dos_change_drive
	
	// FALLTROUGH

wedge_dos_command:

	// Check if command needs confirmation

	ldy #$00
	lda (TXTPTR), y

	cmp #$52                                     // 'R' - because 'RD' is a directory removal command
	bne !+

	iny
	lda (TXTPTR), y
	cmp #$44                                     // 'D'
	bne wedge_dos_command_confirmed
	beq wedge_dos_command_ask
!:
	cmp #$4E                                     // 'N' - for the disk format
	beq !+
	cmp #$53                                     // 'S' - for the file scratch
	bne wedge_dos_command_confirmed
!:
	// This is probably a dangerous command - check further the syntax,
	// if 'N:', 'S:', 'Nx:' or 'Sx:' (where 'x' is a digit) - ask for confirmation first

	iny
	lda (TXTPTR), y
	cmp #$3A                                     // ':' - colon
	beq wedge_dos_command_ask

	jsr is_09
	bcs wedge_dos_command_confirmed

	iny
	lda (TXTPTR), y
	cmp #$3A                                     // ':' - colon
	bne wedge_dos_command_confirmed

	// FALLTROUGH

wedge_dos_command_ask:

	jsr helper_ask_if_sure
	bcs_16 wedge_dos_clean_exit
	
	// FALLTROUGH

wedge_dos_command_confirmed:

	// Provide command name

	jsr wedge_dos_setnam
	
	jsr JSETNAM
	jsr JOPEN
	bcs_16 wedge_dos_basic_error

	// Retrieve status, print it if not OK

	jsr JCLALL
	jsr wedge_dos_status_get_no_new_line

	lda BUF+0
	cmp #$30 // '0'
	bne wedge_dos_status_print

	eor BUF+1
	bne wedge_dos_status_print

	// Clean-up and exit

	jmp wedge_dos_clean_exit

wedge_dos_change_drive:

	// Fetch new drive number, make sure this is the last part of the command

	jsr fetch_uint8
	pha
	jsr fetch_character_skip_spaces
	cmp #$00
	bne_16 do_SYNTAX_error
	pla

	// Check if device number is valid for IEC drive

	cmp #$08
	bcc_16 do_ILLEGAL_DEVICE_NUMBER_error

	// Store new device number and return to shell

	sta FA
	jmp shell_main_loop

wedge_dos_status_get:

	// New line - separate status from current display

	jsr print_return

	// FALLTROUGH

wedge_dos_status_get_no_new_line:

	// Here the flow is mostly the same as in the example from
	// https://codebase64.org/doku.php?id=base:reading_the_error_channel_of_a_disk_drive

	// Set remaining file parameters, open the channel

	lda #$00  // empty file name
	jsr JSETNAM
	jsr JOPEN
	bcs_16 wedge_dos_basic_error

	// Set channel for input

	ldx #$0F
	jsr JCHKIN
	bcs_16 wedge_dos_basic_error

	// Fetch the drive status

	ldy #$00

	// FALLTROUGH

wedge_dos_status_get_loop:

	// Check for buffer overflow

	cpy #$50
	beq_16 do_OVERFLOW_error

	// Check for EOF

	jsr JREADST
	// XXX check for transfer errors
	bne wedge_dos_status_get_done

	// Retrieve a byte and put it into the buffer

	jsr JCHRIN
	bcs_16 wedge_dos_basic_error

	sta BUF, y
	iny

	bne wedge_dos_status_get_loop                // branch always

wedge_dos_status_get_done:

	// Strip ending RETURN

	dey
	rts

wedge_dos_status:

	jsr wedge_dos_status_get
#if HAS_OPCODES_65C02
	bra wedge_dos_status_print_no_new_line
#else
	jmp wedge_dos_status_print_no_new_line
#endif

wedge_dos_status_print:

	jsr print_return

	// FALLTROUGH

wedge_dos_status_print_no_new_line:

	// Print buffered status

	ldx #$00
!:
	dey
	bmi !+
	lda BUF, x
	jsr JCHROUT
	inx
	bne !-
!:
	// Clean-up and exit

#if HAS_OPCODES_65C02
	bra wedge_dos_clean_exit
#else
	jmp wedge_dos_clean_exit
#endif

wedge_dos_directory:

	// First change the secondary address to the one suitable for directory loading

	lda #$00                                     // logical device number
	ldx FA
	ldy #$60
	jsr JSETFLS

	// Provide file name

	jsr wedge_dos_setnam

	// Open the file, set channel for reading

	jsr JOPEN
	bcs wedge_dos_basic_error

	ldx #$00
	jsr JCHKIN
	bcs wedge_dos_basic_error

	// Ignore start address (2 first bytes) - XXX check for errors

	jsr JCHRIN
	bcs wedge_dos_basic_error
	jsr JCHRIN
	bcs wedge_dos_basic_error

	// FALLTROUGH

wedge_dos_directory_line:

	// Load a single line, reuse BASIC input buffer

	ldy #$FF
!:
	iny
	jsr JCHRIN
	bcs wedge_dos_basic_error
	sta BUF, y
	cpy #$50
	beq_16 do_OVERFLOW_error                     // branch if line too long
	jsr JREADST
	bne !+ // end of file
	cpy #$04 // 2 bytes (pointer to next line) + 2 bytes (line number) 
	bcc !-
	lda BUF, y
	bne !-

	// End of line, but not end of file

	beq wedge_dos_directory_display
!:
	lda #K_STS_END_OF_FILE
	sta IOSTATUS // make sure end of file is marked

	// FALLTROUGH

wedge_dos_directory_display:

	cpy #$05                                     // protection against malformed directory
	bcc wedge_dos_clean_exit

	lda #$00                                     // extra protection agains buffer overflow
	sta BUF, y

	// Display line

	ldx #<BUF
	stx OLDTXT+0
	ldx #>BUF
	stx OLDTXT+1
	ldx #OLDTXT
	jsr list_single_line

	// Read & display next line or quit

	lda IOSTATUS
	beq wedge_dos_directory_line

	// FALLTROUGH

wedge_dos_clean_exit:

	jsr JCLALL
	jmp shell_main_loop

wedge_dos_basic_error:

	pha
	jsr JCLALL
	pla
	jmp do_kernal_error

wedge_dos_setnam:

	// Now determine the length of the 'file' name

	ldy #$FF
!:
	iny
	lda (TXTPTR), y
	bne !-
	
	// Set the name to open

	tya
	ldx TXTPTR+0
	ldy TXTPTR+1

	jmp JSETNAM


#endif // CONFIG_DOS_WEDGE
