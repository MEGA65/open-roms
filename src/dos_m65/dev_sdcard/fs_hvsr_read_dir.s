
;
; Hypervisor virtual filesystem - reading directory
;


fs_hvsr_read_dir_open:

	; Read dirent structure into $1000 and then copy it to SD_DIRENT
	; Starting at $1000 VIC sees chargen, so this should be a safe place
	; Content of the original memory location will be preserved

	jsr fs_hvsr_dirent_swap

	ldx #$00 ; file descriptor; we use $00 for reading directory
	ldy #$10 ; target page number

	lda #$11                          ; dos_opendir
	sta HTRAP00
	+nop

	; XXX handle read errors

	jsr fs_hvsr_dirent_swap

	; Reset status to OK

	lda #$00
	jsr dos_status_00

	; Provide pointer to the header

	lda #$20
	sta SD_ACPTR_LEN+0
	lda #$00
	sta SD_ACPTR_LEN+1

	lda #<dir_hdr_sd
	sta SD_ACPTR_PTR+0
	lda #>dir_hdr_sd
	sta SD_ACPTR_PTR+1

	; Set directory phase to 'file name'

	lda #$01
	sta SD_DIR_PHASE

	; End

	jmp dos_EXIT

fs_hvsr_read_dir:

	jsr fs_hvsr_dirent_swap

	ldx #$00 ; file descriptor; we use $00 for reading directory
	ldy #$10 ; target page number

	lda #$12                          ; dos_readdir
	sta HTRAP00
	+nop

	; XXX handle read errors

	sta $400
	stx $401

	jsr fs_hvsr_dirent_swap


	jmp fs_hvsr_read_dir_blocksfree      ; XXX temporary

	; Dirent structure:
	; - 4 bytes - inode
	; - 2 bytes - ('off' - not sure what's this)
	; - 4 bytes - ('reclen' - is it file size?)
	; - 2 bytes - type

fs_hvsr_read_dir_blocksfree:

	; Set pointer to '0 BLOCKS FREE.' line

	lda #$13
	sta SD_ACPTR_LEN+0
	lda #$00
	sta SD_ACPTR_LEN+1

	lda #<dir_end
	sta SD_ACPTR_PTR+0
	lda #>dir_end
	sta SD_ACPTR_PTR+1

	; Mark end of directory

	lda #$00
	sta SD_DIR_PHASE

    ; .X = file descriptor

	; lda #$13                          ; dos_closedir
	; sta HTRAP00
	; +nop

	clc
	rts


;
; Helper routines
;

fs_hvsr_dirent_swap:

	ldx #$00
@1:
	lda $1000, x
	ldy SD_DIRENT, x
	sta SD_DIRENT, x
	sty $1000, x
	inx
	bne @1

	rts
