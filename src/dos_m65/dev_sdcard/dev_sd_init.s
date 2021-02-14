
;
; Initializes DOS part of SD card
;


dev_sd_init:

	; Copy initial status string

	ldx #$00
	stx SD_STATUS_IDX
	stx SD_CMDFN_IDX
	stx SD_MODE
	stx SD_ACPTR_LEN+0
	stx SD_ACPTR_LEN+1
	stx SD_ACPTR_PTR+0
	stx SD_ACPTR_PTR+1
	dex
@1:
	inx
	lda dos_err_init_sdcard,x
	sta SD_STATUS_STR,x
	bne @1

	; Close all the files in the hypervisor, go to root directory

	lda #$22                          ; dos_closeall
	sta HTRAP00
	+nop

	lda #$36                          ; dos_cdrootdir
	sta HTRAP00
	+nop

	; End of initialization

	rts
