
;
; Implementation of SECOND/TKSA commands.
; For detailed description see 'm65dos_bridge.s' file.
;


dos_SECOND:

	phx
	cmp #$60
	bcs dos_SECOND_OPEN

	; XXX provide implementation

	plx
	sec
	rts

dos_SECOND_OPEN:

	and #$1F

	ldx IDX1_LISTENER          ; store channel
	sta XX_CHANNEL, X

	cmp #$0F
	beq dos_SECOND_OPEN_cmd

	; XXX provide implementation

	plx
	sec
	rts


dos_SECOND_OPEN_cmd:

	; XXX provide implementation

	plx
	clc
	rts




dos_TKSA:

	phx
	cmp #$60
	bcs dos_TKSA_OPEN

	; XXX provide implementation

	plx
	sec
	rts

dos_TKSA_OPEN:

	and #$1F

	ldx IDX1_TALKER          ; store channel
	sta XX_CHANNEL, X

	cmp #$0F
	beq dos_TKSA_OPEN_cmd

	; XXX provide implementation

	plx
	sec
	rts


dos_TKSA_OPEN_cmd:

	; XXX provide implementation

	plx
	clc
	rts
