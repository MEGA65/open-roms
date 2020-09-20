;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; CHROUT routine - screen support, control codes
;

chrout_screen_control:

	txa

chrout_try_jumptable:

	ldx #(__chrout_screen_jumptable_codes_end - chrout_screen_jumptable_codes - 1)

chrout_try_jumptable_loop:

	cpx #(__chrout_screen_jumptable_quote_guard - chrout_screen_jumptable_codes - 1)
	bne chrout_try_jumptable_loop_noquote

	; Is this insert/quote mode?
	tay
	lda QTSW
	ora INSRT
	beq @1
	tya
	jmp chrout_screen_quote
@1:
	tya

	; FALLTROUGH

chrout_try_jumptable_loop_noquote:

	cmp chrout_screen_jumptable_codes, x
	bne @2

	; Found, perform a jump to subroutine
!ifndef HAS_OPCODES_65C02 {
	lda chrout_screen_jumptable_hi, x
	pha
	lda chrout_screen_jumptable_lo, x
	pha
	rts
} else {
	txa
	asl
	tax
	jmp (chrout_screen_jumptable, x)
}
@2:
	dex
	bpl chrout_try_jumptable_loop

chrout_try_COLOR:

	ldx #$0F

chrout_try_color_loop:

	cmp colour_codes,x
	bne @3
	stx COLOR
	jmp chrout_screen_done
@3:
	dex
	bpl chrout_try_color_loop

	; Unknown code, or key not requiring any handling
	jmp chrout_screen_done
