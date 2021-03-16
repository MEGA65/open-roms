
;
; CBM/CMD filesystem - helper routine to get the next directory entry
;


; Fills-in: PAR_FNAME, PAR_FTYPE, PAR_FSIZE_BYTES



; XXX work-in-progress, this should be used within directory reading code

fs_cbm_nextdirentry:

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

	ldy #$00                           ; start from getting track and sector of file beginning
	jsr code_LDA_nnnn_Y
	sta FD_LOADTRACK
	iny
	jsr code_LDA_nnnn_Y
	sta FD_LOADSECTOR

	iny                                ; determining file type
	jsr code_LDA_nnnn_Y
	beq fs_cbm_nextdirentry            ; ignore deleted files (but allow DEL files in some cases)

	tax
	and #%00111111                     ; for checking, filter out special bits
	cmp #$06
	bcs fs_cbm_nextdirentry            ; ignore unknown file types

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

	clc
	rts

@get_sector_lo:              ; processing the 1st half of the buffer finished

	; Check if this was the last sector

	lda SHARED_BUF_1+0
	beq @end_of_dir

	; Load the next sector
	
	sta PAR_TRACK	
	lda SHARED_BUF_1+1
	sta PAR_SECTOR

	bra @get_sector_common

@get_sector_hi:              ; processing the 2nd half of the buffer finished

	; Check if this was the last sector

	lda SHARED_BUF_1+$100+0
	beq @end_of_dir

	; Load the next sector

	sta PAR_TRACK
	lda SHARED_BUF_1+$100+1
	sta PAR_SECTOR

@get_sector_common:

	jsr lowlevel_readsector         ; XXX handle read errors

	; Set new FD_DIRENT

	lda PAR_SECTOR
	and #$01
	beq @2
	lda #$08
@2:
	sta FD_DIRENT
	jmp @cont

@end_of_dir:

	sec
	rts