
;
; MEGA65 SD/SDHC card support
;

; Based on https://github.com/MEGA65/mega65-libc/blob/master/cc65/src/sdcard.c



; Permanent values XXX addresses are temporary

!addr CARD_IS_SDHC = $80 ; $00 = SD, $80 = SDHC
!addr CARD_SIZE    = $81 ; 4 bytes

; Temporary XXX addresses are temporary

!addr TMP_SECNUM   = $85  ; 4 bytes - sector number
!addr TMP_STEP     = $89  ; 4 bytes


; XXX hardware address SD_SECTORBUF = 0xffd6e00L;






m65_sdcard_init:

	lda #$00
	sta CARD_IS_SDHC

	jsr m65_sdcard_reset
	
	; Try to read first sector to see if card is operable

	lda #$00
	sta SD_ADDR+0
	sta SD_ADDR+1
	sta SD_ADDR+2
	sta SD_ADDR+3

	jsr m65_sdcard_read
	bcc m65_sdcard_init_operable

	; XXX if we are here, mark card as not operable and quit

m65_sdcard_init_operable:

	; Work out if this is SD or SDHC card - SD cards can't read at non-sector aligned addresses

	lda #$02
	sta SD_ADDR+0
	lda #$00
	sta SD_ADDR+1
	sta SD_ADDR+2
	sta SD_ADDR+3	

	jsr m65_sdcard_read

	lda SD_CTL
	beq m65_sdcard_init_sdsc

	; FALLTROUGH

m65_sdcard_init_sdhc:

	lda #$80
	sta CARD_IS_SDHC

	; Prepare data for determining card size - put $00200000 to TMP_STEP and TMP_SECNUM

    ; SDHC claims 32GB limit, and reading from beyond that might cause
    ; trouble. However, 32bits x 512byte sectors = 16TB addressable.
    ; It thus seems that the top byte of the address may not be safe to use,
    ; or at least the top few bits.

	; XXX this should be initialized to 0 in a loop

	lda #$00
	sta TMP_SECNUM+0
	sta TMP_STEP+0
	sta TMP_SECNUM+1
	sta TMP_STEP+1
	sta TMP_SECNUM+2
	sta TMP_STEP+2

	lda #$02
	sta TMP_SECNUM+3
	sta TMP_STEP+3

	bra m65_sdcard_init_getsize

m65_sdcard_init_sdsc:

	lda #$00
	sta CARD_IS_SDHC
	lda #$40                           ; use byte addressing
	sta SD_CTL

	; Prepare data for determining card size - put $00200000 to TMP_STEP and TMP_SECNUM

	; XXX this should be initialized to 0 in a loop

	lda #$00
	sta TMP_SECNUM+0
	sta TMP_STEP+0
	sta TMP_SECNUM+1
	sta TMP_STEP+1
	sta TMP_SECNUM+3
	sta TMP_STEP+3

	lda #$02
	sta TMP_SECNUM+2
	sta TMP_STEP+2

	; FALLTROUGH

m65_sdcard_init_getsize:

	; Work out size of SD card in a safe way
	; (binary search of sector numbers is NOT safe for some reason.
	; It frequently reports bigger than the size of the card)

	; XXX finish













m65_sdcard_read:

	; Trigger read

	lda #$02
	sta SD_CTL

	; Wait for result

	ldx #90
@1:
	jsr m65_sdcard_wait_16000_usec
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





m65_sdcard_reset:

	ldx #$40
	stx SD_CTL
	ldy #$00
	sty SD_CTL
	iny ; $01
	sty SD_CTL

	; Wait till SD card resets
@3:
	lda SD_CTL
	and #$03
	bne @3

	; For SDHC card set appropriate mode
	
	bit CARD_IS_SDHC
	bpl @4
	inx ; $41
	stx SD_CTL
@4:
	rts



m65_sdcard_wait_16000_usec:

	; Uses VIC-II raster register; wait time is not exactly precise, but should be
	; a good approximation

	phx
	pha

	ldx #$FF

	; XXX wait below is same as in KKERNAL, wait_x_lines - consider importing and reusing
	lda VIC_RASTER
@w1:
	cmp VIC_RASTER
	beq @w1
	lda VIC_RASTER
	dex
	bne @w1

	pla
	plx

	rts
