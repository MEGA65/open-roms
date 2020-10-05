
;
; Various helper routines for SD card support
;

; Based on https://github.com/MEGA65/mega65-libc/blob/master/cc65/src/sdcard.c



;
; Sets read/write address
;
; Input: CARD_SECNUM, CARD_IS_SDHC
; Output: Carry set = error
; Preserves: .X, .Y, .Z
;

sdcard_set_addr:

	bit CARD_IS_SDHC
	bpl sdcard_set_addr_sdsc

sdcard_set_addr_sdhc:

	lda CARD_SECNUM+0
	sta SD_ADDR+0
	lda CARD_SECNUM+1
	sta SD_ADDR+1
	lda CARD_SECNUM+2
	sta SD_ADDR+2
	lda CARD_SECNUM+3
	sta SD_ADDR+3

	; FALLTROUGH

sdcard_set_addr_done:

	clc
	rts

sdcard_set_addr_sdsc:

	; Multiply sector number by 512

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
	bcs sdcard_helper_fail                   ; branch if sector number too large for SD card
	lda CARD_SECNUM+3
	beq sdcard_set_addr_done                 ; do not branch if sector number too large for SD card

	; FALLTROUGH

sdcard_helper_fail:

	sec
	rts


;
; Wait till card is ready
;
; Input: none
; Output: Carry set = error
; Preserves: .Y, .Z

sdcard_wait_ready:

	; XXX if card does not get ready, try to reset it

	lda SD_CTL
	; Sometimes we see this result, i.e., sdcard.vhdl thinks it is done,
	; but sdcardio.vhdl thinks not. This means a read error.
	cmp #$01
	beq sdcard_helper_fail
	tax
	and #$40
	bne sdcard_helper_fail
	txa
	and #$03
	bne sdcard_wait_ready

	clc
	rts
