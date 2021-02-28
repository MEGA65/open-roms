
;
; Read more data into the buffer
;


dev_sd_cmd_READ:

	lda SD_MODE
	cmp #$03
	+beq fs_hvsr_read_file

	lda SD_DIR_PHASE
	cmp #$01
	+beq fs_hvsr_read_dir
	cmp #$02
	+beq fs_hvsr_read_dir_blocksfree

	sec ; mark EOI
	rts
