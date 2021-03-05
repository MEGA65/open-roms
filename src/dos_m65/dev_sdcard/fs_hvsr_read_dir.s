
;
; Hypervisor virtual filesystem - reading directory
;


fs_hvsr_read_dir_open:

	; Open the directory

	lda #$12                          ; dos_opendir
	sta HTRAP00
	+nop

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

fs_hvsr_read_dir:

	; Read dirent structure into $1000, process it, restore the memory content.
	; Starting at $1000 VIC sees chargen, so this should be a safe place

	jsr fs_hvsr_direntmem_prepare
	jsr fs_hvsr_util_nextdirentry
	jsr fs_hvsr_direntmem_restore      ; processor status is preserved

	; If nothing to read, output 'blocks free'

	+bcs fs_hvsr_read_dir_blocksfree

	; Check if file name matches the filter

	jsr util_dir_filter
	bne fs_hvsr_read_dir               ; if does not match, try the next entry

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

fs_hvsr_read_dir_blocksfree:

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
	lda #$16                          ; dos_closedir
	sta HTRAP00
	+nop

	clc
	rts

;
; Helper routines
;

fs_hvsr_direntmem_prepare:

	ldx #$00
@1:
	ldy $1000, x
	sty SD_MEMSHADOW_BUF, x
	inx
	bne @1

	rts

fs_hvsr_direntmem_restore:

	php

	ldx #$00
@1:
	ldy SD_MEMSHADOW_BUF, x
	sty $1000, x
	inx
	bne @1

	bne @1

	plp
	rts
