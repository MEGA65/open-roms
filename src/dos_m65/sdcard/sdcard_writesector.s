
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

	; End reset

	lda #$01
	sta SD_CTL

	; Set write address

	jsr sdcard_set_addr







	jsr sdcard_writesector_copy_data










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
