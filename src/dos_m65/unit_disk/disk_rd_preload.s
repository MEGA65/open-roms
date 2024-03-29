
;
; Preload RAM disk image from SD card
;


!addr __stoptrack = RD_DIR_PHASE       ; helper value for detecting too large image


disk_rd_preload:

	; Check if RAM disk is enabled (should be disabled if no Hyper RAM is present)

	lda UNIT_RAMDISK
	+beq disk_rd_preload_err_common_noclose

	; Select SD card buffer

	lda #$80
	tsb SD_BUFCTL

	; Set file name

	jsr util_shadow
	ldx #$FF
@lp1:
	inx
	lda ramdisk_filename, x
	sta MEM_BUF, x
	bne @lp1

	ldy #>MEM_BUF
	ldx #<MEM_BUF
	jsr util_htrap_dos_setname
	jsr util_shadow_restore

	+bcc @error_not_found              ; branch if error

	; Try to find the file

	jsr util_htrap_dos_findfile
	+bcc @error_not_found              ; branch if file not found

	; Calculate maximum amount of tracks possible to load

	; XXX clean this up, for the loop counter it should be enough to use DMAJOB_DST_ADDR

	lda #$FF
	sta RD_MAXTRACK                    ; maximum track number of loaded image, for now set $FF
	sta __stoptrack

	lda RAM_ATTIC
	beq @added_attic
	jsr disk_rd_preload_addram

@added_attic:

	lda RAM_CELLAR
	beq @added_cellar
	jsr disk_rd_preload_addram

@added_cellar:

	; Load the image

	lda #$08                           ; set the ram disk start address
	sta DMAJOB_DST_MB
	lda #$00
	sta DMAJOB_DST_ADDR+0
	sta DMAJOB_DST_ADDR+1
	lda RD_STARTSEG
	sta DMAJOB_DST_ADDR+2

	jsr util_htrap_dos_openfile
	sta SD_DESC                        ; XXX consider using separate variable

	lda #$FF
	sta RD_MAXTRACK

	bra @load_track_check_done

@load_track:

	lda RD_MAXTRACK
	cmp __stoptrack
	beq @load_image_mem_full
	inc DMAJOB_DST_ADDR+2

@load_track_check_done:

	inc RD_MAXTRACK                    
	ldx #$00                           ; counter of 512-byte blocks to load

@load_track_loop:

	phx

	; Read 512 bytes

	jsr util_htrap_dos_readfile

	cpx #$00
	bne @error_wrong_size_plx          ; file size not multiplicity of 64K

	cpy #$00
	beq @load_image_end

	cpy #$02
	bne @error_wrong_size_plx          ; file size not multiplicity of 64K

	jsr util_dma_launch_from_hwbuf     ; copy data to Hyper RAM

	inc DMAJOB_DST_ADDR+1              ; advance pointer to the next block
	inc DMAJOB_DST_ADDR+1

	; Next 512-byte block or next track

	plx
	inx
	inx
	bne @load_track_loop               ; next 512-byte block of the same track

	bra @load_track                    ; next track

@load_image_mem_full:

	; Make sure this is the end of the file

	jsr util_htrap_dos_readfile

	cpx #$00
	bne @error_too_large
	cpy #$00
	bne @error_too_large

@load_image_end:

	plx
	cpx #$00
	bne @error_wrong_size              ; file empty or file size not multiplicity of 64K

	lda RD_MAXTRACK
	cmp #$02
	bcc @error_wrong_size              ; file too small, at least 128K required

	ldx SD_DESC
	jsr util_htrap_dos_closefile

	; End of initialization

	lda #$FF
	sta RD_VALIDIMG                    ; mark image as valid

	lda #$00                           ; temporary storage needs to be restored to 0
	sta __stoptrack

	lda #$00                           ; set message to OK
	sta RD_MSG

	rts



@error_wrong_size_plx:

	plx

@error_wrong_size:

	lda #$01
	jmp disk_rd_preload_err_common

@error_too_large:

	lda #$02
	jmp disk_rd_preload_err_common

@error_not_found:

	lda #$03
	sta RD_MSG

	jmp disk_rd_preload_err_common_noclose


disk_rd_preload_err_common:

	sta RD_MSG                         ; set code for startup screen

	jsr util_htrap_dos_closefile       ; XXX set descriptor

	; FALLTROUGH

disk_rd_preload_err_common_noclose:

	lda #$00                           ; temporary storage needs to be restored to 0
	sta __stoptrack
	sta RD_VALIDIMG                    ; mark image as invalid

	rts



disk_rd_preload_addram:

	; Add allowed number of tracks due to attic/cellar block presence

	clc
	lda #$80
	adc __stoptrack
	sta __stoptrack
	rts
