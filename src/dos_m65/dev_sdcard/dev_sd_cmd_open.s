
;
; Open file for reading
;


dev_sd_cmd_OPEN:

	lda #$01                 ; mode: receive command or file name
	sta SD_MODE

	jmp dos_EXIT

dev_sd_cmd_OPEN_EOI:

	; XXX this dispatcher is temporary

	; XXX add support for second card

	lda SD_CMDFN_BUF
	cmp #'$'
	beq dev_sd_cmd_OPEN_dir

	; XXX implement for file names

	jmp dos_EXIT_SEC


dev_sd_cmd_OPEN_dir:

	; Reset status to OK

	lda #$00
	jsr dos_status_00

	; Provide pointer to the header

	lda #$20
	sta SD_ACPTR_LEN+0
	lda #$00
	sta SD_ACPTR_LEN+1

	lda #<dir_hdr_sd
	sta SD_ACPTR_PTR+0
	lda #>dir_hdr_sd
	sta SD_ACPTR_PTR+1

	; Set directory phase to 'file name'

	lda #$01
	sta SD_DIR_PHASE

	; End

	jmp dos_EXIT
