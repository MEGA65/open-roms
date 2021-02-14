
;
; Initializes DOS part of floppy controller
;


dev_fd_init:

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
	lda dos_err_init_floppy,x
	sta FD_STATUS_STR,x
	bne @1

	; End of initialization

	rts
