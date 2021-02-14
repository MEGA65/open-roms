
;
; Read more data into the buffer
;


dev_sd_cmd_READ:

	; XXX provide implementation for regular files

	lda SD_DIR_PHASE
	cmp #$01
	beq dev_sd_cmd_READ_dir_blocksfree

	sec ; mark EOI
	rts


dev_sd_cmd_READ_dir_blocksfree:

	lda #$13
	sta SD_ACPTR_LEN+0
	lda #$00
	sta SD_ACPTR_LEN+1

	lda #<dir_end
	sta SD_ACPTR_PTR+0
	lda #>dir_end
	sta SD_ACPTR_PTR+1

	clc
	rts
