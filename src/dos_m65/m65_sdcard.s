
;
; MEGA65 SD/SDHC card support
;

; Based on https://github.com/MEGA65/mega65-libc/blob/master/cc65/src/sdcard.c



; Permanent values XXX addresses are temporary

!addr CARD_IS_SDHC = $80 ; $00 = SD, $80 = SDHC
!addr CARD_SIZE    = $81 ; 4 bytes
!addr CARD_SECNUM  = $85 ; 4 bytes - sector number
!addr CARD_BUFPNT  = $89 ; 4 bytes - pointer to hardware sector buffer


; Temporary data XXX addresses are temporary

!addr TMP_STEP     = $8D  ; 4 bytes
!addr TMP_RETRIES  = $8E  ; 1 byte

!addr CARD_BUF     = $8100 ; 512 bytes, up to $82FF


; External entry points:
; - m65_sdcard_init
; - m65_sdcard_readsector



m65_sdcard_init:

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

	bra m65_sdcard_init_getsize

m65_sdcard_init_sdsc:

	lda #$00
	sta CARD_IS_SDHC
	lda #$40                           ; use byte addressing
	sta SD_CTL

	; FALLTROUGH

m65_sdcard_init_getsize:

	; Work out size of SD card in a safe way
	; (binary search of sector numbers is NOT safe for some reason.
	; It frequently reports bigger than the size of the card)

	lda #$00
	sta CARD_SECNUM+0
	sta CARD_SECNUM+1
	sta CARD_SECNUM+2
	sta CARD_SECNUM+3

	; step = 16*2048

	sta TMP_STEP+0
	sta TMP_STEP+2
	sta TMP_STEP+3
	lda #$08
	sta TMP_STEP+1

	; XXX finish the implementation









; -------------------------------------







m65_sdcard_readsector: ; XXX reads sector CARD_SECNUM

	; Set read address, depending on card type

	bit CARD_IS_SDHC
	bpl m65_sdcard_readsector_sdsc

m65_sdcard_readsector_sdhc:

	lda CARD_SECNUM+0
	sta SD_ADDR+0
	lda CARD_SECNUM+1
	sta SD_ADDR+1
	lda CARD_SECNUM+2
	sta SD_ADDR+2
	lda CARD_SECNUM+3
	sta SD_ADDR+3

	bra m65_sdcard_readsector_read

m65_sdcard_readsector_sdsc: ; multiply sector number by 512

	lda #$00
	sta SD_ADDR+0
	clc
	lda CARD_SECNUM+0
	rol
	sta SD_ADDR+1
	lda CARD_SECNUM+1
	rol
	sta SD_ADDR+2
	lda CARD_SECNUM+2
	rol
	sta SD_ADDR+3
	bcs m65_sdcard_readsector_fail               ; branch if sector number too large for SD card
	lda CARD_SECNUM+3
	bne m65_sdcard_readsector_fail               ; branch if sector number too large for SD card

	; FALLTROUGH

m65_sdcard_readsector_read:

	; Set number of retries

	lda #$0A
	sta TMP_RETRIES

	; FALLTROUGH

m65_sdcard_readsector_try_loop:

	; Wait till card is ready

	jsr m65_sdcard_readsector_wait
	bcs m65_sdcard_readsector_fail

	; Read command

	lda #$02
	sta SD_CTL

	; Wait for command completion

	jsr m65_sdcard_readsector_wait
	bcs m65_sdcard_readsector_fail


	lda SD_CTL
	and #$67
	bne m65_sdcard_readsector_copy_data

	jsr m65_sdcard_reset
	dec TMP_RETRIES
	bne m65_sdcard_readsector_try_loop

	; FALLTROUGH

m65_sdcard_readsector_fail:

	sec
	rts

m65_sdcard_readsector_copy_data:

	; XXX this should be a separate routine
	; XXX use DMAgic for this

	phz
	phx

	ldx #$00
	ldz #$00

@RL1:
	lda [CARD_BUFPNT],z
	sta CARD_BUF,x
	inc CARD_BUFPNT+1
	lda [CARD_BUFPNT],z
	sta CARD_BUF+$100,x
	dec CARD_BUFPNT+1	

	inz
	inx
	bne @RL1

	; Restore registers and quit

	plx
	plz

	clc
	rts









; -------------------------------------


m65_sdcard_readsector_wait:

	; Wait till card is ready

	lda SD_CTL
	; Sometimes we see this result, i.e., sdcard.vhdl thinks it is done,
	; but sdcardio.vhdl thinks not. This means a read error.
	cmp #$01
	beq m65_sdcard_readsector_wait_fail
	tax
	and #$40
	bne m65_sdcard_readsector_wait_fail
	txa
	and #$03
	bne m65_sdcard_readsector_wait

	clc
	rts

m65_sdcard_readsector_wait_fail:

	sec
	rts





; -------------------------------------





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



; -------------------------------------



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



; -------------------------------------


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
