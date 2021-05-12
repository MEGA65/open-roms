
; Read a sector pair from a block device


lowlevel_readsector:

	; Set drive, check if disk is present

	lda #%00001111                     ; set drive 0 (internal) and side 0
	trb FDC_CONTROL  ; $D080

	lda FDC_STATUS_B ; $D083           ; check if disk is inserted    XXX this is probably not enough!
	and #$08
	bne @disk_present

	; XXX set error code

	sec
	rts

@disk_present:

	; Check if buffer contains data from given track
	; XXX compare device and unit too

	lda PAR_TRACK
	cmp BUFTAB_TRACK+1
	bne lowlevel_readsector_force
 
	; Check if sectors match

	lda PAR_SECTOR
	and #%11111110
	cmp BUFTAB_SECTOR+1
	bne lowlevel_readsector_force

	; Data already loaded into buffer - do nothing

	clc
	rts

lowlevel_readsector_force:

	lda #%10000000                     ; select floppy buffer
	trb SD_BUFCTL    ; $D689

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

	jsr lowlevel_wait_set_RDREQ        ; wait till sector is found
	jsr lowlevel_wait_clr_BUSY         ; wait for BUSY flag to clear

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

	; Fill-in metadata for buffer #1

	lda #$00
	sta BUFTAB_DEV+1
	lda PAR_TRACK
	sta BUFTAB_TRACK+1
	lda PAR_SECTOR
	and #%11111110
	sta BUFTAB_SECTOR+1

	clc
	rts



; XXX consider moving these to a separate file

lowlevel_wait_clr_BUSY:

	bit FDC_STATUS_A ; $D082
	bmi lowlevel_wait_clr_BUSY

	rts

lowlevel_wait_set_RDREQ:

	bit FDC_STATUS_B ; $D083
	bpl lowlevel_wait_set_RDREQ

	rts
