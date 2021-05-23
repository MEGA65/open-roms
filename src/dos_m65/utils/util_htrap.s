
; Size-optimized hypervisor interaction code


util_htrap_dos_opendir:

	lda #$12
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

util_htrap_dos_readddir:

	lda #$14
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

util_htrap_dos_closedir:

	lda #$16
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

util_htrap_dos_openfile:

	lda #$18
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

util_htrap_dos_closefile:

	lda #$20
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

util_htrap_dos_closeall:

	lda #$22
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

util_htrap_dos_setname:

	lda #$2E
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

util_htrap_dos_findfile:

	lda #$34
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

util_htrap_dos_cdrootdir:

	lda #$3C
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

util_htrap_dos_readfile:     ; make sure this is the fastest to execute

	lda #$1A

	sta HTRAP00
	+nop                     ; NOP required by hypervisor

	rts
