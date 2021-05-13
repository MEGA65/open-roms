
;
; Initializes DOS part of floppy controller
;


unit_fd_init:

	; Copy status string

	ldx #$00
	stx FD_STATUS_IDX
	stx FD_CMDFN_IDX
	stx FD_MODE
	stx FD_ACPTR_LEN+0
	stx FD_ACPTR_LEN+1
	stx FD_ACPTR_PTR+0
	stx FD_ACPTR_PTR+1
	dex
@1:
	inx
	lda dos_sts_init_floppy,x
	sta FD_STATUS_BUF,x
	bne @1

	; Initialize the controller

	lda #$80       ; default track stepping rate
	sta FDC_STEP
	lda #$FF
	sta FDC_CLOCK

	; End of initialization

	rts
