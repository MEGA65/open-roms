
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
	+beq fs_hvsr_read_dir_open

	; XXX implement for file names

	jmp dos_EXIT_SEC



