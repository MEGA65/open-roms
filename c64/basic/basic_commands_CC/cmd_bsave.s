// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_bsave:

	// Set default device and secondary address

	jsr helper_load_init_params_no_VERCKB

	// Fetch the file name

	jsr helper_load_fetch_filename
	bcs_16 do_MISSING_FILENAME_error

	// Fetch device number

	jsr helper_load_fetch_devnum
	bcs_16 do_SYNTAX_error

	// Fetch memory area start address

	jsr injest_comma
	bcs_16 do_SYNTAX_error

	jsr basic_parse_line_number                  // XXX detect errors here

	lda LINNUM+0
	pha
	lda LINNUM+1
	pha

	// Fetch memory area end address

	jsr injest_comma
	bcs_16 do_SYNTAX_error

	jsr basic_parse_line_number                  // XXX detect errors here

	// Setup start/end addresses

	ldx LINNUM+0
	ldy LINNUM+1

	pla
	sta LINNUM+1
	pla
	sta LINNUM+0

	lda #LINNUM

	// Perform SAVE - reuse regular command

	jmp cmd_save_do
