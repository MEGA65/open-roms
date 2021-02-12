
;
; Implementation of SECOND/TKSA commands.
; For detailed description see 'm65dos_bridge.s' file.
;


dos_SECOND:

	pha
	phx
	phy

	; First store the channel

	tay
	and #$0F                   ; support channels 0-15, like 1541 drive

	ldx IDX1_LISTENER
	bmi dos_SECOND_done        ; do nothing if no listener
	sta XX_CHANNEL, x          ; store channel

	; Determine command type

	tya	
	and #$F0

	cmp #$F0
	beq dos_SECOND_OPEN
	cmp #$E0
	beq dos_SECOND_CLOSE

	; XXX provide implementation

	bra dos_SECOND_done

dos_SECOND_OPEN:

	ldx IDX2_LISTENER
	jmp (dos_cmd_OPEN_vectable, x)

dos_SECOND_CLOSE:

	ldx IDX2_LISTENER
	jmp (dos_cmd_CLOSE_vectable, x)

dos_SECOND_done:

	ply
	bra dos_TKSA_done          ; reuse part of TKSA code


dos_TKSA:

	pha
	phx

	and #$0F                   ; support channels 0-15, like 1541 drive

	ldx IDX1_TALKER
	bmi dos_TKSA_done          ; do nothing if no taalker
	sta XX_CHANNEL, x          ; store channel

	; FALLTROUGH

dos_TKSA_done:

	plx
	pla
	clc
	rts
