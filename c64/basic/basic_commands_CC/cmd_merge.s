// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_merge:

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
	// Fetch device number

	jsr fetch_coma_uint8
	bcs !+

	sta FA
!:
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

	jmp cmd_load_loadmerge                    // XXX check variable handling (VARTAB) after failure to load
