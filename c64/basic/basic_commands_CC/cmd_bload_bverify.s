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

	jsr helper_load_fetch_filename
	bcc !+

	// No filename supplied - this should only be allowed for tape (device number below 8)

	lda FA
	and #%11111000
	bne_16 do_MISSING_FILENAME_error

	lda #$00
	sta FNLEN
!:
	// XXX finish the implementation

	jmp do_NOT_IMPLEMENTED_error
