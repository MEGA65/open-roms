// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// ROM mapping routines for Mega65
//

// Available memory maps:
// - NORMAL            - nothing mapped in
// - KERNAL_1          - for calling KERNAL_1 segment code
// - DOS_1             - for swiching to DOS context
// - NORMAL_from_DOS_1 - for switching bact from DOS context


map_NORMAL:

	php
	pha
	phx
	phy
	phz

	lda #$00

	// FALLTROUGH

map_NORMAL_common:

	tax
	tay
	taz

	// FALLTROUGH

map_end:

	map
	eom

	// FALLTROUGH

map_end_no_eom:

	plz
	ply
	plx
	pla
	plp

	rts


map_KERNAL_1:

	php
	pha
	phx
	phy
	phz

	lda #$00
	tay
	taz

	ldx #$42                 // $4000 <- map 8KB from $20000

	jmp_8 map_end

map_DOS_1:

	php
	pha
	phx
	phy
	phz

	lda #$80
	tab                      // from now on, zeropage starts from $C000

	ldy #$80
	lda #$30
	taz                      // $8000 <- map 16KB RAM from $10000

	lda #$C0
	ldx #$C1                 // $4000 <- map 16KB ROM from $20000

	map
	jmp_8 map_end_no_eom     // no EOM, we do not want interrupts within DOS!

map_NORMAL_from_DOS_1:

	php
	pha
	phx
	phy
	phz

	lda #$00
	tab

	jmp_8 map_NORMAL_common
