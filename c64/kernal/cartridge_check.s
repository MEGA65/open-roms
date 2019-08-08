; c64 prg p263

cartridge_check:
	ldx #$04
cartridge_check_l1:
	lda CART_SIG,x
	cmp cartridge_signature,x
	bne no_cartridge
	dex
	bpl cartridge_check_l1
	sec
	rts
no_cartridge:
	clc
	rts
