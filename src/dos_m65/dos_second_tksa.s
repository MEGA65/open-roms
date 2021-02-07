
;
; Implementation of SECOND/TKSA commands.
; For detailed description see 'm65dos_bridge.s' file.
;


dos_SECOND:

	; XXX provide implementation

	sec
	rts


dos_TKSA:

	pha
	and #$60
	bne dos_TKSA_OPEN
	pla

	; XXX provide implementation

	sec
	rts


dos_TKSA_OPEN:

	pla
	and #$1F
	cmp #$0F
	beq dos_TKSA_OPEN_cmd

	; XXX provide implementation

	sec
	rts


dos_TKSA_OPEN_cmd:

	; XXX provide implementation

	sec
	rts
