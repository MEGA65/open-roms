
;
; Read more data into the buffer
;


disk_xx_cmd_READ:

    ldx PAR_FSINSTANCE
	lda XX_MODE, x
	cmp #$03
	+beq fs_cbm_nextfileblock

	; Reading directory

	lda XX_DIR_PHASE, x
	cmp #$01
	+beq fs_cbm_read_dir
	cmp #$02
	+beq fs_cbm_read_dir_blocksfree

	sec ; mark EOI
	rts
