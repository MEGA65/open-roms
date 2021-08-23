
;
; Implementation of TALK commands.
; For detailed description see 'm65dos_bridge.s' file.
;


msg_TALK:

	jsr dos_ENTER

	and #$1F
	beq msg_TALK_fail        ; branch if device 0 (used to denote lack of device)

@try_sd:

	cmp UNIT_SDCARD
	bne @try_f0

	; TALK on SD card

	lda #$00
	bra msg_TALK_success

@try_f0:

	cmp UNIT_FLOPPY0
	bne @try_f1

	; TALK on floppy 0

	lda #$01
	bra msg_TALK_success

@try_f1:

	cmp UNIT_FLOPPY1
	bne @try_rd

	; TALK on floppy 1

	lda #$02
	bra msg_TALK_success

@try_rd:

	cmp UNIT_RAMDISK
	bne msg_TALK_fail

	; TALK on ram disk

	lda #$03
	
	; FALLTROUGH

msg_TALK_success:

	sta IDX1_TALKER
	asl
	sta IDX2_TALKER

	jmp dos_EXIT_CLC

msg_TALK_fail:

	lda #K_ERR_DEVICE_NOT_FOUND

	jmp dos_EXIT_SEC_A
