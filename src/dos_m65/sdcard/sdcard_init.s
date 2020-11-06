
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
	sta CARD_BUFPNT1+0
	sta CARD_BUFPNT2+0
	lda #SD_SECBUF_1
	sta CARD_BUFPNT1+1
	inc
	sta CARD_BUFPNT2+1
	lda #SD_SECBUF_2
	sta CARD_BUFPNT1+2
	sta CARD_BUFPNT2+2
	lda #SD_SECBUF_3
	sta CARD_BUFPNT1+3
	sta CARD_BUFPNT2+3

	; Reset the card

	jsr sdcard_reset
	
	; Try to read first sector to see if card is operable

	lda #$00
	sta SD_ADDR+0
	sta SD_ADDR+1
	sta SD_ADDR+2
	sta SD_ADDR+3

	jsr sdcard_init_read
	bcs sdcard_init_getsize_fail       ; if failure, mark card as not operable and quit

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

	; step (and first sector) = 16*2048

	sta CARD_TMP_STEP+0
	sta CARD_SECNUM+0
	sta CARD_TMP_STEP+2
	sta CARD_SECNUM+2
	sta CARD_TMP_STEP+3
	sta CARD_SECNUM+3
	lda #$08
	sta CARD_TMP_STEP+1
	sta CARD_SECNUM+1

	; FALLTROUGH

sdcard_init_getsize_read:

	; Try to read sector

	jsr sdcard_readsector
	bcc sdcard_init_getsize_next          ; XXX original code checks PEEK(sd_ctl)&0x63;...

	; Failed to read - restore card state and sector number

	jsr sdcard_reset

	sec
	lda CARD_SECNUM+0
	sbc CARD_TMP_STEP+0
	sta CARD_SECNUM+0
	lda CARD_SECNUM+1
	sbc CARD_TMP_STEP+1
	sta CARD_SECNUM+1
	lda CARD_SECNUM+2
	sbc CARD_TMP_STEP+2
	sta CARD_SECNUM+2
	lda CARD_SECNUM+3
	sbc CARD_TMP_STEP+3
	sta CARD_SECNUM+3

	; Divide step by 2, skip bytes which are always 0

	clc
	; ror CARD_TMP_STEP+3
	; ror CARD_TMP_STEP+2
	ror CARD_TMP_STEP+1
	ror CARD_TMP_STEP+0

	; FALLTROUGH

sdcard_init_getsize_next:

	; Increment sector number by step

	clc
	lda CARD_SECNUM+0
	adc CARD_TMP_STEP+0
	sta CARD_SECNUM+0
	lda CARD_SECNUM+1
	adc CARD_TMP_STEP+1
	sta CARD_SECNUM+1
	lda CARD_SECNUM+2
	adc CARD_TMP_STEP+2
	sta CARD_SECNUM+2
	lda CARD_SECNUM+3
	adc CARD_TMP_STEP+3
	sta CARD_SECNUM+3

	; If sector number is 0 - report failure

	lda CARD_SECNUM+0
	ora CARD_SECNUM+1
	ora CARD_SECNUM+2
	ora CARD_SECNUM+3
	beq sdcard_init_getsize_fail

	; If step is 0 - this is the end, we know maximum size

	lda CARD_TMP_STEP+0
	ora CARD_TMP_STEP+1
	ora CARD_TMP_STEP+2
	ora CARD_TMP_STEP+3
	beq sdcard_init_getsize_done

	; Check sector number, should be below $10:$00:$00:$00

	lda CARD_SECNUM+3
	and #$F0
	bne sdcard_init_getsize_read

	; It is not - report maximum size

	lda #$FF
	sta CARD_SECNUM+0
	sta CARD_SECNUM+1
	sta CARD_SECNUM+2
	lda #$0F
	sta CARD_SECNUM+3

	; FALLTROUGH

sdcard_init_getsize_done:

	; Return sector number as maximum readable sector

	lda CARD_SECNUM+0
	sta CARD_SIZE+0
	lda CARD_SECNUM+1
	sta CARD_SIZE+1
	lda CARD_SECNUM+2
	sta CARD_SIZE+2
	lda CARD_SECNUM+3
	sta CARD_SIZE+3

	clc
	rts

sdcard_init_getsize_fail:

	; XXX mark card as inoperable

	sec
	rts



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
