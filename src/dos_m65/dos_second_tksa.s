
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

	ldx IDX1_LISTENER          ; store channel
	bmi dos_SECOND_done        ; do nothing if no listener
	sta XX_CHANNEL, x

	; Determine command type

	tya	
	and #$F0

	cmp #$F0
	beq dos_SECOND_OPEN
	cmp #$E0
	beq dos_SECOND_CLOSE

	; XXX provide implementation

dos_SECOND_OPEN:               ; XXX provide implementaation
dos_SECOND_CLOSE:              ; XXX provide implementaation

	; finish

dos_SECOND_done:

	ply
	bra dos_TKSA_done          ; reuse part of TKSA code


dos_TKSA:

	pha
	phx

	and #$0F                   ; support channels 0-15, like 1541 drive

	ldx IDX1_TALKER            ; store channel
	bmi dos_TKSA_done          ; do nothing if no taalker
	sta XX_CHANNEL, x

dos_TKSA_done:

	plx
	pla
	clc
	rts
