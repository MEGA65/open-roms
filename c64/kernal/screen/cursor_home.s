
//
// Home the cursor (Compute's Mapping the 64 p216)
//

cursor_home:

	lda #$00
	sta PNTR // x position
	sta TBLX // y position

	jmp screen_set_pointer_to_current_line
