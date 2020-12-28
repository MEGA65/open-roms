;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


!ifdef SEGMENT_KERNAL_0 {

m65_colorset:

	jsr map_KERNAL_1
	jsr (VK1__m65_colorset)
	jmp map_NORMAL

} else {


m65_colorset_reset:

	; Make sure VIC-IV is unlocked

	jsr viciv_unhide

	; Enable RAM palette

	lda VIC_CTRLA
	ora #$04
	sta VIC_CTRLA

	; Clear all the pallettes, select the 1st one

	ldx #$03
@1:
	lda m65_colorset_selection, x
	sta VIC_PALSEL

	; Clear concrete palette

	lda #$00
	tay
@2:
	sta PALETTE_R, y
	sta PALETTE_G, y
	sta PALETTE_B, y

	iny
	bne @2

	dex
	bpl @1

	; Select default palette

	lda #CONFIG_VIC_PALETTE

	; FALLTROUGH

m65_colorset: ; entry point for BASIC; .A - palette, where bit 7 selects greyscale; sets Carry to mark palette out of range

	asl
	php

	cmp #($07 * 2)
	bcs m65_colorset_error

	; Prepare pointer to palette

	tax
	lda m65_colorset_presets+0, x
	sta PTR1+0
	lda m65_colorset_presets+1, x
	sta PTR1+1

	; Select color/greyscale variant

	plp
	bcs m65_colorset_greyscale

	; FALLTROUGH

m65_colorset_color:

	ldx #$03
@1:
	lda m65_colorset_selection, x
	sta VIC_PALSEL

	ldy #$0F
@2:
	lda (PTR1), y
	sta PALETTE_R, y
	jsr m65_colorset_get_bold
	sta PALETTE_R + $10, y	

	jsr m65_colorset_PTR1_inc_16

	lda (PTR1), y
	sta PALETTE_G, y
	jsr m65_colorset_get_bold
	sta PALETTE_G + $10, y	

	jsr m65_colorset_PTR1_inc_16

	lda (PTR1), y
	sta PALETTE_B, y
	jsr m65_colorset_get_bold
	sta PALETTE_B + $10, y	

	jsr m65_colorset_PTR1_dec_32

	dey
	bpl @2

	dex
	bpl @1

	; FALLTROUGH

m65_colorset_done:

	clc
	rts

m65_colorset_error:

	plp
	sec
	rts

m65_colorset_greyscale:

	jsr m65_colorset_PTR1_inc_16
	jsr m65_colorset_PTR1_inc_16
	jsr m65_colorset_PTR1_inc_16

	ldx #$03
@1:
	lda m65_colorset_selection, x
	sta VIC_PALSEL

	ldy #$0F
@2:
	lda (PTR1), y
	sta PALETTE_R, y
	sta PALETTE_G, y
	sta PALETTE_B, y

	jsr m65_colorset_get_bold
	sta PALETTE_R + $10, y
	sta PALETTE_G + $10, y
	sta PALETTE_B + $10, y	

	dey
	bpl @2

	dex
	bpl @1

	clc
	rts

m65_colorset_PTR1_inc_16:

	clc
	lda PTR1+0
	adc #$10
	sta PTR1+0
	bcc @1
	inc PTR1+1
@1:
	rts

m65_colorset_PTR1_dec_32:

	sec
	lda PTR1+0
    sbc #$20
	sta PTR1+0
	bcs @1
	dec PTR1+1
@1:
	rts

m65_colorset_get_bold:

	phy
	lda m65_colorset_bold_tab, y
	tay
	lda (PTR1), y
	ply

	rts

m65_colorset_selection:

	!byte %11000000, %10000000, %01000000, %00000000

m65_colorset_presets:

	!word m65_colorset_2 ; default one
	!word m65_colorset_1
	!word m65_colorset_2
	!word m65_colorset_3
	!word m65_colorset_4
	!word m65_colorset_5
	!word m65_colorset_6
}
