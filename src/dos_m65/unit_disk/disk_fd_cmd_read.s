
;
; Read more data into the buffer
;


disk_f0_cmd_READ:

	; XXX provide implementation

disk_f1_cmd_READ:

	; XXX provide implementation

disk_f__cmd_READ:

	lda F0_MODE
	cmp #$03
	+beq fs_cbm_nextfileblock

	lda F0_DIR_PHASE
	cmp #$01
	+beq fs_cbm_read_dir
	cmp #$02
	+beq fs_cbm_read_dir_blocksfree

	sec ; mark EOI
	rts
