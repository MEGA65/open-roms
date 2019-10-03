
//
// Well-known BASIC routine, described in:
//
// - [CM64] Compute's Mapping the Commodore 64 - page 212
//
// Prints the start-up messages
//

INITMSG:

	// Print startup banner, up to 255 characters
	ldx #$00
!:
	lda startup_banner, x
	beq !+ // 0 means end of banner
	jsr JCHROUT
	inx
	bne !-

!:
	// Print PAL/NTSC
	ldx #30 // NTSC
	lda TVSFLG
	beq !+
	ldx #31 // PAL
!:
	jsr print_packed_message

	// Work out free bytes, display them
	jsr basic_do_new
	lda MEMSIZ+0
	sec
	sbc TXTTAB+0
	tax
	lda MEMSIZ+1
	sbc TXTTAB+1

	jsr print_integer
	jsr print_space

	// Print rest of the start up message
	ldx #34
	jmp print_packed_message
