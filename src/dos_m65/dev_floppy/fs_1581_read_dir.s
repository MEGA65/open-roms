
;
; Hypervisor virtual filesystem - reading directory
;


fs_1581_read_dir_open:

	; Try to read track 40, sector 0 (disk header)

	lda #40
	sta PAR_TRACK
	lda #$00
	sta PAR_SECTOR

	jsr dev_fd_util_readsector         ; XXX handle read errors





	; XXX continue implementation

	jmp dos_EXIT_CLC
