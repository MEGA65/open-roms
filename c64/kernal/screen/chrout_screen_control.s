
//
// CHROUT routine - screen support, control codes
//

chrout_screen_control:

	txa

	// Order here is not random
	// 1. First handle the ones that do not depend on quoote mode
	// 2. Handle remaining control codes starting from the most commonly used
	//    in situations when speed might matter, we want to be
	//    as snappy as possible

chrout_try_RETURN:

	cmp #KEY_RETURN
	bne !+

	// RETURN clears quote and insert modes, it also clears reverse flag
	lda #$00
	sta QTSW
	sta INSRT
	sta RVS
	jmp chrout_screen_advance_to_next_line
!:
chrout_try_DEL:

	cmp #KEY_DEL
	bne !+
	jmp chrout_screen_DEL
!:
chrout_try_INS:

	cmp #KEY_INS
	bne !+
	jmp chrout_screen_INS
!:
#if CONFIG_EDIT_STOPQUOTE
chrout_try_STOP:

	cmp #KEY_STOP
	bne !+
	
	lda #$00
	sta QTSW
	sta INSRT
	// Let it run, we are saving 3 bytes on JMP this way
	// and the performance hit is not going to be visible nevertheless
!:
#endif
chrout_try_quote:

	lda QTSW
	ora INSRT
	beq !+
	txa
	jmp chrout_screen_quote
!:
	txa

chrout_try_jumptable:

	ldx #(__chrout_screen_jumptable_codes_end - chrout_screen_jumptable_codes - 1)
chrout_try_jumptable_loop:
	cmp chrout_screen_jumptable_codes, x
	bne !+
	// Found, perform a jump to subroutine
	lda chrout_screen_jumptable_hi, x
	pha
	lda chrout_screen_jumptable_lo, x
	pha
	rts
!:
	dex
	bpl chrout_try_jumptable_loop

chrout_try_COLOR:

	ldx #$0F
chrout_try_color_loop:	
	cmp colour_codes,x
	bne !+
	stx COLOR
	jmp chrout_screen_done
!:	
	dex
	bpl chrout_try_color_loop

	// Unknown code, or key not requiring any handling
	jmp chrout_screen_done
