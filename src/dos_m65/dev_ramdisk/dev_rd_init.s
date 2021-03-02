
;
; Initializes DOS part of ram disk
;


dev_rd_init:

	; Copy status string

	ldx #$00
	stx RD_STATUS_IDX
	stx RD_CMDFN_IDX
	stx RD_MODE
	stx RD_ACPTR_LEN+0
	stx RD_ACPTR_LEN+1
	stx RD_ACPTR_PTR+0
	stx RD_ACPTR_PTR+1
	dex
@1:
	inx
	lda dos_sts_init_ramdisk,x
	sta RD_STATUS_BUF,x
	bne @1

	; End of initialization

	rts
