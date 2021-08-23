
;
; CBM/CMD virtual filesystem - reading directory
;


fs_cbm_read_dir_open:

	; Try to read track 40, sector 0 (disk header)

	lda #40
	sta PAR_TRACK
	lda #$00
	sta PAR_SECTOR

	jsr lowlevel_xx_readsector         ; XXX handle read errors

	; Create the first directory listing entry (title, id)

	ldx #$1F                           ; first fetch the template
@lp1:
	lda dir_hdr,x
	sta F0_DIRENT_BUF,x
	dex
	bpl @lp1

	ldx #$0F                           ; file name
@lp2:
	lda SHARED_BUF_1+$04,x
	sta F0_DIRENT_BUF+$08,x
	dex
	bpl @lp2

	lda SHARED_BUF_1+$16               ; disk ID   XXX test this on a disk with ID
	cmp #$A0
	beq @skip1
	sta F0_DIRENT_BUF+$1A
@skip1:	
	lda SHARED_BUF_1+$17
	cmp #$A0
	beq @skip2
	sta F0_DIRENT_BUF+$1B
@skip2:

	lda SHARED_BUF_1+$19               ; dos version
	sta F0_DIRENT_BUF+$1D
	lda SHARED_BUF_1+$1A
	sta F0_DIRENT_BUF+$1E

	; Provide pointer to the header

	lda #$20
	sta F0_ACPTR_LEN+0
	lda #$00
	sta F0_ACPTR_LEN+1

	lda #<F0_DIRENT_BUF
	sta F0_ACPTR_PTR+0
	lda #>F0_DIRENT_BUF
	sta F0_ACPTR_PTR+1

	; Set directory phase to 'file name'

	lda #$01
	sta F0_DIR_PHASE

	; Copy 1st BAM sector to the cache

	ldx #$00
@lp3:
	lda SHARED_BUF_1+$100, x
	sta F0_BAM_CACHE,x
	inx
	bne @lp3

	; Load the next pair of sectors

	lda #$02
	sta PAR_SECTOR

	jsr lowlevel_xx_readsector         ; XXX handle read errors

	; Copy 2nd BAM sector to the cache

	ldx #$00
@lp4:
	lda SHARED_BUF_1, x
	sta F0_BAM_CACHE+$100,x
	inx
	bne @lp4

	; Set variables to point to the 1st directory entry in the 2nd sector of the buffer

	lda #$08
	sta F0_DIRENT

	; Make sure the 1st sector in buffer points to 2nd one

	lda #40
	sta SHARED_BUF_1+0
	lda #03
	sta SHARED_BUF_1+1

	; End

	jmp dos_EXIT_CLC


fs_cbm_read_dir:

	jsr fs_cbm_nextdirentry
	bcs fs_cbm_read_dir_blocksfree     ; XXX handle errors

	jsr util_dir_filter                ; XXX consider moving these calls to fs_*_nextdirentry
	bne fs_cbm_read_dir                ; if does not match, try the next entry

	; Prepare output entry, starting from XX_DIRENT_BUF + initial offset

	jsr util_dir_filesize_blocks
	ldx #(F0_DIRENT_BUF - XX_DIRENT_BUF)
	ldx #$30
	jsr util_dir_basic

	; Provide pointers and length

	sta F0_ACPTR_LEN+1
	txa
	sec
	sbc #$30
	sta F0_ACPTR_LEN+0

	lda #<(F0_DIRENT_BUF)
	sta F0_ACPTR_PTR+0
	lda #>(F0_DIRENT_BUF)
	sta F0_ACPTR_PTR+1
	clc
	rts

fs_cbm_read_dir_blocksfree:

	; Copy the 'BLOCKS FREE' line

	ldx #$13
@lp1:
	lda dir_end, x
	sta F0_DIRENT_BUF, x
	dex
	bpl @lp1

	; Calculate free blocks from the BAM

	ldx #$10
@lp2:
	lda F0_BAM_CACHE+$100,x
	jsr @sub_free_add
	cpx #$FA
	beq @lp2_end
	lda F0_BAM_CACHE+$000,x
	jsr @sub_free_add
	inx
	inx
	inx
	inx
	inx
	inx
	bra @lp2

@lp2_end:

	; Set pointer and length

	lda #$13
	sta F0_ACPTR_LEN+0
	lda #$00
	sta F0_ACPTR_LEN+1

	lda #<F0_DIRENT_BUF
	sta F0_ACPTR_PTR+0
	lda #>F0_DIRENT_BUF
	sta F0_ACPTR_PTR+1

	; Mark end of directory

	lda #$00
	sta F0_DIR_PHASE

	clc
	rts


@sub_free_add:

	; Helper routine to calculate free blocks

	clc
	adc F0_DIRENT_BUF+2
	sta F0_DIRENT_BUF+2
	bcc @noinc
	inc F0_DIRENT_BUF+3
@noinc:
	rts
