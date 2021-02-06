
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

	lda #$02
	bra dos_LISTEN_success
@2:
	cmp UNIT_RAMDISK
	bne dos_fail_TALK_LISTEN

	lda #$04
	
	; FALLTROUGH

dos_LISTEN_success:

	sta IDX_LISTENER
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

	lda #$02
	bra dos_TALK_success
@2:
	cmp UNIT_RAMDISK
	bne dos_fail_TALK_LISTEN

	lda #$04
	
	; FALLTROUGH

dos_TALK_success:

	sta IDX_TALKER
	bra dos_common_LSN_TALK_UN

dos_fail_TALK_LISTEN:

	pla
	sec
	rts

; UNLSN / UNTLK

dos_UNLSN:

	pha
	lda #$FF
	sta IDX_LISTENER
	bra dos_common_LSN_TALK_UN

dos_UNTLK:

	pha
	lda #$FF
	sta IDX_TALKER

	; FALLTROUGH

dos_common_LSN_TALK_UN:

	pla
	clc
	rts
