
;
; Preload RAM disk image
;


dos_RDCHK:

	; Before the start make sure memory content is not damaged

	jsr dos_MEMCHK
	bcc @ok
	lda #$FF
	jmp dos_EXIT_SEC_A

@ok:
	jsr dos_ENTER

	lda RD_MSG              

	ldx #$FF                 ; reset the message after it gets displayed
	stx RD_MSG

	jmp dos_EXIT_CLC_A
