
;
; Writes the sector to the SD card
;

; Based on https://github.com/MEGA65/mega65-libc/blob/master/cc65/src/sdcard.c


; XXX finish, provide documentation


sdcard_writesector:

	; XXX check if card initialized and operable

	lda SD_CTL
	and #$03
	bne sdcard_writesector             ; XXX add a timer here

	; End reset XXX is this needed? should this be done for sector reading too?

	lda #CARD_CMD_END_RESET            ; $01
	sta SD_CTL

	; Set write address

	jsr sdcard_set_addr
	bcs sdcard_writesector_fail

	; FALLTROUGH

sdcard_writesector_write:

	; Set number of retries

	lda #$0A
	sta CARD_TMP_RETRIES

	; FALLTROUGH

sdcard_writesector_try_loop:

	jsr sdcard_writesector_copy_data

	; Wait till card is ready

	jsr sdcard_wait_ready
	bcs sdcard_writesector_fail

	; Write command

	lda #CARD_CMD_WRITE                ; $03
	sta SD_CTL

	; Wait for command completion

	jsr sdcard_wait_ready
	bcs sdcard_writesector_fail

	; Check result

	lda SD_CTL
	and #$67
	bne sdcard_writesector_verify

	; Write failed - retry

	jsr sdcard_reset
	dec CARD_TMP_RETRIES
	bne sdcard_writesector_try_loop

	; FALLTROUGH

sdcard_writesector_fail:

	sec
	rts

sdcard_writesector_verify:

	; There is a bug in the SD controller; you have to read between writes,
	; or it gets really upset

@1:
	lda SD_CTL
	and #$03
	bne @1

	lda #CARD_CMD_READ                 ; $02
	sta SD_CTL

@2:
	lda SD_CTL
	and #$03
	beq @2

@3:                                    ; XXX deduplicate this ppart
	lda SD_CTL
	and #$03
	bne @3

	; FALLTROUGH

sdcard_writesector_verify_loop:

	; Compare buffers

	phx
	phz

	ldx #$00
	ldz #$00

	lda [CARD_BUFPNT1],z
	cmp CARD_BUF, x
	bne sdcard_writesector_verify_fail
	
	lda [CARD_BUFPNT2],z
	cmp CARD_BUF+$100, x
	bne sdcard_writesector_verify_fail

	inz
	inx
	bne sdcard_writesector_verify_loop

	; FALLTROUGH

sdcard_writesector_verify_success:

	plz
	plx

	clc
	rts

sdcard_writesector_verify_fail:

	plz
	plx

	sec
	rts


;
; Helper routines
;

sdcard_writesector_copy_data:

	; XXX use DMAgic for this

	phz
	phx

	ldx #$00
	ldz #$00

@1:
	lda CARD_BUF,x
	sta [CARD_BUFPNT1],z
	lda CARD_BUF+$100,x
	sta [CARD_BUFPNT2],z

	inz
	inx
	bne @1

	; Restore registers and quit

	plx
	plz

	clc
	rts
