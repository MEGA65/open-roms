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

	// Set default device and secondary address; channel is not important now

	jsr select_device
	ldy #$00                           // secondary address
	jsr JSETFLS

	// Fetch the file name

	jsr fetch_filename
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
	lda VERCKB    // LOAD or VERIFY

	jsr JLOAD
	jsr cmd_load_save_handle_result
	
cmd_load_no_error:

	// Store last loaded address

	stx VARTAB+0
	sty VARTAB+1

	// For VERIFY - this is it

	lda VERCKB
	bne cmd_load_end

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

	jmp basic_execute_from_current_line

cmd_load_end:

	jmp basic_main_loop


//
// Handle result from Kernal - common for LOAD/VERIFY/SAVE
//

cmd_load_save_handle_result:

	php
	pha
	jsr print_return
	pla
	plp
	bcs_16 do_kernal_error

	rts
