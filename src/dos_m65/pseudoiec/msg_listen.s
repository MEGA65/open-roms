
;
; Implementation of LISTEN commands.
; For detailed description see 'm65dos_bridge.s' file.
;


msg_LISTEN:

	jsr dos_ENTER

	and #$1F
	beq msg_LISTEN_fail      ; branch if device 0 (used to denote lack of device)

@try_sd:

	cmp UNIT_SDCARD
	bne @try_f0

	; LISTEN on SD card

	lda #$00
	bra msg_LISTEN_success

@try_f0:

	cmp UNIT_FLOPPY0
	bne @try_f1

	; LISTEN on floppy 0

	lda #$01
	bra msg_LISTEN_success

@try_f1:

	cmp UNIT_FLOPPY1
	bne @try_rd

	; LISTEN on floppy 1

	lda #$02
	bra msg_LISTEN_success

@try_rd:

	cmp UNIT_RAMDISK
	bne msg_LISTEN_fail

	; LISTEN on ram disk

	lda #$03
	
	; FALLTROUGH

msg_LISTEN_success:

	sta IDX1_LISTENER
	asl
	sta IDX2_LISTENER

	; XXX should we reset XX_CMDFN_IDX ?

	jmp dos_EXIT_CLC

msg_LISTEN_fail:

	lda #K_ERR_DEVICE_NOT_FOUND

	jmp dos_EXIT_SEC_A
