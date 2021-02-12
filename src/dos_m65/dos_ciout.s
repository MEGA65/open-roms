
;
; Implementation of ACPTR command. For detailed description see 'm65dos_bridge.s' file.
;


dos_CIOUT:

	pha
	phx

	; XXX handle cases of transferring data

	; Receive command/file name byte

	ldx IDX2_TALKER
	jsr (dos_CIOUT_putcmdfn_table, X)

	plx
	pla

	clc
	rts





; Receiving command/file name

dos_CIOUT_putcmdfn_SD:                   ; get next byte of status - SD card

	ldx SD_CMDFN_IDX
	sta SD_CMDFN_IDX,x
	inx
	bpl @1
	ldx #$7F
@1:
	lda #$00
	sta SD_CMDFN_IDX,x
	rts

dos_CIOUT_putcmdfn_FD:                   ; get next byte of status - floppy

	ldx FD_CMDFN_IDX
	sta FD_CMDFN_IDX,x
	inx
	bpl @1
	ldx #$7F
@1:
	lda #$00
	sta FD_CMDFN_IDX,x
	rts

dos_CIOUT_putcmdfn_RD:                   ; get next byte of status - ram disk

	ldx RD_CMDFN_IDX
	sta RD_CMDFN_IDX,x
	inx
	bpl @1
	ldx #$7F
@1:
	lda #$00
	sta RD_CMDFN_IDX,x
	rts

dos_CIOUT_putcmdfn_table:

	!word dos_CIOUT_putcmdfn_SD
	!word dos_CIOUT_putcmdfn_FD
	!word dos_CIOUT_putcmdfn_RD
