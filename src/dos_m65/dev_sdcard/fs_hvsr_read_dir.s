
;
; Hypervisor virtual filesystem - reading directory
;


fs_hvsr_read_dir_open:

	; Open the directory

	lda #$12                          ; dos_opendir
	sta HTRAP00
	+nop

	; XXX handle read errors

	sta SD_DIR_DESC                   ; store directory descriptor  XXX invent better name

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

	; Read dirent structure into $1000 and then copy it to SD_DIRENT
	; Starting at $1000 VIC sees chargen, so this should be a safe place
	; Content of the original memory location will be preserved

	jsr fs_hvsr_dirent_prepare

	ldx SD_DIR_DESC                   ; directory descriptor
	ldy #$10                          ; target page number

	lda #$13                          ; dos_readdir
	sta HTRAP00
	+nop

	jsr fs_hvsr_dirent_swap

	; If nothing to read, output 'blocks free'

	bcc fs_hvsr_read_dir_blocksfree

	; Dirent structure - important fields:
	; - $00-$3F - file name
	; - $40     - file name length
	; - $55     - file type and attributes

	; Validate entry

	; X check for directory!

	lda SD_DIRENT+$40
	sec
	sbc #$04                           ; strip 4 bytes - for dot and extension
	sta SD_DIRENT+$40
	bmi fs_hvsr_read_dir               ; if name too short, try next entry
	beq fs_hvsr_read_dir               ; if name too short, try next entry
	cmp #$11
	bcs fs_hvsr_read_dir               ; if stripped name is 17 characters or longer, try the next entry
	sta SD_DIRENT+$40                  ; store corrected file name length

	; Detect file type (+64 for read-only, +128 = damaged)
	; 0  = not supported
	; 1  = SEQ
	; 2  = PRG
	; 3  = USR
	; 4  = REL
	; 5  = DIR
	; 6  = D67 ; CBM 2040 (DOS 1)               - disk image
	; 6  = D64 ; CBM 1541 / 2031 / 3040 / 4040  - disk image
	; 7  = D71 ; CBM 1571                       - disk image
	; 8  = D81 ; CBM 1581                       - disk image
	; 9  = D80 ; CBM 8050                       - disk image
	; 10 = D81 ; CBM 8250 / 1001                - disk image
	; 11 = D90 ; CBM D9060 / D9090              - hard disk image
	; 12 = D1M ; CMD FD 2000 / 4000             - disk image (DD)
	; 13 = D2M ; CMD FD 2000 / 4000             - disk image (HD)
	; 14 = D2M ; CMD FD 4000                    - disk image (ED)
	; 15 = DHD ; CMD HD                         - hard disk image


	; Try to prepare output row


	; XXX provide proper implementation here

	jmp fs_hvsr_read_dir_blocksfree      ; XXX temporary

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

	; Close the directory within the hypervisor  XXX maybe move it to close routine

    ldx SD_DIR_DESC
	lda #$14                          ; dos_closedir
	sta HTRAP00
	+nop

	clc
	rts


;
; Helper routines
;

fs_hvsr_dirent_prepare:

	ldx #$00
	txa
@1:
	ldy $1000, x
	sty SD_DIRENT, x
	sta $1000, x
	inx
	bne @1

	rts

fs_hvsr_dirent_swap:

	php
	ldx #$00
@1:
	lda $1000, x
	ldy SD_DIRENT, x
	sta SD_DIRENT, x
	sty $1000, x
	inx
	bne @1

	plp
	rts
