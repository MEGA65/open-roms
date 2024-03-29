
;
; Open file for reading
;


card_sd_cmd_OPEN:

	lda #$01                 ; mode: receive command or file name
	sta SD_MODE

	jmp dos_EXIT_CLC

card_sd_cmd_OPEN_EOI:

	; XXX this dispatcher is temporary

	; Erase filter pattern     XXX this should be moved to common part

	ldy #$0F
	lda #$A0
@lp1:
	sta PAR_FPATTERN, y
	dey
	bpl @lp1

	lda SD_CMDFN_BUF
	cmp #'$'
	beq card_sd_cmd_OPEN_dir

	; FALLTROUGH

card_sd_cmd_OPEN_file:

	; Copy the filter from command     XXX this should be moved to common part and deduplicated with directory opening

	ldy #$00
@lp1:
	lda SD_CMDFN_BUF, y
	cmp #$A0
	beq @lp1_end
	sta PAR_FPATTERN, y
	iny
	cpy #$10
	bne @lp1

@lp1_end:

	jmp fs_vfs_read_file_open


card_sd_cmd_OPEN_dir:

	lda #$02                 ; mode: read directory
	sta SD_MODE

	; Copy the filter from command     XXX this should be moved to common part and deduplicated with file opening

	ldy #$00
@lp1:
	lda SD_CMDFN_BUF+1, y
	cmp #$A0
	beq @lp1_end
	sta PAR_FPATTERN, y
	iny
	cpy #$10
	bne @lp1

@lp1_end:

	jmp fs_vfs_read_dir_open
