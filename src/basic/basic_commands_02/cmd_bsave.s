;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_bsave:

	; Set default device and secondary address

	jsr helper_load_init_params_no_VERCKB

	; Fetch the file name

	jsr helper_load_fetch_filename
	+bcs do_MISSING_FILENAME_error

	; Fetch device number

	jsr helper_load_fetch_devnum
	+bcs do_SYNTAX_error

	; Fetch memory area start address

	jsr helper_bload_fetch_address

	+phx_trash_a
	+phy_trash_a

	; Fetch memory area end address

	jsr helper_bload_fetch_address

	pla
	sta LINNUM+1
	pla
	sta LINNUM+0

	lda #LINNUM

	; Perform SAVE - reuse regular command

	jmp cmd_save_do
