;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_screen_clear_colorattr:

	lda COLOR
	and #$0F
	sta COLOR

	rts


m65_screen_upd_txtrow_off:

	ldy M65__TXTROW
	lda m65_scrtab_rowoffset_lo,y
	sta M65_TXTROW_OFF+0
	lda m65_scrtab_rowoffset_hi,y
	sta M65_TXTROW_OFF+1

	rts


m65_screen_dmasrcdst_screen:

	; Set screen memory as start/end addresses

	lda M65_SCRBASE+0
	sta M65_DMAJOB_SRC_0
	sta M65_DMAJOB_DST_0
	lda M65_SCRBASE+1
	sta M65_DMAJOB_SRC_1
	sta M65_DMAJOB_DST_1
	lda M65_SCRSEG+0
	sta M65_DMAJOB_SRC_2
	sta M65_DMAJOB_DST_2
	lda M65_SCRSEG+1

	; FALLTROUGH

m65_screen_dmasrcdst_screen_cont:

	sta M65_DMAJOB_SRC_3
	sta M65_DMAJOB_DST_3

	rts


m65_screen_dmasrcdst_color:

	; Set color memory as start/end addresses

	lda #$00
	sta M65_DMAJOB_SRC_0
	sta M65_DMAJOB_DST_0
	sta M65_DMAJOB_SRC_1
	sta M65_DMAJOB_DST_1
	lda #$F8
	sta M65_DMAJOB_SRC_2
	sta M65_DMAJOB_DST_2
	lda #$0F
	bra m65_screen_dmasrcdst_screen_cont


m65_screen_dmasrc_add_row:

	clc
	lda M65_DMAJOB_SRC_0
	adc #$50
	sta M65_DMAJOB_SRC_0
	bcc @1
	inc M65_DMAJOB_SRC_1
@1:
	rts
