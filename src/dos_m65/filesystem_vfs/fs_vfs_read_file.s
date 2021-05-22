
;
; Hypervisor virtual filesystem - reading the file
;


fs_vfs_read_file_open:

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

	; XXX deduplicate part above with opening directory

	; Read dirent structures into MEM_BUF, find the first matching file

	jsr util_shadow

@lp_find:

	jsr fs_vfs_nextdirentry            ; fetch the next file name
	+bcs fs_vfs_file_not_found

	; Only accept files of type 'PRG', properly closed

	lda PAR_FTYPE
	and #%10111111 
	cmp #$82
	bne @lp_find

	; Check if file name matches the filter

	jsr util_dir_filter
	bne @lp_find                       ; if does not match, try the next entry

	; Found the file - load it

	jsr util_shadow_restore            ; restore MEM_BUF memory content

	lda #$18                           ; dos_openfile
	sta HTRAP00
	+nop

	; XXX check error code

	; Read the first 512-byte chunk

	lda #$03                 ; mode: read file
	sta SD_MODE

	jsr fs_vfs_nextfileblock
	jmp dos_EXIT

