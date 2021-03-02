
; Read a single sector from a floppy drive


; XXX utilize this

dev_fd_util_readsector:

	; Select FDD sector as buffer

	lda #%10000000                     ; select floppy buffer
	trb SD_BUFCTL

	lda #%00000111
	trb FDC_CONTROL                    ; set drive 0 (internal)    XXX support multiple drives

	lda #%00001000
	trb FDC_CONTROL                    ; set side 0 by default

	; Select physical track and sector based on logical ones from PAR_TRACK and PAR_SECTOR

	lda PAR_TRACK
	dec
	sta FDC_TRACK

	lda PAR_SECTOR
	cmp #20
	bcc @side0

@side1:

	lda #%00001000
	tsb FDC_CONTROL                    ; set side 1
	
	lda PAR_SECTOR
	sec
	sbc #20

	ldx #$01
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
	lda FDC_STATUS_B                   ; XXX detect errors here   XXX waiting is probably not corrent
	bpl @lp

	; Copy sector to buffer in RAM

	; XXX

	rts
