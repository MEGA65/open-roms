
;
; Implementation of UNLSN/UNTLK messages.
; For detailed description see 'm65dos_bridge.s' file.
;


msg_UNLSN:

	jsr dos_ENTER

	lda #$FF
	sta IDX1_LISTENER
	sta IDX2_LISTENER

	jmp dos_EXIT_CLC

msg_UNTLK:

	jsr dos_ENTER

	sta IDX1_TALKER
	sta IDX2_TALKER

	jmp dos_EXIT_CLC
