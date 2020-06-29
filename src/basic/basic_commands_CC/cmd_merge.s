// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_merge:

	lda #$00                           // mark operation as LOAD
	jsr helper_load_init_params

	// Fetch the file name

	jsr helper_bload_fetch_filename

	// Fetch device number

	jsr helper_load_fetch_devnum

	// FALLTROUGH

cmd_merge_got_params:

	// Make sure VARTAB is correctly set

	jsr calculate_VARTAB

	// Perform loading - just for a different address

	sec
	lda VARTAB+0
	sbc #$02
	sta VARTAB+0
	tax
	bcs !+
	dec VARTAB+1
!:
	ldy VARTAB+1

	lda VERCKB    // LOAD or VERIFY
	jsr JLOAD
	bcs_16 do_kernal_error

cmd_merge_no_error:

	// Store last loaded address

	stx VARTAB+0
	sty VARTAB+1

	// Clear the variables
	jsr do_clr

	// Now relink the loaded program, line links supplied are almost certainly wrong

	jsr LINKPRG

	// XXX when number parsing is done, change to continue execution

	jmp shell_main_loop
