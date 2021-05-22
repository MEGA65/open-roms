
;
; Hypervisor virtual filesystem - helper routine to get the next file block
;


fs_vfs_nextfileblock:

	; Read chunk of data to SD card buffer

	ldx SD_DESC
	lda #$1A                           ; dos_readfile
	sta HTRAP00
	+nop

	; XXX check error code

	; Store number of bytes read

	stx SD_ACPTR_LEN+0
	sty SD_ACPTR_LEN+1

	; Check if any data was read

	tya
	ora SD_ACPTR_LEN+0
	bne @copy

	lda #$20                           ; dos_closefile
	sta HTRAP00
	+nop

	lda #$00
	sec
	rts

@copy:

	; Set pointer to new data

	lda #<SHARED_BUF_0
	sta SD_ACPTR_PTR+0
	lda #>SHARED_BUF_0
	sta SD_ACPTR_PTR+1

	; Copy data to SHARED_BUF_0

	lda #%10000000                     ; select SD card buffer
	tsb SD_BUFCTL

	; Copy data using DMA job

	lda #$00
	sta DMAJOB_DST_MB
	lda #<(SHARED_BUF_0 - $8000)
	sta DMAJOB_DST_ADDR+0
	lda #>(SHARED_BUF_0 - $8000)
	sta DMAJOB_DST_ADDR+1
	lda #$01
	sta DMAJOB_DST_ADDR+2

	jsr util_dma_launch_from_hwbuf     ; execute DMA job

	clc
	rts

fs_vfs_file_not_found:

	jsr util_shadow_restore            ; restore $1000 memory content

    ldx SD_DESC
	lda #$16                           ; dos_closedir
	sta HTRAP00
	+nop

	lda #39                            ; file not found error
	jsr util_status_SD

	lda #K_ERR_FILE_NOT_FOUND
	jmp dos_EXIT_SEC_A
