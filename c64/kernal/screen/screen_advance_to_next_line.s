// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE


screen_advance_to_next_line:

	// Check if we are at the bottom of the screen
	ldy TBLX
	cpy #24
	bne !+

	// We need to scroll the screen up
	jsr screen_scroll_up
!:
	inc TBLX

	// Set PNTR to 0 (for continued line will be fixed later)
	lda #$00
	sta PNTR

	jmp chrout_screen_calc_lptr_done
