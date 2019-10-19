
//
// Well-known Kernal routine, described in:
//
// - [CM64] Compute's Mapping the Commodore 64 - page 215
//


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

	// Set up default IO values
	// - [CM64] page 129       - VIC_SCROLY
	// - [CM64] pages 140-144  - VIC_SCROLX
	// - [CM64] pages 145-146  - VIC_YMCSB

	lda #$1B                           // according to [CM64] page 137 some software assumes oldest bit is 0
	sta VIC_SCROLY
	lda #$C8
	sta VIC_SCROLX                     // 40 column etc
	lda #$14
	sta VIC_YMCSB
	lda #$0F
	sta VIC_IRQ                        // clear all interrupts

	// We use a different colour scheme of white text on all blue

	lda #$06
	sta VIC_EXTCOL
	sta VIC_BGCOL0

	// Setup default I/O devices

	jmp clrchn_reset
