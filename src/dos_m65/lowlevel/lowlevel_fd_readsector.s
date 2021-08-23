
; Read a sector pair from a block device, flow partially based on:
; - https://github.com/MEGA65/mega65-tools/blob/master/src/tests/floppytest.c


lowlevel_xx_readsector:

    ldx PAR_FSINSTANCE
    +beq lowlevel_rd_readsector

    ; FALLTROUGH

lowlevel_fd_readsector:

	; Check if buffer contains data from given track, sector, drive

	lda PAR_TRACK
	cmp BUFTAB_TRACK+1
	bne lowlevel_fd_readsector_force

	lda PAR_SECTOR
	and #%11111110
	cmp BUFTAB_SECTOR+1
	bne lowlevel_fd_readsector_force

	; XXX compare drive

	; Data already loaded into buffer - do nothing

	clc
	rts

lowlevel_fd_readsector_force:

	; Set drive, motor ON

	lda #$68
	cpx #$01
	beq @1
	inc
@1:
	sta FDC_CONTROL  ; $D080

	; Select floppy buffer

	lda #%10000000
	trb SD_BUFCTL    ; $D689

	; Wait until BUSY flag clears

@2:
	lda FDC_STATUS_A ; $D082
	bmi @2

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

	; Reset buffers

	lda #$00
	sta FDC_COMMAND  ; $D081

	; Ask the controller to read the sector    XXX how to detect errors, missing disk, etc.?

	lda #$40
	sta FDC_COMMAND  ; $D081

	; Wait for busy flag to assert   XXX how much? 1 second? most likelly too much...

	ldy #71
@3:
	ldx #$00
	jsr wait_x_bars
	dey
	bne @3

	; Wait until BUSY flag clears

@4:
	lda FDC_STATUS_A ; $D082
	bmi @4

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



lowlevel_fd_motor_off:

	; XXX set correct drive

	lda #$00
	sta FDC_CONTROL  ; $D080
	rts
