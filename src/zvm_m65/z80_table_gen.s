
;
; Z80 emulator - precalculated data generator
;

z80_table_gen:

	jsr PRIMM
	!pet $0D, "Generating CPU tables... "
	!byte 0

	;
	; Generating:   z80_atable_mi_bank0, z80_atable_hi_bank0
	; Dependencies: NONE
	;

	ldx #$00
	
@loop_atable_bank0:
	
	cpx #$E0
	bcs @common_addr
	
	; Memory area $0000-$DFFF - maps to $02000-$0FFFF - 56KB

	lda #$04
	sta z80_atable_hi_bank0, x
	txa
	clc
	adc #$20
	sta z80_atable_mi_bank0, x

@common_addr:
	
	; Memory area $E000-$FFFF - maps to $4E000-$4FFFF - 8KB
	
	lda #$04
	sta z80_atable_hi_bank0, x
	txa
	sta z80_atable_mi_bank0, x	
	
	inx
	bne @loop_atable_bank0

	; XXX add more tables here

	;
	; The END
	;

	jsr PRIMM
	!pet "done", $0D, $0D
	!byte 0
	
	rts
