// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE



cmd_verify:

	// LOAD and VERIFY are very similar, from BASIC perspective there is almost no difference;
	// just different parameter passed to Kernal and different error message in case of failure

	lda #$01                           // mark operation as VERIFY
	skip_2_bytes_trash_nvz

cmd_load:

	lda #$00                           // mark operation as LOAD
	sta VERCKB

	// C64 BASIC apparently does not clear variables after a LOAD in the
	// middle of a program. For safety, we do.
	jsr basic_do_clr

	// Set default device and secondary address; channel is not important now

	jsr select_device
	ldy #$00                           // secondary address
	jsr JSETFLS

	// Check if file name is supplied

	jsr basic_end_of_statement_check
	bcs cmd_load_no_filename

	// Fetch the file name

	jsr cmd_load_fetch_filename

	// Try to fetch secondary address

	jsr cmd_load_fetch_dev_secondary
	jmp cmd_load_got_params

cmd_load_no_filename:

	// If no file name is supplied, try to load first file from disc

	lda #$01                           // name length
	ldx #<filename_any
	ldy #>filename_any
	jsr JSETNAM

	// FALLTROUGH

cmd_load_got_params:                   // input for tape wedge

	// Perform loading

	ldy TXTTAB+1
	ldx TXTTAB+0
	lda VERCKB    // LOAD or VERIFY

	jsr JLOAD

	// Handle result

	php
	pha
	jsr print_return
	pla
	plp
	bcc cmd_load_no_error

	// .A = KERNAL error code, also almost matches BASIC error codes

	tax
	dex
	bpl !+
	ldx #B_ERR_BREAK
!:
	jmp do_basic_error
	
cmd_load_no_error:

	// Store last loaded address

	stx VARTAB+0
	sty VARTAB+1

	// Now relink the loaded program, as we cannot trust the line
	// links supplied. For example, the VICE virtual drive emulation
	// always supplies $0101 as the address of the next line

	jsr LINKPRG
	
	// Now we either start the program from the beginning,
	// or go back to the READY prompt if LOAD was called from direct mode.

	// Reset to start of program
	jsr init_oldtxt

	// XXX - should run program if LOAD was used in program mode
	jmp basic_main_loop






// XXX move functions below to separate files, change names to neuytral




cmd_load_fetch_filename:

	// Search for opening quote

	jsr basic_fetch_and_consume_character
	cmp #$22
	bne_16 do_SYNTAX_error
!:
	// Filename starts here so set pointer

	lda TXTPTR+0
	sta FNADDR+0
	lda TXTPTR+1
	sta FNADDR+1

	// Now search for end of line or closing quote
	// so that we know the length of the filename

	lda #$00
	sta FNLEN
!:
	jsr basic_fetch_and_consume_character
	cmp #$22
	beq cmd_load_fetch_filename_done
	cmp #$00
	beq !+

	inc FNLEN
	bne !-

!:
	jsr basic_unconsume_character

	// FALLTROUGH

cmd_load_fetch_filename_done:

	rts




cmd_load_fetch_dev_secondary:

	// Fetch the device number

	jsr injest_comma
	bcs cmd_load_fetch_dev_secondary

	jsr basic_parse_line_number
	lda LINNUM+1
	bne_16 do_ILLEGAL_QUANTITY_error

	lda LINNUM+0
	sta FA

	// FALLTROUGH

cmd_load_fetch_secondary:

	// Fetch secondary address

	jsr injest_comma
	bcs cmd_load_fetch_dev_secondary_done

	jsr basic_parse_line_number
	lda LINNUM+1
	bne_16 do_ILLEGAL_QUANTITY_error

	lda LINNUM+0
	sta SA

	// FALLTROUGH

cmd_load_fetch_dev_secondary_done:

	rts
