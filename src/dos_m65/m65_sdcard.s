
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


; Hardware

!addr SD_CTL       = $D680
!addr SD_ADDR      = $D681 ; 4 bytes
!addr SD_ERRCODE   = $D6DA


; XXX SD_SECTORBUF = 0xffd6e00L;






m65_sdcard_init: ; to be called during DOS initialization

	lda #$00
	sta CARD_IS_SDHC

	jsr m65_sdcard_reset
	
	; FALLTROUGH

m65_sdcard_init_gettype:

	; First work out if this is SD or SDHC card
	; SD cards can't read at non-sector aligned addresses

	lda #$00
	sta SD_ADDR+0
	sta SD_ADDR+1
	sta SD_ADDR+2
	sta SD_ADDR+3

	; Trigger read

	lda #$02
	sta SD_CTL

	; XXX



	; FALLTROUGH

m65_sdcard_init_getsize:

	; Put $00200000 to TMP_STEP and TMP_SECNUM

	; XXX this should probably be initialized in a loop

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

	;; XXX finish





m65_sdcard_reset:

	ldx #$40
	stx SD_CTL
	ldy #$00
	sty SD_CTL
	iny ; $01
	sty SD_CTL

	; Wait till SD card resets
@1:
	lda SD_CTL
	and #$03
	bne @1

	; For SDHC card set appropriate mode
	
	bit CARD_IS_SDHC
	bpl @2
	inx ; $41
	stx SD_CTL
@2:
	rts
