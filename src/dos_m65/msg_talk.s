
;
; Implementation of TALK commands.
; For detailed description see 'm65dos_bridge.s' file.
;


msg_TALK:

	jsr dos_ENTER

	and #$1F
	beq msg_TALK_fail        ; branch if device 0 (used to denote lack of device)

	cmp UNIT_SDCARD
	bne @1

	; TALK on SD card

	lda #$00
	bra msg_TALK_success
@1:
	cmp UNIT_FLOPPY
	bne @2

	; TALK on floppy

	lda #$01
	bra msg_TALK_success
@2:
	cmp UNIT_RAMDISK
	bne msg_TALK_fail

	; TALK on ram disk

	lda #$02
	
	; FALLTROUGH

msg_TALK_success:

	sta IDX1_TALKER
	asl
	sta IDX2_TALKER

	jmp dos_EXIT

msg_TALK_fail:

	lda #K_ERR_DEVICE_NOT_FOUND

	jmp dos_EXIT_A_SEC
