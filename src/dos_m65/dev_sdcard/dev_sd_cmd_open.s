
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

	; XXX this should be moved to common part

	; Erase filter pattern for the directory

	ldy #$0F
	lda #$A0
@lp1:
	sta PAR_FPATTERN, y
	dey
	bpl @lp1

	; Copy the filter from command

	ldy #$00
@lp2:
	lda SD_CMDFN_BUF+1, y
	cmp #$A0
	beq @lp2_end
	sta PAR_FPATTERN, y
	iny
	cpy #$10
	bne @lp2

@lp2_end:

	jmp fs_hvsr_read_dir_open
