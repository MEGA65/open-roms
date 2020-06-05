// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_save:

	// Set default device and secondary address; channel is not important now

	jsr select_device
	ldy #$00                           // secondary address
	jsr JSETFLS

	// Fetch the file name

	jsr fetch_filename
	bcs_16 do_MISSING_FILENAME_error





	// XXX - finish the implementation

	jmp basic_main_loop
