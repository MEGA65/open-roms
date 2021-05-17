
;
; Preload RAM disk image from SD card
;


!addr __stoptrack = RD_DIR_PHASE       ; helper value for detecting too large image


unit_rd_preload:

	; Check if RAM disk is enabled (should be disabled if no Hyper RAM is present)

	lda UNIT_RAMDISK
	beq @error_no_ramdisk

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

	; Calculate maximum amount of tracks possible to load

	lda #$FF
	sta RD_MAXTRACK                    ; maximum track number of loaded image, for now set $FF
	sta __stoptrack

	lda RAM_ATTIC
	beq @added_attic
	jsr unit_rd_preload_addram

@added_attic:

	lda RAM_CELLAR
	beq @added_cellar
	jsr unit_rd_preload_addram

@added_cellar:

	; Load the file





	; XXX load the file

	; XXX while loading set RD_MAXTRACK

@load_track:

	; XXX while loading set RD_MAXTRACK



	; lda #$20                           ; dos_closefile
	; sta HTRAP00
	; +nop

	; End of initialization

	lda #$FF
	sta RD_VALIDIMG                      ; mark image as valid

	lda #$00                             ; temporary storage needs to be restored to 0
	sta __stoptrack

	rts


@error_not_found:

	; XXX set error information

	rts

@error_no_ramdisk:

	; XXX set error information

	rts





unit_rd_preload_addram:

	; Add allowed number of tracks due to attic/cellar block presence

	clc
	lda #$80
	adc __stoptrack
	sta __stoptrack
	rts
