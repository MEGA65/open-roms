
; Read a single sector from a floppy drive


dev_fd_util_readsector:

	; Select FDD sector as buffer

	lda #%10000000                     ; select floppy buffer
	trb SD_BUFCTL    ; $D689

	lda #%00001111                     ; set drive 0 (internal) and side 0
	trb FDC_CONTROL  ; $D080

	; Select physical track and sector based on logical ones from PAR_TRACK and PAR_SECTOR

	lda PAR_TRACK
	dec
	sta FDC_TRACK    ; $D084

	lda PAR_SECTOR
	cmp #20
	bcc @side0

@side1:

	lda #%00001000                     ; set side 1
	tsb FDC_CONTROL  ; $D080
	
	lda PAR_SECTOR
	sec
	sbc #20

	ldx #$01
	+skip_2_bytes_trash_nvz

@side0:

	ldx #$00
	stx FDC_SIDE     ; $D086
	clc
	ror
	inc
	sta FDC_SECTOR   ; $D085

	; Ask the controller to read the sector    XXX how to detect errors, missing disk, etc.?

	lda #$40
	sta FDC_COMMAND  ; $D081

	; Wait for RDREQ (indicates sector found)

@lp1:
	lda FDC_STATUS_B ; $D083
	bpl @lp1

	; Wait for BUSY flag to clear

@lp2:
	lda FDC_STATUS_A ; $D082
	bmi @lp2

	; Wait for DRQ and EQ flags to go high

@lp3:
	lda FDC_STATUS_A ; $D082
	and #%01100000
	cmp #%01000000   ; XXX is this correct? .A seems to stay at $40 at this point
	bne @lp3

	; Copy sector to buffer in RAM

	lda #$00
	sta DMAJOB_DST_MB
	lda #<(SHARED_BUF_1 - $8000)
	sta DMAJOB_DST_ADDR+0
	lda #>(SHARED_BUF_1 - $8000)
	sta DMAJOB_DST_ADDR+1
	lda #$01
	sta DMAJOB_DST_ADDR+2

	jsr util_dma_launch_from_hwbuf    ; execute DMA job

	clc
	rts
