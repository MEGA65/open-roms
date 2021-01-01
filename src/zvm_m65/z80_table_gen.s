
;
; Z80 emulator - precalculated data generator
;

z80_table_gen:

	jsr PRIMM
	!pet $0D, "Generating CPU tables... "
	!byte 0

	;
	; Generating:   z80_atable_bank0
	; Dependencies: NONE
	; Destroys:     NONE
	;

	ldx #$00

@loop_atable_bank0:

	lda #$04                           ;  $0000-$DFFF maps to $40000-$4DFFF (bank 0 RAM)
	cpx #$E0
	bcc @loop_atable_bank0_gotit
	inc                                ;  $E000-$FFFF maps to $5E000-$5FFFF (common RAM)

@loop_atable_bank0_gotit:

	sta z80_atable_bank0, x

	inx
	bne @loop_atable_bank0

	;
	; Generating:   XXX
	; Dependencies: NONE
	; Destroys:     NONE
	;

	; XXX add more tables here

	;
	; The END
	;

	jsr PRIMM
	!pet "done", $0D, $0D
	!byte 0
	
	rts
