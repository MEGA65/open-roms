
;
; Resets the SD card
;

; Based on https://github.com/MEGA65/mega65-libc/blob/master/cc65/src/sdcard.c



sdcard_reset:

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
