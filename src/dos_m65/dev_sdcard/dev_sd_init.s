
;
; Initializes DOS part of SD card
;


dev_sd_init:

	; Copy status string

	ldx #$00
	stx SD_STATUS_IDX
	stx SD_CMDFN_IDX
	dex
@1:
	inx
	lda dos_err_init_sdcard,x
	sta SD_STATUS_STR,x
	bne @1

	; End of initialization

	rts
