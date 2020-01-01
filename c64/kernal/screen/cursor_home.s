
//
// Home the cursor (Compute's Mapping the 64 p216)
//

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


cursor_home:
	jmp cursor_home


/* YYY disabled for rework
cursor_home:

	lda #$00
	sta PNTR // x position
	sta TBLX // y position

	jmp screen_calculate_line_pointer
*/