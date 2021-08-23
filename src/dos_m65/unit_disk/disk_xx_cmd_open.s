
;
; Open file for reading
;

; XXX add support for both floppies


disk_xx_cmd_OPEN:

	lda #$01                 ; mode: receive command or file name
	ldx PAR_FSINSTANCE
	sta XX_MODE, x

	jmp dos_EXIT_CLC

disk_xx_cmd_OPEN_EOI:

	; XXX this dispatcher needs improvements to handle more of the syntax

	; Erase filter pattern

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

	; FALLTROUGH

	lda F0_CMDFN_BUF
	cmp #'$'
	beq disk_f0_cmd_OPEN_dir 
	bra disk_f0_cmd_OPEN_file
@f1:
	lda F1_CMDFN_BUF
	cmp #'$'
	beq disk_f1_cmd_OPEN_dir 
	bra disk_f1_cmd_OPEN_file
@rd:
	lda RD_CMDFN_BUF
	cmp #'$'
	beq disk_rd_cmd_OPEN_dir

	; FALLTROUGH


disk_rd_cmd_OPEN_file:

	; Copy the filter from command
	ldy #$00
@lp1:
	lda RD_CMDFN_BUF, y
	jsr disk_xx_cmd_OPEN_file_common
	bne @lp1

	jmp fs_cbm_read_file_open


disk_f0_cmd_OPEN_file:

	; Copy the filter from command
	ldy #$00
@lp1:
	lda F0_CMDFN_BUF, y
	jsr disk_xx_cmd_OPEN_file_common
	bne @lp1

	jmp fs_cbm_read_file_open


disk_f1_cmd_OPEN_file:

	; Copy the filter from command
	ldy #$00
@lp1:
	lda F1_CMDFN_BUF, y
	jsr disk_xx_cmd_OPEN_file_common
	bne @lp1

	jmp fs_cbm_read_file_open


disk_rd_cmd_OPEN_dir:

	lda #$02
	sta RD_MODE

	; Copy the filter from command
	ldy #$00
@lp1:
	lda RD_CMDFN_BUF+1, y
	jsr disk_xx_cmd_OPEN_dir_common
	bne @lp1

@lp1_end:

	jmp fs_cbm_read_dir_open


disk_f0_cmd_OPEN_dir:

	lda #$02
	sta F0_MODE

	; Copy the filter from command
	ldy #$00
@lp1:
	lda F0_CMDFN_BUF+1, y
	jsr disk_xx_cmd_OPEN_dir_common
	bne @lp1

	jmp fs_cbm_read_dir_open


disk_f1_cmd_OPEN_dir:

	lda #$02
	sta F1_MODE

	; Copy the filter from command
	ldy #$00
@lp1:
	lda F1_CMDFN_BUF+1, y
	jsr disk_xx_cmd_OPEN_dir_common
	bne @lp1

	jmp fs_cbm_read_dir_open



disk_xx_cmd_OPEN_file_common:

	; Common part of filter copy loop

	cmp #$A0
	+beq fs_cbm_read_file_open
	sta PAR_FPATTERN, y
	iny
	cpy #$10

	rts


disk_xx_cmd_OPEN_dir_common:

	cmp #$A0
	+beq fs_cbm_read_dir_open
	sta PAR_FPATTERN, y
	iny
	cpy #$10

	rts
