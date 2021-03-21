
;
; Read more data into the buffer
;


unit_sd_cmd_READ:

	lda SD_MODE
	cmp #$03
	+beq fs_vfs_nextfileblock

	lda SD_DIR_PHASE
	cmp #$01
	+beq fs_vfs_read_dir
	cmp #$02
	+beq fs_vfs_read_dir_blocksfree

	sec ; mark EOI
	rts
