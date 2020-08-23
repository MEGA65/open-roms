// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


m65_screen_upd_txtrow_off:

	ldy M65__TXTROW
	lda m65_scrtab_rowoffset_lo,y
	sta M65_TXTROW_OFF+0
	lda m65_scrtab_rowoffset_hi,y
	sta M65_TXTROW_OFF+1

	rts
