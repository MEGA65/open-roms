// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_save:

	// Set default device and secondary address; channel is not important now

	jsr select_device
	ldy #$00                           // secondary address
	jsr JSETFLS

	// Check if file name is supplied

	jsr basic_end_of_statement_check
	bcs_16 do_MISSING_FILENAME_error

	// Fetch the file name

	jsr cmd_load_fetch_filename





	// XXX - finish the implementation

	jmp basic_main_loop
