
;
; Initializes DOS part of SD card
;


card_sd_init:

	; Copy initial status string

	ldx #$00
	stx SD_STATUS_IDX
	stx SD_CMDFN_IDX
	stx SD_MODE
	stx SD_ACPTR_LEN+0
	stx SD_ACPTR_LEN+1
	stx SD_ACPTR_PTR+0
	stx SD_ACPTR_PTR+1
	stx SD_DIR_PHASE
	dex
@1:
	inx
	lda dos_sts_init_sdcard,x
	sta SD_STATUS_BUF,x
	bne @1

	; Close all the files in the hypervisor, go to root directory

	jsr util_htrap_dos_closeall
	jmp util_htrap_dos_cdrootdir
