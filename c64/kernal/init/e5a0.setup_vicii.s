
setup_vicii:

	// XXX it should also set default devices

	// Clear everything - turn off sprites (observed hanging around after
 	// running programs and resetting), etc.

	lda #$00
 	ldx #$2E
 !:
 	sta __VIC_BASE, x
 	dex
 	bpl !-

 	// Disable C128 extra keys - just to be sure they won't interfere with anything

 	stx VIC_XSCAN

 	// Disable the C128 2MHz mode, it prevents VIC-II display from working correctly

 	stx VIC_CLKRATE

	// Set up default IO values - Compute's Mapping the 64
	// - page 129       - VIC_SCROLY
	// - pages 140-144  - VIC_SCROLX
	// - pages 145-146  - VIC_YMCSB

	lda #$9B
	sta VIC_SCROLY
	lda #$C8
	sta VIC_SCROLX                     // 40 column etc
	lda #$14
	sta VIC_YMCSB
	lda #$0F
	sta VIC_IRQ                        // clear all interrupts


	// XXX initialize $D012 (VIC_RASTER) - which values to use?


	// We use a different colour scheme of white text on all blue

	lda #$06
	sta VIC_EXTCOL
	sta VIC_BGCOL0

	rts
