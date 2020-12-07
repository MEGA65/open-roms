;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_chrout_screen_control:

	txa

m65_chrout_try_jumptable:

	ldx #(__m65_chrout_screen_jumptable_codes_end - m65_chrout_screen_jumptable_codes - 1)

m65_chrout_try_jumptable_loop:

	cpx #(__m65_chrout_screen_jumptable_quote_guard - m65_chrout_screen_jumptable_codes - 1)
	bne m65_chrout_try_jumptable_loop_noquote

	; Is this insert/quote mode?

	tay
	lda QTSW
	ora INSRT
	beq @1
	tya
	jmp m65_chrout_screen_quote
@1:
	tya

	; FALLTROUGH

m65_chrout_try_jumptable_loop_noquote:

	cmp m65_chrout_screen_jumptable_codes, x
	bne @2

	; Found, perform a jump to subroutine

	txa
	asl
	tax
	jmp (m65_chrout_screen_jumptable, x)

@2:
	dex
	bpl m65_chrout_try_jumptable_loop

m65_chrout_try_COLOR:

	ldx #$0F

m65_chrout_try_color_loop:

	cmp colour_codes,x
	bne @3

	lda COLOR
	and #$F0
	sta COLOR

	txa
	ora COLOR
	sta COLOR

	jmp m65_chrout_screen_done
@3:	
	dex
	bpl m65_chrout_try_color_loop

	; Unknown code, or key not requiring any handling

	jmp m65_chrout_screen_done




; XXX: implement screen routines below:

m65_chrout_screen_TAB:
	+nop
m65_chrout_screen_LINE_FEED:
	+nop
m65_chrout_screen_UNDERLINE_ON:
	+nop
m65_chrout_screen_UNDERLINE_OFF:
	+nop
m65_chrout_screen_FLASHING_ON:
	+nop
m65_chrout_screen_FLASHING_OFF:
	+nop
m65_chrout_screen_TAB_SET_CLR:
	+nop
m65_chrout_screen_ESC:
	+nop
m65_chrout_screen_BELL:

	jmp m65_chrout_screen_done

; XXX: implement the following functionalities according to MEGA65 book:
; CTRL +T +Z +E +Q +G +J +U +W +B +N +M +] +I +X +K +L +[
; ESC +@ +A +B +C +D +E +F +G +H +I +J +K +L +M +N +O +P +Q +S +T +U +V +W +X +Y +Z +1..8 
