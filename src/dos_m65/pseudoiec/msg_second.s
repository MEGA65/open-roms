
;
; Implementation of SECOND command.
; For detailed description see 'm65dos_bridge.s' file.
;


msg_SECOND:

	jsr dos_ENTER

	; First store the channel

	tay
	and #$0F                   ; support channels 0-15, like 1541 drive

	ldx IDX1_LISTENER
	bmi msg_SECOND_done        ; do nothing if no listener
	stx PAR_FSINSTANCE         ; set file system instance
	sta XX_CHANNEL, x          ; store channel

	; Determine command type

	tya	
	and #$F0

	cmp #$F0
	beq msg_SECOND_OPEN
	cmp #$E0
	beq msg_SECOND_CLOSE

	; XXX provide implementation

	; FALLTROUGH

msg_SECOND_done:

	jmp dos_EXIT_CLC

msg_SECOND_OPEN:

	lda #$00
	sta XX_CMDFN_IDX, x        ; reset the index to the command/filename
	ldx IDX2_LISTENER
	jmp (dos_cmd_OPEN_vectab, x)

msg_SECOND_CLOSE:

	ldx IDX2_LISTENER
	jmp (dos_cmd_CLOSE_vectab, x)
