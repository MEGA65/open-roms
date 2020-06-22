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
	jsr helper_load_init_params

	// Fetch the file name

	jsr helper_load_fetch_filename
	bcs cmd_load_no_filename

	// Try to fetch device and secondary address

	jsr fetch_device_secondary
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

cmd_load_loadmerge:                    // entry point for 'cmd_merge'

	lda VERCKB    // LOAD or VERIFY

	jsr JLOAD
	bcs_16 do_kernal_error
	
cmd_load_no_error:

	// Store last loaded address

	stx VARTAB+0
	sty VARTAB+1

	// For VERIFY - this is it

	lda VERCKB
	bne_16 execute_statements

	// C64 BASIC apparently does not clear variables after a LOAD in the
	// middle of a program. For safety, we do.
	jsr basic_do_clr

	// Now relink the loaded program, as we cannot trust the line
	// links supplied. For example, the VICE virtual drive emulation
	// always supplies $0101 as the address of the next line

	jsr LINKPRG
	
	// Now we either start the program from the beginning,
	// or go back to the READY prompt if LOAD was called from direct mode.

	// Reset to start of program
	jsr init_oldtxt

	// If loading was done when running a program - run it

	ldx CURLIN+1
	inx
	beq cmd_load_end                   // branch if direct mode

	jmp execute_line

cmd_load_end:

	jmp basic_main_loop
