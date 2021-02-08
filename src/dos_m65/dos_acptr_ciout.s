
;
; Implementation of ACPTR/CIOUT commands.
; For detailed description see 'm65dos_bridge.s' file.
;


dos_ACPTR: ; does not have to preserve .X

	ldx IDX1_TALKER
	bmi dos_ACPTR_fail

	lda XX_CHANNEL, X
	cmp #$0F
	beq dos_ACPTR_status

	; XXX providde implementation for non-status streams

	jmp dos_ACPTR_fail

dos_ACPTR_status:

	ldx IDX2_TALKER
	jsr (dos_ACPTR_getsts_table, X)
	sta TBTCNT                         ; byte return
	beq dos_ACPTR_reset_status

	; XXX

	clc
	rts

dos_ACPTR_fail:

	; XXX set error code

	sec
	rts

dos_ACPTR_reset_status:

	; XXX replace status with OK instead

	ldx IDX1_TALKER
	lda #$00
	sta XX_STATUS_IDX,x

	; FALLTROUGH

dos_ACPTR_eoi:

	jsr kernalstatus_EOI
	
	clc
	rts

dos_ACPTR_getsts_SD:                   ; get next byte of status - SD card

	ldx SD_STATUS_IDX
	inc SD_STATUS_IDX
	lda SD_STATUS_STR,x
	rts

dos_ACPTR_getsts_FD:                   ; get next byte of status - floppy

	ldx FD_STATUS_IDX
	inc FD_STATUS_IDX
	lda FD_STATUS_STR,x
	rts

dos_ACPTR_getsts_RD:                   ; get next byte of status - ram disk

	ldx RD_STATUS_IDX
	inc RD_STATUS_IDX
	lda RD_STATUS_STR,x
	rts


dos_ACPTR_getsts_table:

	!word dos_ACPTR_getsts_SD
	!word dos_ACPTR_getsts_FD
	!word dos_ACPTR_getsts_RD









dos_CIOUT:

	; XXX provide implementation

	sec
	rts



kernalstatus_EOI:

	; XXX reuse original code instead

	lda IOSTATUS
	ora #K_STS_EOI
	sta IOSTATUS
	rts
