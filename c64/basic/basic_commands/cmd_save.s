// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_save:

	// Set default device and secondary address

	jsr helper_load_init_params_no_VERCKB

	// Fetch the file name

	jsr helper_load_fetch_filename
	bcs_16 do_MISSING_FILENAME_error

	// Try to fetch device number and secondary address

	jsr helper_load_fetch_devnum
	bcs !+
	jsr helper_load_fetch_secondary
!:
	// Setup the start address

	lda #TXTTAB

	// Setup the end address

	ldx VARTAB+0
	ldy VARTAB+1

	// FALLTROUGH

cmd_save_do: // entry point for BSAVE

	// Perform saving

	jsr JSAVE
	bcs_16 do_kernal_error

	// The end
.break
	jmp execute_statements
