
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

	; XXX








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
	sta [CARD_BUFPNT],z
	inc CARD_BUFPNT+1
	lda CARD_BUF+$100,x
	sta [CARD_BUFPNT],z
	dec CARD_BUFPNT+1	

	inz
	inx
	bne @1

	; Restore registers and quit

	plx
	plz

	clc
	rts
