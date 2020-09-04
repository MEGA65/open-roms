// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


// 'DEL' key support

m65_chrout_screen_DEL:

	// First check for window mode

	lda M65_SCRWINMODE
	bmi m65_chrout_screen_DEL_winmode

	// Not a window mode; check if we are in the first column

	lda M65__TXTCOL
	beq m65_chrout_screen_DEL_1stcol

	// Not a window mode, not a first column - we can safely
	// delete the character and sroll back the rest of the row

	phz

	jsr m65_helper_scrlpnt_color
	jsr m65_chrout_screen_DEL_copy
	
	ldz M65_SCRCOLMAX
	lda COLOR
	and #$0F
	sta_lp (M65_LPNT_SCR), z

	jsr m65_helper_scrlpnt_to_screen
	jsr m65_chrout_screen_DEL_copy

	ldz M65_SCRCOLMAX
	lda #$20
	sta_lp (M65_LPNT_SCR), z

	plz

	// End by moving cursor one position left

	jmp m65_chrout_screen_CRSR_LEFT

m65_chrout_screen_DEL_copy:

	ldz M65__TXTCOL
	dez
!:
	cpz M65_SCRCOLMAX
	beq !+

	inz
	lda_lp (M65_LPNT_SCR), z
	dez 
	sta_lp (M65_LPNT_SCR), z
	
	inz
	jmp_8 !-
!:
	rts


m65_chrout_screen_DEL_1stcol:

	// Start by moving one position left

	jsr m65_chrout_screen_CRSR_LEFT

	// If we are still in the first column - nothing to do

	lda M65__TXTCOL
	beq !+

	// Deleta character under cursor

	phz

	jsr m65_helper_scrlpnt_color
	ldz M65__TXTCOL

	lda COLOR
	and #$0F
	sta_lp (M65_LPNT_SCR), z

	jsr m65_helper_scrlpnt_to_screen
	lda #$20
	sta_lp (M65_LPNT_SCR), z

	plz

	// End of character deletion
!:
	jmp m65_chrout_screen_done


m65_chrout_screen_DEL_winmode:

	// XXX provide implementation for window mode

	jmp m65_chrout_screen_done

