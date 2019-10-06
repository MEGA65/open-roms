
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

	// Print PAL/NTSC, if configured

#if CONFIG_BANNER_PAL_NTSC
	jsr print_pal_ntsc
#endif

	// Work out free bytes, display them
	jsr basic_do_new
    sec
	lda MEMSIZ+0
	sbc TXTTAB+0
	tax
	lda MEMSIZ+1
	sbc TXTTAB+1

	jsr print_integer

	// Print rest of the start up message
	ldx #34
	jsr print_packed_message

	// XXX put them into packed message
	jsr print_return
	jmp print_return
