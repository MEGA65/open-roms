// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches file name for BLOAD/BVERIFY/MERGE, reports error if not found
//


helper_bload_fetch_filename:

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
	rts
