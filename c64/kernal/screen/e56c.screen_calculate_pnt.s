
//
// Set pointer (PNT) to current screen line , described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 216
//


screen_calculate_PNT:

	// YYY implement this!
	rts


// Variables: (http://sta.c64.org/cbm64mem.html)
// - $C7     - RVS    - reverse mode switch
// - $C8     - INDX   - length of line minus 1 during screen input. Values: $27, 39; $4F, 79.
// - $C9     - LXSP+0 - cursor row during screen input. Values: $00-$18, 0-24.
// - $CA     - LXSP+1 - cursor column during screen input. Values: $00-$27, 0-39.
// - $CC     - BLNSW  - cursor visibility switch. Values: $01-$FF: Cursor is off.
// - $CD     - BLNCT  - delay counter for changing cursor phase. Values:
// - $CE     - GDBLN  - screen code of character under cursor
// - $CF     - BLNON  - cursor phase switch
// - $D0     - CRSW   - end of line switch during screen input
// - $D1-$D2 - PNT    - pointer to current line in screen memory.
// - $D3     - PNTR   - current cursor column. Values: $00-$27, 0-39.
// - $D4     - QTSW   - quotation mode switch
// - $D5     - LNMX   - length of current screen line minus 1. Values: $27, 39; $4F, 79.
// - $D6     - TBLX   - current cursor row. Values: $00-$18, 0-24.
// - $D8     - INSRT  - number of insertions
// - $D9-$F1 - LDTBL  - link table
// - $F2              - temporary value for screen scroll
// - $F3-$F4 - USER   - pointer to current line in Color RAM.
// - $02A5   - TLNIDX - number of line currently being scrolled during scrolling the screen


/* YYY disabled for rework

screen_calculate_line_pointer:
	jsr screen_normalize_xy
	
	//  Reset pointer to start of screen
	lda HIBASE
	sta PNT+1
	lda #0
	sta PNT+0

	// Add 40 for every line, or 80 if the lines are linked
	ldx TBLX

!:
	// Stop if we have counted enough lines
	beq !+

	// Add 40 or 80 based on whether the line is linked
	// or not.
	ldy #40
	// -1 offset is because we count down from N to 1, not
	// N-1 to 0.
	lda LDTBL-1,x
	bpl sclp_l1
	ldy #80
sclp_l1:
	// Add computed line length to pointer value
	tya
	clc
	adc PNT+0
	sta PNT+0
	lda PNT+1
	adc #0
	sta PNT+1
	
	// Loop back to next line
	dex
	jmp !-
!:

	// FALLTHROUGH

update_colour_line_pointer:
	// Now setup pointer to colour RAM
	lda PNT+0
	sta USER+0
	lda PNT+1
	sec
	sbc HIBASE
	clc
	adc #>$d800
	sta USER+1

	rts
*/