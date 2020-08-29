// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


m65_chrout_screen_control:

	txa

m65_chrout_try_jumptable:

	ldx #(__m65_chrout_screen_jumptable_codes_end - m65_chrout_screen_jumptable_codes - 1)

m65_chrout_try_jumptable_loop:

	cpx #(__m65_chrout_screen_jumptable_quote_guard - m65_chrout_screen_jumptable_codes - 1)
	bne m65_chrout_try_jumptable_loop_noquote

	// Is this insert/quote mode?

	tay
	lda QTSW
	ora INSRT
	beq !+
	tya
	jmp m65_chrout_screen_quote
!:
	tya

	// FALLTROUGH

m65_chrout_try_jumptable_loop_noquote:

	cmp m65_chrout_screen_jumptable_codes, x
	bne !+

	// Found, perform a jump to subroutine

	txa
	asl
	tax
	jmp (m65_chrout_screen_jumptable, x)

!:
	dex
	bpl m65_chrout_try_jumptable_loop

m65_chrout_try_COLOR:

	ldx #$0F

m65_chrout_try_color_loop:

	cmp colour_codes,x
	bne !+

	lda COLOR
	and #$F0
	sta COLOR

	txa
	ora COLOR
	sta COLOR

	jmp m65_chrout_screen_done
!:	
	dex
	bpl m65_chrout_try_color_loop

	// Unknown code, or key not requiring any handling

	jmp m65_chrout_screen_done




// XXX: implement screen routines below:

m65_chrout_screen_CLR:
	nop
m65_chrout_screen_HOME:
	nop
m65_chrout_screen_TAB:
	nop
m65_chrout_screen_LINE_FEED:
	nop
m65_chrout_screen_UNDERLINE_ON:
	nop
m65_chrout_screen_UNDERLINE_OFF:
	nop
m65_chrout_screen_FLASHING_ON:
	nop
m65_chrout_screen_FLASHING_OFF:
	nop
m65_chrout_screen_TAB_SET_CLR:
	nop
m65_chrout_screen_ESC:
	nop
m65_chrout_screen_BELL:
	nop
m65_chrout_screen_DEL:
	nop
m65_chrout_screen_GFX:
	nop
m65_chrout_screen_TXT:
	nop

	jmp m65_chrout_screen_done
