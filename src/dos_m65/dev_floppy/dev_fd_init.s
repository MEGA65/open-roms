
;
; Initializes DOS part of floppy controller
;


dev_fd_init:

	; Copy status string

	ldx #$00
	stx FD_STATUS_IDX
	stx FD_CMDFN_IDX
	stx FD_MODE
	dex
@1:
	inx
	lda dos_err_init_floppy,x
	sta FD_STATUS_STR,x
	bne @1

	; End of initialization

	rts
