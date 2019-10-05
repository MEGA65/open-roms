cmd_load:

	// Parse filename
	// (we can tell the KERNAL where it is in memory directly, since the
	// KERNAL will be able to peek under ROMs to read it, since it will have
	// to be able to peek under the ROMs for SAVE and VERIFY).
	// Parse optional device #
	// Parse optional secondary address
	
	// XXX - C64 BASIC apparently doesn't clear variables after a LOAD in the
	// middle of a program. For safety, we do.
	jsr basic_do_clr
	
	// Setup Kernal to print control messages or not
	lda #$80 // display control messages and omit error messages
	ldx CURLIN+1
	cpx #$FF
	beq !+
	lda #$00 // direct mode - don't display anything
!:
	jsr JSETMSG

	// Set filename and length
	lda #$00
	sta FNLEN

	// Without tape support, LOAD must have a filename
	// (This also skips any leading spaces)
	jsr basic_end_of_statement_check
	bcc !+
	jmp do_MISSING_FILENAME_error
!:
	jsr basic_fetch_and_consume_character
	cmp #$22
	beq !+
	jmp do_SYNTAX_error
!:
	// Filename starts here so set pointer
	lda TXTPTR+0
	sta FNADDR+0
	lda TXTPTR+1
	sta FNADDR+1

	// Now search for end of line or closing quote
	// so that we know the length of the filename
getting_filename:
	jsr basic_fetch_and_consume_character
	cmp #$22
	beq got_filename
	cmp #$00
	bne !+
	jsr basic_unconsume_character

	jmp got_filename
!:
	inc FNLEN
	jmp getting_filename
	
got_filename:

	// Now fetch the file number, start from the default one
	jsr select_device
	stx FA
	jsr injest_comma
	bcs got_devicenumber

	jsr basic_parse_line_number
	lda LINNUM+1
	beq !+
	jmp do_ILLEGAL_QUANTITY_error
!:
	lda LINNUM+0
	sta FA

got_devicenumber:

	// Now fetch the secondary address
	lda #$00
	sta SA
	jsr injest_comma
	bcs got_secondaryaddress
	jsr basic_parse_line_number
	lda LINNUM+1
	bne !+
	lda LINNUM+0
	sta SA
	jmp got_secondaryaddress
!:
	// Second parameter is above 255, this can't be a secondary address
	// Use it as load address instead
	// XXX temporary syntax, it would be better to use something
	// XXX like 'LOAD"FILE",8 TO 49152'
	ldx LINNUM+0
	ldy LINNUM+1
	bne got_loadaddress

got_secondaryaddress:
	ldy TXTTAB+1
	ldx TXTTAB+0

got_loadaddress:
	lda #$00 		// LOAD not verify
	jsr JLOAD
	php
	jsr print_return
	plp
	bcc !+

	// A = KERNAL error code, which also almost match
	// basic ERROR codes, so we can just copy the
	// error code to X, decrement, and handle normally
	tax
	dex
	jmp do_basic_error
	
!:
	// $YYXX is the last loaded address, so store it
	stx VARTAB+0
	sty VARTAB+1

	// Now relink the loaded program, as we cannot trust the line
	// links supplied. For example, the VICE virtual drive emulation
	// always supplies $0101 as the address of the next line.
	jsr basic_relink_program
	
	// After LOADing, we either start the program from the beginning,
	// or go back to the READY prompt if LOAD was called from direct mode.

	// Reset to start of program
	lda TXTTAB+0
	sta OLDTXT+0
	lda TXTTAB+1
	sta OLDTXT+1

	// XXX - should run program if LOAD was used in program mode
	jmp basic_main_loop


basic_relink_program:

	// Start by getting pointer to the first line
	lda TXTTAB+0
	sta OLDTXT+0
	lda TXTTAB+1
	sta OLDTXT+1

basic_relink_loop:
	// Is the pointer to the end of the program
	ldy #1

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
	cmp #$00
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	bne !+

	// End of program
	rts
!:
	// Now search forward to find the end of the line
	// Skip forward pointer and line number
	ldy #4
end_of_line_search:

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
#endif

	cmp #$00
	beq !+

	// Not yet end of line
	iny
	bne end_of_line_search

	// line too long
	jmp do_STRING_TOO_LONG_error

!:
	// Found end of line, so update pointer

	// First, skip over the $00 char
	iny

	// Now overwrite the pointer (carefully)
	//
	tya
	clc
	adc OLDTXT+0
	pha
	php
	ldy #0

#if CONFIG_MEMORY_MODEL_60K
	ldx #<OLDTXT+0
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (OLDTXT),y
#endif

	plp
	lda OLDTXT+1
	adc #0
	ldy #1

#if CONFIG_MEMORY_MODEL_60K
	jsr poke_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	sta (OLDTXT),y
#endif

	sta OLDTXT+1
	pla
	sta OLDTXT+0

	jmp basic_relink_loop
