
;
; CBM/CMD virtual filesystem - reading the file
;


fs_cbm_read_file_open:

	; Get the first sector of the directory  XXX deduplicate code, create a separate open directory routine

	lda #40
	sta PAR_TRACK
	lda #$03
	sta PAR_SECTOR

	jsr lowlevel_readsector         ; XXX handle read errors

	; Set variables to point to the 1st directory entry in the 2nd sector of the buffer

	lda #$08
	sta FD_DIRENT

	; Make sure the 1st sector in buffer points to 2nd one

	lda #40
	sta SHARED_BUF_1+0
	lda #03
	sta SHARED_BUF_1+1

	; XXX deduplicate code above with fs_cbm_read_dir_open

	; Try to find the file, has to be PRG

@lp_find:

	jsr fs_cbm_nextdirentry
	+bcs dos_EXIT

	; Only accept files of type 'PRG', properly closed     XXX deduplicate with fs_vfs

	lda PAR_FTYPE
	and #%10111111 
	cmp #$82
	bne @lp_find

	; Check if file name matches the filter     XXX deduplicate with fs_vfs

	jsr util_dir_filter
	bne @lp_find                       ; if does not match, try the next entry

	; Found the file - load it, start from fetching initial track/sector

	inc $D020




	; XXX provide implementation, use FD_LOADTRACK and FD_LOADSECTOR

	jmp dos_EXIT_SEC

fs_cbm_read_file:

	; XXX provide implementation

	jmp dos_EXIT_SEC
