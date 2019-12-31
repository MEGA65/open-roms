
//
// Home the cursor (Compute's Mapping the 64 p216)
//

/* YYY disabled for rework
cursor_home:

	lda #$00
	sta PNTR // x position
	sta TBLX // y position

	jmp screen_calculate_line_pointer
*/