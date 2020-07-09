// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_bverify:

	// LOAD and VERIFY are very similar, from BASIC perspective there is almost no difference;
	// just different parameter passed to Kernal and different error message in case of failure

	lda #$01                           // mark operation as VERIFY
	skip_2_bytes_trash_nvz

cmd_bload:

	lda #$00                           // mark operation as LOAD
	jsr helper_load_init_params

	// Fetch the file name

	jsr helper_bload_fetch_filename

	// Fetch device number

	jsr fetch_coma_uint8
	bcs_16 do_SYNTAX_error

	sta FA

	// Fetch the start address

	jsr helper_bload_fetch_address

	// Perform loading

	lda VERCKB                         // LOAD or VERIFY
	jsr JLOAD
	bcs_16 do_kernal_error

	// Execute next statement

	jmp end_of_statement
