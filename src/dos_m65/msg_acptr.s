
;
; Implementation of ACPTR command. For detailed description see 'm65dos_bridge.s' file.
;


msg_ACPTR:

	jsr dos_ENTER

	; Check if there is a talker active

	ldx IDX1_TALKER
	bmi msg_ACPTR_fail

	; Check if active channel is status one

	lda XX_CHANNEL, X
	cmp #$0F
	beq msg_ACPTR_status

	; XXX providde implementation for non-status channels

	jmp msg_ACPTR_fail

msg_ACPTR_status:

	ldx IDX2_TALKER
	jmp (msg_ACPTR_status_vectab, X)

msg_ACPTR_status_SD:                   ; get next byte of status - SD card

	ldx SD_STATUS_IDX
	inc SD_STATUS_IDX
	lda SD_STATUS_STR,x
	bra msg_ACPTR_status_got

msg_ACPTR_status_FD:                   ; get next byte of status - floppy

	ldx FD_STATUS_IDX
	inc FD_STATUS_IDX
	lda FD_STATUS_STR,x
	bra msg_ACPTR_status_got

msg_ACPTR_status_RD:                   ; get next byte of status - ram disk

	ldx RD_STATUS_IDX
	inc RD_STATUS_IDX
	lda RD_STATUS_STR,x

	; FALLTROUGH

msg_ACPTR_status_got:

	sta TBTCNT                         ; byte return
	beq msg_ACPTR_reset_status

	jmp dos_EXIT_A

msg_ACPTR_fail:

	; XXX set error code

	jmp dos_EXIT_SEC

msg_ACPTR_reset_status:

	lda IDX1_TALKER
	jsr dos_status_00

	; FALLTROUGH

msg_ACPTR_eoi:

	jsr kernalstatus_EOI
	jmp dos_EXIT



; Vector tables for jumps

msg_ACPTR_status_vectab:

	!word msg_ACPTR_status_SD
	!word msg_ACPTR_status_FD
	!word msg_ACPTR_status_RD
