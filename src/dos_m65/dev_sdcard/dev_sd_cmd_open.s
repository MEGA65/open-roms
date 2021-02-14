
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
	cmp '$'
	beq dev_sd_cmd_OPEN_dir

	; XXX implement for file names

	jmp dos_EXIT_SEC


dev_sd_cmd_OPEN_dir:

	; XXX add support for filtering

	; Initialize 1st directory phase - header

	lda #$01
	sta SD_DIR_PHASE

	; Provide pointer and length of the header

	lda #$20
	sta SD_ACPTR_PTR+0
	lda #$00
	sta SD_ACPTR_PTR+1

	lda #<dir_hdr_sd
	sta SD_ACPTR_PTR+0
	lda #>dir_hdr_sd
	sta SD_ACPTR_PTR+1

	; End

	jmp dos_EXIT
