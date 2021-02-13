
;
; Implementation of LISTEN commands.
; For detailed description see 'm65dos_bridge.s' file.
;


msg_LISTEN:

	jsr dos_ENTER

	and #$1F
	beq msg_LISTEN_fail      ; branch if device 0 (used to denote lack of device)

	cmp UNIT_SDCARD
	bne @1

	; LISTEN on SD card

	lda #$00
	bra msg_LISTEN_success
@1:
	cmp UNIT_FLOPPY
	bne @2

	; LISTEN on floppy

	lda #$01
	bra msg_LISTEN_success
@2:
	cmp UNIT_RAMDISK
	bne msg_LISTEN_fail

	; LISTEN on ram disk

	lda #$02
	
	; FALLTROUGH

msg_LISTEN_success:

	sta IDX1_LISTENER
	asl
	sta IDX2_LISTENER

	; XXX should we reset XX_CMDFN_IDX ?

	jmp dos_EXIT

msg_LISTEN_fail:

	lda #K_ERR_DEVICE_NOT_FOUND

	jmp dos_EXIT_A_SEC
