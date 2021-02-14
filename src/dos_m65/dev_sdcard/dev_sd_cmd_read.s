
;
; Read more data into the buffer
;


dev_sd_cmd_READ:

	; XXX provide implementation for regular files

	lda SD_DIR_PHASE
	cmp #$01
	+beq fs_hvsr_read_dir
	cmp #$02
	+beq fs_hvsr_read_dir_blocksfree

	sec ; mark EOI
	rts
