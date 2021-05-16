
;
; Open file for reading
;

; XXX add support for both floppies


unit_fd_cmd_OPEN:

	lda #$01                 ; mode: receive command or file name
	sta F0_MODE

	jmp dos_EXIT_CLC

unit_fd_cmd_OPEN_EOI:

	; XXX this dispatcher is temporary

	; Erase filter pattern     XXX this should be moved to common part

	ldy #$0F
	lda #$A0
@lp1:
	sta PAR_FPATTERN, y
	dey
	bpl @lp1

	; XXX add support for second floppy

	lda F0_CMDFN_BUF
	cmp #'$'
	beq unit_fd_cmd_OPEN_dir

	; FALLTROUGH

unit_fd_cmd_OPEN_file:

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


unit_fd_cmd_OPEN_dir:

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
