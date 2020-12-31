
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
	; Destroys:     NONE
	;

	ldx #$00
	
@loop_atable_bank0:
	
	cpx #$C0
	bcs @addr_common
	
	; Memory area $0000-$BFFF - maps somewhere to $0xxxx range - 48KB total

	lda #$00
	sta z80_atable_hi_bank0, x

	txa
	cmp #$60
	bcc @addr_lo

@addr_hi:

	; Memory area $6000-$BFFF - maps to $0C000 - $0FFFF - 24 KB

	clc
	adc #$40

@addr_lo:

	; Memory area $0000-$5FFF - maps to $02000 - $07FFF - 24 KB

	adc #$20
	sta z80_atable_mi_bank0, x

	bra @loop_atable_next

@addr_common:
	
	; Memory area $C000-$FFFF - maps to $5C000-$5FFFF - 16KB
	
	lda #$05
	sta z80_atable_hi_bank0, x
	txa
	sta z80_atable_mi_bank0, x	
	
@loop_atable_next:

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
