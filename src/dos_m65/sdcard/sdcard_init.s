
;
; Initialize memory card, determine it's type and size
;

; Based on https://github.com/MEGA65/mega65-libc/blob/master/cc65/src/sdcard.c



; XXX finish the routine


sdcard_init:

	; Initialize most important variables

	lda #$00
	sta CARD_IS_SDHC

	lda #SD_SECBUF_0
	sta CARD_BUFPNT+0
	lda #SD_SECBUF_1
	sta CARD_BUFPNT+1
	lda #SD_SECBUF_2
	sta CARD_BUFPNT+2
	lda #SD_SECBUF_3
	sta CARD_BUFPNT+3

	; Reset the card

	jsr sdcard_reset
	
	; Try to read first sector to see if card is operable

	lda #$00
	sta SD_ADDR+0
	sta SD_ADDR+1
	sta SD_ADDR+2
	sta SD_ADDR+3

	jsr sdcard_init_read
	bcc sdcard_init_operable

	; XXX if we are here, mark card as not operable and quit

sdcard_init_operable:

	; Work out if this is SD or SDHC card - SD cards can't read at non-sector aligned addresses

	lda #$02
	sta SD_ADDR+0
	lda #$00
	sta SD_ADDR+1
	sta SD_ADDR+2
	sta SD_ADDR+3	

	jsr sdcard_init_read

	lda SD_CTL
	beq sdcard_init_sdsc

	; FALLTROUGH

sdcard_init_sdhc:

	lda #$80
	sta CARD_IS_SDHC

	bra sdcard_init_getsize

sdcard_init_sdsc:

	lda #$00
	sta CARD_IS_SDHC
	lda #CARD_CMD_SDHC_OFF             ; $40 - use byte addressing
	sta SD_CTL

	; FALLTROUGH

sdcard_init_getsize:

	; Work out size of SD card in a safe way
	; (binary search of sector numbers is NOT safe for some reason.
	; It frequently reports bigger than the size of the card)

	lda #$00
	sta CARD_SECNUM+0
	sta CARD_SECNUM+1
	sta CARD_SECNUM+2
	sta CARD_SECNUM+3

	; step = 16*2048

	sta CARD_TMP_STEP+0
	sta CARD_TMP_STEP+2
	sta CARD_TMP_STEP+3
	lda #$08
	sta CARD_TMP_STEP+1

	; XXX finish the implementation




;
; Helper routines
;


sdcard_init_read:

	; Trigger read

	lda #CARD_CMD_READ                 ; $02
	sta SD_CTL

	; Wait for result

	ldx #90
@1:
	jsr sdcard_wait_16000_usec
	lda SD_CTL
	and #$03
	beq @2
	dex
	bne @1

	; Read failed

	sec
	rts
@2:
	;; Success

	clc
	rts
