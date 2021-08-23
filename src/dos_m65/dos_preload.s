
;
; Preload RAM disk image
;


dos_PRELOAD:

	; Before the start make sure memory content is not damaged

	jsr dos_MEMCHK
	bcc @ok
	rts
@ok:
	jsr dos_ENTER
	jsr disk_rd_preload
	jmp dos_EXIT_CLC
