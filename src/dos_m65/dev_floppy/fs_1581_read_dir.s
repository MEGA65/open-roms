
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

	; Make sure the 1st sector in buffer points to 2nd one

	lda #40
	sta SHARED_BUF_1+0
	lda #03
	sta SHARED_BUF_1+1

	; End

	jmp dos_EXIT_CLC


fs_1581_read_dir:

	lda FD_DIRENT

	; If first entry within sector - make sure it is present within the buffer

	cmp #$08
	beq @get_sector_lo
	cmp #$10
	+beq @get_sector_hi

	; FALLTROUGH

@cont:

	; Set address of the RAW directory entry

	ldy #>SHARED_BUF_1
	sty par_LDA_nnnn_Y+1

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
	beq fs_1581_read_dir               ; ignore deleted files (but allow DEL files in some cases)

	tax
	and #%00111111                     ; for checking, filter out special bits
	cmp #$06
	bcs fs_1581_read_dir               ; ignore unknown file types

	stx PAR_FTYPE

	ldy #$1E                           ; now get file size in blocks
	jsr code_LDA_nnnn_Y
	sta PAR_FSIZE_BLOCKS+0
	iny
	jsr code_LDA_nnnn_Y
	sta PAR_FSIZE_BLOCKS+1

	ldy #$05                           ; copy the file name
@lp1:
	jsr code_LDA_nnnn_Y
	sta PAR_FNAME-5,y
	iny
	cpy #$15
	bne @lp1

	; Prepare output entry, starting from XX_DIRENT_BUF + initial offset

	jsr util_dir_filesize_blocks
	ldx #(FD_DIRENT_BUF - XX_DIRENT_BUF)
	ldx #$30
	jsr util_dir_basic

	; Provide pointers and length

	sta FD_ACPTR_LEN+1
	txa
	sec
	sbc #$30
	sta FD_ACPTR_LEN+0

	lda #<(FD_DIRENT_BUF)
	sta FD_ACPTR_PTR+0
	lda #>(FD_DIRENT_BUF)
	sta FD_ACPTR_PTR+1
	clc
	rts

@get_sector_lo:

	; Check if this was the last sector

	lda SHARED_BUF_1+0
	beq fs_1581_read_dir_blocksfree
	lda SHARED_BUF_1+1
	cmp #$FF
	beq fs_1581_read_dir_blocksfree

	; Transition from 1st half of the buffer, to (possibly) the second one
	
	lda SHARED_BUF_1+0
	cmp BUFTAB_TRACK+1
	bne @get_sector_lo_next

	lda SHARED_BUF_1+1	
	dec
	cmp BUFTAB_SECTOR+1
	bne @get_sector_lo_next

	; It's OK, we can transition to the upper half of the buffer

	lda FD_DIRENT
	jmp @cont

@get_sector_lo_next:

	lda SHARED_BUF_1+0
	sta PAR_TRACK
	lda SHARED_BUF_1+1
	sta PAR_SECTOR
	bra @get_sector_common

@get_sector_hi:

	; Check if this was the last sector

	lda SHARED_BUF_1+$100+0
	beq fs_1581_read_dir_blocksfree
	lda SHARED_BUF_1+$100+1
	cmp #$FF
	beq fs_1581_read_dir_blocksfree

	; Load new sector

	lda SHARED_BUF_1+$100+0
	sta PAR_TRACK
	lda SHARED_BUF_1+$100+1
	sta PAR_SECTOR

@get_sector_common:

	jsr dev_fd_util_readsector         ; XXX handle read errors

	; Set new FD_DIRENT

	lda PAR_SECTOR
	and #$01
	beq @2
	lda #$08
@2:
	sta FD_DIRENT
	jmp @cont

fs_1581_read_dir_blocksfree:

	; XXX calculate free blocks from BAM instead

	; Set pointer to 'BLOCKS FREE.' line

	lda #$13
	sta FD_ACPTR_LEN+0
	lda #$00
	sta FD_ACPTR_LEN+1

	lda #<dir_end
	sta FD_ACPTR_PTR+0
	lda #>dir_end
	sta FD_ACPTR_PTR+1

	; Mark end of directory

	lda #$00
	sta FD_DIR_PHASE

	clc
	rts
