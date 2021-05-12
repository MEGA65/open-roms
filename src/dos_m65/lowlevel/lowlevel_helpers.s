
; Helper routines for low-level disk operations


lowlevel_ensure_presence:

	lda FDC_STATUS_B ; $D083           ; check if disk is inserted    XXX this is probably not enough!
	and #$08
	beq @not_present
	rts

@not_present:

	pla
	pla

	jsr lowlevel_motor_off             ; if disk not present, disable drive motor

	; XXX set error code, invalidate buffers, etc.

	sec
	rts

lowlevel_motor_on:

	lda #%00100000                     ; enable drive motor and LED
	tsb FDC_CONTROL  ; $D080
	bra lowlevel_wait_clr_BUSY

lowlevel_motor_off:

	lda #%00100000                     ; disable drive motor and LED
	trb FDC_CONTROL  ; $D080

	; FALLTROUGH

lowlevel_wait_clr_BUSY:

	bit FDC_STATUS_A ; $D082
	bmi lowlevel_wait_clr_BUSY

	rts

lowlevel_wait_set_RDREQ:

	bit FDC_STATUS_B ; $D083
	bpl lowlevel_wait_set_RDREQ

	rts
