
//
// Clear screen and initialise line link table, described in:
//
// - [CM64] Computes Mapping the Commodore 64 - pages 215-216
//


clear_screen_real:

	// YYY - do we need this? First disable the cursor
	// jsr cursor_disable

	// Clear the line link table - cheecked on original ROMs,
	// the highest bit set means that the line is NOT a logical
	// continuation of the previous one

	lda #$80
	ldy #24	
!:
	sta LDTBL,y
	dey
	bpl !-

	// YYY flow can probably be size-optimized, by clearing a single row each time (we will need such a subroutine)

	// Clear screen character RAM. Unfortunately, the HIBASE value is not on the zero page,
	// we will reuse PNT (it will be overridden in a moment nevertheless) as the pointer

	iny                                // sets .Y to 0
	sty PNT+0
	lda HIBASE
	sta PNT+1	

	ldx #$03                           // countdown for pages to update

clear_screen_loop:

	ldy #$00
	lda #$20                           // space character screen code
!:
	sta (PNT),y
	iny
	cpy #250                           // clear 250 bytes only, do not cross 1000 bytes barrier
	bne !-

	lda PNT+0
	clc
	adc #250
	sta PNT+0
	bcc !+
	inc PNT+1
!:
	dex
	bpl clear_screen_loop

	// Now clear the colour RAM - .Y is now 250, make use of this fact

	lda COLOR
!:
	sta $D800 - 1 + 250 * 0, y
	sta $D800 - 1 + 250 * 1, y
	sta $D800 - 1 + 250 * 2, y
	sta $D800 - 1 + 250 * 3, y
	dey
	bne !-

	// Fall to cursor home routine
	jmp cursor_home
