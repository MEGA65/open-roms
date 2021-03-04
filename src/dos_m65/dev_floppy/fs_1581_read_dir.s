
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

	; Copy 1st BAM sector to the cache

	ldx #$00
@lp3:
	lda SHARED_BUF_1+$100, x
	sta FD_BAM_CACHE_0,x
	inx
	bne @lp3

	; Load the next pair of sectors

	lda #$02
	sta PAR_SECTOR

	jsr dev_fd_util_readsector         ; XXX handle read errors

	; Copy 2nd BAM sector to the cache

	ldx #$00
@lp4:
	lda SHARED_BUF_1, x
	sta FD_BAM_CACHE_0+$100,x
	inx
	bne @lp4

	; Set variables to point to the 1st directory entry in the 2nd sector of the buffer

	lda #$08
	sta FD_DIRENT

	; End

	jmp dos_EXIT_CLC


fs_1581_read_dir:

	lda FD_DIRENT

	; If first entry within sector - make sure it is present within the buffer

	cmp #$08
	beq @get_sector_lo
	cmp #$10
	beq @get_sector_hi

	; FALLTROUGH

fs_1581_read_dir_cont:

	; Set address of the RAW directory entry

	lda >SHARED_BUF_1
	sta par_LDA_nnnn_Y+1

	asl
	asl
	asl
	asl
	asl
	sta par_LDA_nnnn_Y+0

	bcc @1
	inc par_LDA_nnnn_Y+1
@1:
	; Set next directory entry

	inc FD_DIRENT

	; Copy data to parameter variables

	; XXX most likely copying is not necessary (compare all CBM and CMD filesystems) -
	; XXX just make the hypervisor file system emulate these structures

	ldy #$02                           ; start from determining file type
	jsr code_LDA_nnnn_Y

	tax
	and #%00111111                     ; for checking, filter out special bits
	beq fs_1581_read_dir               ; ignore deleted files
	cmp #$06
	bcs fs_1581_read_dir               ; ignore unknown file types

	stx PAR_FTYPE

	ldy #$1E                           ; now get file size in blocks
	jsr code_LDA_nnnn_Y
	sta PAR_FSIZE_BLOCKS+0
	iny
	jsr code_LDA_nnnn_Y
	sta PAR_FSIZE_BLOCKS+0

	ldy #$05                           ; copy the file name
@lp1:
	jsr code_LDA_nnnn_Y
	sta PAR_FNAME-5
	iny
	cpy #$15
	bne @lp1

	; 

	; XXX

@get_sector_lo:

	; XXX


@get_sector_hi:

	; XXX




	; XXX provide implementation

	jmp dos_EXIT_SEC


fs_1581_read_dir_blocksfree:

	; XXX provide implementation

	jmp dos_EXIT_SEC
