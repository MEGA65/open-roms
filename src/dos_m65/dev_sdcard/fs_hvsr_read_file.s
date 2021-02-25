
;
; Hypervisor virtual filesystem - opening the file
;


fs_hvsr_read_file_open:

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

	; Read dirent structures into $1000, find the first matching file
	; Starting at $1000 VIC sees chargen, so this should be a safe place

	jsr fs_hvsr_direntmem_prepare

@lp_find:

	jsr fs_hvsr_util_nextdirentry      ; fetch the next file name
	+bcs fs_hvsr_file_not_found

	; Only accept files of type 'PRG'

	lda PAR_FTYPE
	and #%10111111 
	cmp #$02
	bne @lp_find

	; Check if file name matches the filter

	jsr util_dir_filter
	bne @lp_find                       ; if does not match, try the next entry

	; Found the file - load it

	; XXX provide implementation



	jmp dos_EXIT


fs_hvsr_file_not_found:

	jsr fs_hvsr_direntmem_restore     ; restore $1000 memory content

    ldx SD_DESC
	lda #$16                          ; dos_closedir
	sta HTRAP00
	+nop

	lda #39                           ; file not found error
	jsr util_status_SD

	jmp dos_EXIT_SEC
