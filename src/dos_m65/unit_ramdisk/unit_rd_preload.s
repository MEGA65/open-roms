
;
; Preload RAM disk image from SD card
;


unit_rd_preload:

	; Check if RAM disk is enabled

	lda UNIT_RAMDISK
	beq @error_no_ramdisk

	; XXX make sure attic RAM is present

	rts ; XXX remove when code is fully implemented

	; Set file name

	ldy #>ramdisk_filename
	ldx #<ramdisk_filename
	lda #$2E                           ; dos_setname
	sta HTRAP00
	+nop
	bcc @error_not_found

	; Try to find the file

	lda #$34                           ; dos_findfile
	sta HTRAP00
	+nop
	bcc @error_not_found               ; branch if file not found

	; XXX load the file

	; XXX while loading set RD_MAXTRACK

@load_track:

	; XXX while loading set RD_MAXTRACK



	; lda #$20                           ; dos_closefile
	; sta HTRAP00
	; +nop

	; End of initialization

	rts


@error_not_found:

	; XXX set error information

	rts

@error_no_ramdisk:

	; XXX set error information

	rts
