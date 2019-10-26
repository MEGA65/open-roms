// c64 prg p263

cartridge_check:
	ldx #$05
cartridge_check_l1:
	lda CART_SIG-1,x
	cmp cartridge_signature-1,x
	bne no_cartridge
	dex
	bne cartridge_check_l1
	// FALLTROUGH
no_cartridge:
	rts
