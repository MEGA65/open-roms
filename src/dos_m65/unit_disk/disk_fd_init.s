
;
; Initializes DOS part of floppy controller
;


disk_fd_init:

	; Copy status string

	ldx #$00

	stx F0_STATUS_IDX
	stx F0_CMDFN_IDX
	stx F0_MODE
	stx F0_ACPTR_LEN+0
	stx F0_ACPTR_LEN+1
	stx F0_ACPTR_PTR+0
	stx F0_ACPTR_PTR+1

	stx F1_STATUS_IDX
	stx F1_CMDFN_IDX
	stx F1_MODE
	stx F1_ACPTR_LEN+0
	stx F1_ACPTR_LEN+1
	stx F1_ACPTR_PTR+0
	stx F1_ACPTR_PTR+1

	dex
@1:
	inx
	lda dos_sts_init_floppy,x
	sta F0_STATUS_BUF,x
	sta F1_STATUS_BUF,x
	bne @1

	; Initialize the controller

	lda #$80       ; default track stepping rate
	sta FDC_STEP
	lda #$FF
	sta FDC_CLOCK

	; End of initialization

	rts
