
;
; Initializes DOS part of ram disk
;


unit_rd_init:

	; Copy status string

	ldx #$00
	stx RD_STATUS_IDX
	stx RD_CMDFN_IDX
	stx RD_MODE
	stx RD_ACPTR_LEN+0
	stx RD_ACPTR_LEN+1
	stx RD_ACPTR_PTR+0
	stx RD_ACPTR_PTR+1
	dex
@1:
	inx
	lda dos_sts_init_ramdisk,x
	sta RD_STATUS_BUF,x
	bne @1

	; End of initialization, now try to load the initial RAM disk; first set file name

	ldx #<ramdisk_filename
	ldy #>ramdisk_filename

	lda #$2E                           ; dos_setname
	sta HTRAP00
	+nop

	; Try to find the file

	jsr fs_vfs_direntmem_prepare

	ldy #>FS_HVSR_DIRENT  ; XXX is it needed?

	lda #$30                           ; dos_findfirst
	sta HTRAP00
	+nop

	bcc @error_not_found               ; branch if file not found    XXX why it can't find the file?

	; XXX load the file




	lda #$20                           ; dos_closefile
	sta HTRAP00
	+nop

	jsr fs_vfs_direntmem_restore

	; End of initialization

	rts


@error_not_found:


	; XXX set information about file not found

	jmp fs_vfs_direntmem_restore
