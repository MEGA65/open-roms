; c64 prg p263

cartridge_check:
	ldx #$04
cartridge_check_l1:
	lda $8002,x
	cmp cartridge_signature,x
	bne no_cartridge
	dex
	bpl cartridge_check_l1
	jmp ($8000)
cartridge_signature:
	.byte $C3,$C2,$CD,$38,$30
no_cartridge:
	rts
