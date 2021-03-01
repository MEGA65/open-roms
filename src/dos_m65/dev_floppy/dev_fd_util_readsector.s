
; Read a single sector from a floppy drive


; XXX utilize this

dev_fd_util_readsector:

	; Select FDD sector as buffer

	lda #%10000000                     ; select floppy buffer
	trb SD_BUFCTL

	lda #%00000100
	trb FDC_CONTROL                    ; set side 0

	; Select physical track and sector based on logical ones from PAR_TRACK and PAR_SECTOR

	lda PAR_TRACK
	dec
	sta FDC_TRACK

	lda FDC_SECTOR
	cmp #20
	bcc @side0

@side1:
	
	ldx #$01
	sec
	sbc #20
	+skip_2_bytes_trash_nvz

@side0:

	ldx #$00
	stx FDC_SIDE
	clc
	ror
	sta FDC_SECTOR

	; Ask the controller to read the sector

	lda #$40
	sta FDC_COMMAND
@lp:
	lda FDC_STATUS_B                   ; XXX detect errors here
	bpl @lp

	; Copy sector to buffer in RAM

	; XXX
