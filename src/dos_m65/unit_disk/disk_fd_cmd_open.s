
;
; Open file for reading
;

; XXX add support for both floppies


disk_xx_cmd_OPEN:

	lda #$01                 ; mode: receive command or file name
	ldx PAR_FSINSTANCE
	sta XX_MODE, x

	jmp dos_EXIT_CLC

disk_fd_cmd_OPEN_EOI:

	; XXX this dispatcher is temporary

	; Erase filter pattern     XXX this should be moved to common part

	ldy #$0F
	lda #$A0
@lp1:
	sta PAR_FPATTERN, y
	dey
	bpl @lp1

	ldx PAR_FSINSTANCE
	cmp #$02
	beq @f1
	bcs @rd

	lda F0_CMDFN_BUF
	+skip_2_bytes_trash_nvz
@f1:
	lda F1_CMDFN_BUF
	+skip_2_bytes_trash_nvz
@rd:
	lda RD_CMDFN_BUF

	cmp #'$'
	beq disk_fd_cmd_OPEN_dir           ; XXX add support for second floppy and RAM disk

	; FALLTROUGH

disk_fd_cmd_OPEN_file:

	; XXX add support for second floppy and RAM disk

	; Copy the filter from command     XXX this should be moved to common part and deduplicated with directory opening

	ldy #$00
@lp1:
	lda F0_CMDFN_BUF, y
	cmp #$A0
	beq @lp1_end
	sta PAR_FPATTERN, y
	iny
	cpy #$10
	bne @lp1

@lp1_end:

	jmp fs_cbm_read_file_open


disk_fd_cmd_OPEN_dir:

	lda #$02                 ; mode: read directory
	sta F0_MODE

	; Copy the filter from command     XXX this should be moved to common part and deduplicated with file opening

	ldy #$00
@lp1:
	lda F0_CMDFN_BUF+1, y
	cmp #$A0
	beq @lp1_end
	sta PAR_FPATTERN, y
	iny
	cpy #$10
	bne @lp1

@lp1_end:

	jmp fs_cbm_read_dir_open
