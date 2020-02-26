// #LAYOUT# M65 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// ROM mapping routines for Mega65
//

// Available memory maps:
// - NORMAL  - nothing mapped in (taken from Kernal)
// - BASIC_1 - for calling KERNAL_1 segment code


map_BASIC_1:

	php
	pha
	phx
	phy
	phz

	lda #$00
	tay
	taz

	lda #$20
	ldx #$42    // 0x4000 <- map 8KB from 0x22000

	jmp map_end
