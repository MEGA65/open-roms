
;
; CBM/CMD virtual filesystem - reading the file
;


fs_cbm_read_file_open:

	; Get the first sector of the directory

	lda #40
	sta PAR_TRACK
	lda #$03
	sta PAR_SECTOR

	jsr lowlevel_readsector         ; XXX handle read errors






	; XXX provide implementation

	jmp dos_EXIT_SEC

fs_cbm_read_file:

	; XXX provide implementation

	jmp dos_EXIT_SEC
