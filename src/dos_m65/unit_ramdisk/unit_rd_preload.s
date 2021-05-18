
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

	; Load the image

	lda #$FF
	sta RD_MODE                        ; mark for nothing loaded

@load_track:

	inc RD_MAXTRACK                    ; XXX check against __stoptrack - detect file too llarge
	ldx #$FF                           ; counter of 512-byte blocks to load

@load_track_loop:

	phx

	; Read 512 bytes

	lda #$1A                           ; dos_readfile
	sta HTRAP00
	+nop

	cpx #$00
	bne @error_wrong_size_plx          ; file size not multiplicity of 64K

	cpy #$00
	beq @load_image_end

	cpy #$02
	bne @error_wrong_size_plx          ; file size not multiplicity of 64K

	stx RD_MODE                        ; .X should be 0 - mark that something was actually loaded

	plx
	inx

	; XXX launch DMA job to copy data

	cpx #$7F
	bne @load_track_loop               ; next 512-byte block of the same track

	bra @load_track                    ; next track

@load_image_end:

	plx
	cpx #$7F
	bne @error_wrong_size              ; file empty or file size not multiplicity of 64K

	lda RD_MAXTRACK
	cmp #$02
	bcc @error_wrong_size              ; file too small, at least 128K required

	lda #$20                           ; dos_closefile
	sta HTRAP00
	+nop

	; End of initialization

	lda #$FF
	sta RD_VALIDIMG                    ; mark image as valid

	lda #$00                           ; temporary storage needs to be restored to 0
	sta __stoptrack

	rts



@error_wrong_size_plx:

	plx

@error_wrong_size:

	jsr unit_rd_preload_err_common

	; XXX set error information

	rts


@error_not_found:

	jsr unit_rd_preload_err_common_noclose

	; XXX set error information, put 0 to __stoptrack

	rts

@error_no_ramdisk:

	jsr unit_rd_preload_err_common_noclose

	; XXX set error information, put 0 to __stoptrack

	rts



unit_rd_preload_err_common:

	lda #$20                           ; dos_closefile
	sta HTRAP00
	+nop

	; FALLTROUGH

unit_rd_preload_err_common_noclose:

	lda #$00                           ; temporary storage needs to be restored to 0
	sta __stoptrack
	sta RD_VALIDIMG                    ; mark image as invalid

	rts



unit_rd_preload_addram:

	; Add allowed number of tracks due to attic/cellar block presence

	clc
	lda #$80
	adc __stoptrack
	sta __stoptrack
	rts
