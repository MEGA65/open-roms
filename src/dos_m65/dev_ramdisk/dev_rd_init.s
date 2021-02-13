
;
; Initializes DOS part of ram disk
;


dev_rd_init:

	; Copy status string

	ldx #$00
	stx RD_STATUS_IDX
	stx RD_CMDFN_IDX
	stx RD_MODE
	dex
@1:
	inx
	lda dos_err_init_ramdisk,x
	sta RD_STATUS_STR,x
	bne @1

	; End of initialization

	rts
