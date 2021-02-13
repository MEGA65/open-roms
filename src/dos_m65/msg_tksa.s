
;
; Implementation of TKSA commands.
; For detailed description see 'm65dos_bridge.s' file.
;


msg_TKSA:

	jsr dos_ENTER

	and #$0F                   ; support channels 0-15, like 1541 drive

	ldx IDX1_TALKER
	bmi msg_TKSA_done          ; do nothing if no taalker
	sta XX_CHANNEL, x          ; store channel

	; FALLTROUGH

msg_TKSA_done:

	jmp dos_EXIT
