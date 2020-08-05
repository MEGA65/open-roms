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
	jsr helper_load_setnam_any         // if no file name found, use "*"

	// Fetch the file name

	jsr helper_load_fetch_filename
	bcs !+

	// Try to fetch device number and secondary address

	jsr helper_load_fetch_devnum
	bcs !+
	jsr helper_load_fetch_secondary
!:
	// FALLTROUGH

cmd_load_got_params:                   // input for tape wedge

	// Perform loading

	ldy TXTTAB+1
	ldx TXTTAB+0

	lda VERCKB    // LOAD or VERIFY
	jsr JLOAD
	bcs_16 do_kernal_error
	
cmd_load_no_error:

	// Store last loaded address

	stx VARTAB+0
	sty VARTAB+1

	// For VERIFY - this is it

	lda VERCKB
	bne_16 end_of_statement

	// C64 BASIC apparently does not clear variables after a LOAD in the
	// middle of a program. For safety, we do.
	jsr do_clr

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

	beq_16 end_of_program              // branch if direct mode
	
	pha
	pha
	jmp execute_line
