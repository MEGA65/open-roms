
;
; Implementation of ACPTR command. For detailed description see 'm65dos_bridge.s' file.
;


msg_ACPTR:

	jsr dos_ENTER

	; Check if there is a talker active

	ldx IDX1_TALKER
	+bmi msg_ACPTR_fail_no_talker

	; Check if active channel is status one

	lda XX_CHANNEL, X
	cmp #$0F
	+beq msg_ACPTR_status

	; XXX add support for read contexts (multiple channels)

	; Not a status channel - check if we have something to read out

	ldx IDX2_TALKER
	lda XX_ACPTR_LEN+0,x
	ora XX_ACPTR_LEN+1,x
	+beq msg_ACPTR_fail_no_data

	; Read a byte of data from the buffer

	jmp (msg_ACPTR_read_vectab, X)

msg_ACPTR_read_SD:

	; Read and return one byte

	jsr SD_ACPTR_helper
	sta TBTCNT
	sta REG_A

	; Increment pointer, decrement length

	inc SD_ACPTR_PTR+0
	bne @1
	inc SD_ACPTR_PTR+1
@1:
	dec SD_ACPTR_LEN+0
	lda SD_ACPTR_LEN+0
	cmp #$FF
	bne @2
	dec SD_ACPTR_LEN+1
@2:
	; If new length is 0, try to read next block of data

	ora SD_ACPTR_LEN+1
	bne @3
	jsr unit_sd_cmd_READ
	bcc @3
	jsr kernalstatus_EOI
@3:
	jmp dos_EXIT_CLC

msg_ACPTR_read_F0:

	; Read and return one byte

	jsr F0_ACPTR_helper
	sta TBTCNT
	sta REG_A

	; Increment pointer, decrement length

	inc F0_ACPTR_PTR+0
	bne @1
	inc F0_ACPTR_PTR+1
@1:
	dec F0_ACPTR_LEN+0
	lda F0_ACPTR_LEN+0
	cmp #$FF
	bne @2
	dec F0_ACPTR_LEN+1
@2:
	; If new length is 0, try to read next block of data

	ora F0_ACPTR_LEN+1
	bne @3
	jsr unit_f0_cmd_READ
	bcc @3
	jsr kernalstatus_EOI
@3:
	jmp dos_EXIT_CLC

msg_ACPTR_read_F1:

	; Read and return one byte

	jsr F1_ACPTR_helper
	sta TBTCNT
	sta REG_A

	; Increment pointer, decrement length

	inc F1_ACPTR_PTR+0
	bne @1
	inc F1_ACPTR_PTR+1
@1:
	dec F1_ACPTR_LEN+0
	lda F1_ACPTR_LEN+0
	cmp #$FF
	bne @2
	dec F1_ACPTR_LEN+1
@2:
	; If new length is 0, try to read next block of data

	ora F1_ACPTR_LEN+1
	bne @3
	jsr unit_f1_cmd_READ
	bcc @3
	jsr kernalstatus_EOI
@3:
	jmp dos_EXIT_CLC

msg_ACPTR_read_RD:

	; XXX provide implementation


msg_ACPTR_fail_no_data:

	; XXX What should be the reaction when trying to read and no data is present?

	sta TBTCNT
	sta REG_A
	bra msg_ACPTR_EOI

msg_ACPTR_status:

	ldx IDX2_TALKER
	jmp (msg_ACPTR_status_vectab, X)

msg_ACPTR_status_SD:                   ; get next byte of status - SD card

	ldx SD_STATUS_IDX
	inc SD_STATUS_IDX
	lda SD_STATUS_BUF,x
	bra msg_ACPTR_status_got

msg_ACPTR_status_F0:                   ; get next byte of status - floppy 0

	ldx F0_STATUS_IDX
	inc F0_STATUS_IDX
	lda F0_STATUS_BUF,x
	bra msg_ACPTR_status_got

msg_ACPTR_status_F1:                   ; get next byte of status - floppy 0

	ldx F1_STATUS_IDX
	inc F1_STATUS_IDX
	lda F1_STATUS_BUF,x
	bra msg_ACPTR_status_got

msg_ACPTR_status_RD:                   ; get next byte of status - ram disk

	ldx RD_STATUS_IDX
	inc RD_STATUS_IDX
	lda RD_STATUS_BUF,x

	; FALLTROUGH

msg_ACPTR_status_got:

	sta TBTCNT                         ; byte return
	beq msg_ACPTR_reset_status

	jmp dos_EXIT_CLC_A

msg_ACPTR_fail_no_talker:

	; XXX set error code

	jmp dos_EXIT_SEC

msg_ACPTR_reset_status:

	ldx IDX2_TALKER
	lda #$00
	sta PAR_TRACK
	sta PAR_SECTOR
	jsr (msg_ACPTR_set_status_vectab, x)

	; FALLTROUGH

msg_ACPTR_EOI:

	jsr kernalstatus_EOI
	jmp dos_EXIT_CLC


; Vector tables for jumps

msg_ACPTR_status_vectab:

	!word msg_ACPTR_status_SD
	!word msg_ACPTR_status_F0
	!word msg_ACPTR_status_F1
	!word msg_ACPTR_status_RD

msg_ACPTR_read_vectab:

	!word msg_ACPTR_read_SD
	!word msg_ACPTR_read_F0
	!word msg_ACPTR_read_F1
	!word msg_ACPTR_read_RD

msg_ACPTR_set_status_vectab:

	!word util_status_SD
	!word util_status_F0
	!word util_status_F1
	!word util_status_RD
