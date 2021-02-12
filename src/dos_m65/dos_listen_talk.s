
;
; Implementation of LISTEN/UNLSN/TALK/UNTLK commands.
; For detailed description see 'm65dos_bridge.s' file.
;


; LISTEN

dos_LISTEN:

	pha
	and #$1F
	beq dos_fail_TALK_LISTEN           ; branch if device 0 (used to denote lack of device)

	cmp UNIT_SDCARD
	bne @1

	lda #$00
	bra dos_LISTEN_success
@1:
	cmp UNIT_FLOPPY
	bne @2

	lda #$01
	bra dos_LISTEN_success
@2:
	cmp UNIT_RAMDISK
	bne dos_fail_TALK_LISTEN

	lda #$02
	
	; FALLTROUGH

dos_LISTEN_success:

	sta IDX1_LISTENER
	asl
	sta IDX2_LISTENER

	; XXX should we reset XX_CMDFN_IDX ?

	bra dos_common_LSN_TALK_UN

; TALK

dos_TALK:

	pha
	and #$1F
	beq dos_fail_TALK_LISTEN           ; branch if device 0 (used to denote lack of device)

	cmp UNIT_SDCARD
	bne @1

	lda #$00
	bra dos_TALK_success
@1:
	cmp UNIT_FLOPPY
	bne @2

	lda #$01
	bra dos_TALK_success
@2:
	cmp UNIT_RAMDISK
	bne dos_fail_TALK_LISTEN

	lda #$02
	
	; FALLTROUGH

dos_TALK_success:

	sta IDX1_TALKER
	asl
	sta IDX2_TALKER

	bra dos_common_LSN_TALK_UN

dos_fail_TALK_LISTEN:

	pla
	lda #K_ERR_DEVICE_NOT_FOUND
	sec
	rts

; UNLSN / UNTLK

dos_UNLSN:

	pha
	lda #$FF
	sta IDX1_LISTENER
	sta IDX2_LISTENER
	bra dos_common_LSN_TALK_UN

dos_UNTLK:

	pha
	lda #$FF
	sta IDX1_TALKER
	sta IDX2_TALKER

	; FALLTROUGH

dos_common_LSN_TALK_UN:

	pla
	clc
	rts
