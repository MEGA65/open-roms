
;
; Hypervisor virtual filesystem - reading directory
;


fs_vfs_read_dir_open:

	; Open the directory

	jsr util_htrap_dos_opendir

	; XXX handle read errors

	sta SD_DESC                       ; store directory descriptor  XXX invent better name

	; Reset status to OK

	lda #$00
	sta PAR_TRACK
	sta PAR_SECTOR
	jsr util_status_SD

	; Provide pointer to the header

	lda #$20
	sta SD_ACPTR_LEN+0
	lda #$00
	sta SD_ACPTR_LEN+1

	lda #<dir_hdr_sd
	sta SD_ACPTR_PTR+0
	lda #>dir_hdr_sd
	sta SD_ACPTR_PTR+1

	; Set directory phase to 'file name'

	lda #$01
	sta SD_DIR_PHASE

	; End

	jmp dos_EXIT_CLC

fs_vfs_read_dir:

	; Read dirent structure into MEM_BUF, process it, restore the memory content.

	jsr util_shadow
	jsr fs_vfs_nextdirentry
	jsr util_shadow_restore          ; processor status is preserved

	; If nothing to read, output 'blocks free'

	+bcs fs_vfs_read_dir_blocksfree

	; Check if file name matches the filter

	jsr util_dir_filter
	bne fs_vfs_read_dir               ; if does not match, try the next entry

	; Otherwise, convert the file length from bytes to blocks to display

	jsr util_dir_filesize_bytes

	; Prepare output entry, starting from XX_DIRENT_BUF + initial offset

	ldx #(SD_DIRENT_BUF - XX_DIRENT_BUF)
	jsr util_dir_basic

	; Provide pointers and length

	stx SD_ACPTR_LEN+0
	sta SD_ACPTR_LEN+1

	lda #<(SD_DIRENT_BUF)
	sta SD_ACPTR_PTR+0
	lda #>(SD_DIRENT_BUF)
	sta SD_ACPTR_PTR+1

	clc
	rts

fs_vfs_read_dir_blocksfree:

	; Set pointer to 'BLOCKS FREE.' line

	lda #$13
	sta SD_ACPTR_LEN+0
	lda #$00
	sta SD_ACPTR_LEN+1

	lda #<dir_end
	sta SD_ACPTR_PTR+0
	lda #>dir_end
	sta SD_ACPTR_PTR+1

	; Mark end of directory

	lda #$00
	sta SD_DIR_PHASE

	; Close the directory within the hypervisor  XXX maybe move it to close routine

    ldx SD_DESC
	jsr util_htrap_dos_closedir

	clc
	rts
