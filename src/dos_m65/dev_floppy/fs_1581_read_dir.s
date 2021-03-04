
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

	; Create the first directory listing entry (title, id)

	ldx #$1F                           ; first fetch the template
@lp1:
	lda dir_hdr,x
	sta FD_DIRENT_BUF,x
	dex
	bpl @lp1

	ldx #$0F                           ; file name
@lp2:
	lda SHARED_BUF_1+$04,x
	sta FD_DIRENT_BUF+$08,x
	dex
	bpl @lp2

	lda SHARED_BUF_1+$16               ; disk ID   XXX test this on a disk with ID
	cmp #$A0
	beq @skip1
	sta FD_DIRENT_BUF+$1A
@skip1:	
	lda SHARED_BUF_1+$17
	cmp #$A0
	beq @skip2
	sta FD_DIRENT_BUF+$1B
@skip2:

	lda SHARED_BUF_1+$19               ; dos version
	sta FD_DIRENT_BUF+$1D
	lda SHARED_BUF_1+$1A
	sta FD_DIRENT_BUF+$1E

	; Provide pointer to the header

	lda #$20
	sta FD_ACPTR_LEN+0
	lda #$00
	sta FD_ACPTR_LEN+1

	lda #<FD_DIRENT_BUF
	sta FD_ACPTR_PTR+0
	lda #>FD_DIRENT_BUF
	sta FD_ACPTR_PTR+1

	; Set directory phase to 'file name'

	lda #$01
	sta FD_DIR_PHASE

	; XXX copy 1st half of BAM
	; XXX preload the next entry
	; XXX copy 2nd half of BAM

	; End

	jmp dos_EXIT_CLC
