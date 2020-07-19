// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


tmpstr_free_all:

	// Go through all the temporary descriptors and free everything

	ldx #$19

	//FALLTROUGH

tmpstr_free_all_loop:

	// Free all the strings, one by one

	cpx TEMPPT
	beq tmpstr_free_all_reset

	lda $00, x
	beq !+

	phx_trash_a
	jsr varstr_free_non_0
	plx_trash_a
!:
	inx
	bne tmpstr_free_all_loop           // branch always

tmpstr_free_all_reset: // entry point for CLR

	// RESET TEMPPT and LASTPT to default values

	lda #$19
	sta TEMPPT
	lda #$16
	sta LASTPT
	
	rts
