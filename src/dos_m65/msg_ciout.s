
;
; Implementation of ACPTR command. For detailed description see 'm65dos_bridge.s' file.
;


msg_CIOUT:

	jsr dos_ENTER

	; Check operation mode

	ldx IDX1_LISTENER
	lda XX_MODE, x

	cmp #$01
	bne @1

	; Receiving command or file name

	ldx IDX2_TALKER
	jmp (msg_CIOUT_cmdfn_vectab, X)
@1:
	; XXX handle cases of transferring data

	jmp dos_EXIT_SEC





; Receiving command/file name

msg_CIOUT_cmdfn_SD:                    ; get next byte of status - SD card

	ldx SD_CMDFN_IDX
	sta SD_CMDFN_IDX,x
	inx
	bpl @1
	ldx #$7F
@1:
	lda #$00
	sta SD_CMDFN_IDX,x
	jmp dos_EXIT

msg_CIOUT_cmdfn_FD:                    ; get next byte of status - floppy

	ldx FD_CMDFN_IDX
	sta FD_CMDFN_IDX,x
	inx
	bpl @1
	ldx #$7F
@1:
	lda #$00
	sta FD_CMDFN_IDX,x
	jmp dos_EXIT

msg_CIOUT_cmdfn_RD:                    ; get next byte of status - ram disk

	ldx RD_CMDFN_IDX
	sta RD_CMDFN_IDX,x
	inx
	bpl @1
	ldx #$7F
@1:
	lda #$00
	sta RD_CMDFN_IDX,x
	jmp dos_EXIT

msg_CIOUT_cmdfn_vectab:

	!word msg_CIOUT_cmdfn_SD
	!word msg_CIOUT_cmdfn_FD
	!word msg_CIOUT_cmdfn_RD
