
;
; Read more data into the buffer
;


unit_fd_cmd_READ:

	lda FD_MODE
	cmp #$03
	+beq fs_cbm_read_file

	lda FD_DIR_PHASE
	cmp #$01
	+beq fs_cbm_read_dir
	cmp #$02
	+beq fs_cbm_read_dir_blocksfree

	sec ; mark EOI
	rts
