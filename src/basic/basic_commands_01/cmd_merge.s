;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifndef HAS_SMALL_BASIC {

cmd_merge:

	lda #$00                           ; mark operation as LOAD
	jsr helper_load_init_params

	; Fetch the file name

	jsr helper_bload_fetch_filename

	; Fetch device number

	jsr helper_load_fetch_devnum

	; FALLTROUGH

cmd_merge_got_params:

	; Make sure VARTAB is correctly set

	jsr update_VARTAB_do_clr

	; Perform loading - just for a different address

	sec
	lda VARTAB+0
	sbc #$02
	sta VARTAB+0
	tax
	bcs @1
	dec VARTAB+1
@1:
	ldy VARTAB+1

	lda VERCKB    ; LOAD or VERIFY
	jsr JLOAD
	+bcs do_kernal_error

cmd_merge_no_error:

	; Relink loaded program, clear variables, execute next statement

	jmp update_LINKPRG_VARTAB_do_clr
}