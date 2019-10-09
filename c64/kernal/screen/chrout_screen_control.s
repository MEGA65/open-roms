
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

	cmp #$0D
	bne !+

	// RETURN clears quote and insert modes, it also clears reverse flag
	lda #$00
	sta QTSW
	sta INSRT
	sta RVS
	jmp screen_advance_to_next_line
!:
chrout_try_DEL:

	cmp #$14
	bne !+
	jmp chrout_screen_del
!:
chrout_try_quote:

	lda QTSW
	ora INSRT
	beq !+
	jmp chrout_screen_quote
!:
	txa

chrout_try_CRSR_UP:

	cmp #$91
	bne !+

	lda PNTR
	sec
	sbc #40
	sta PNTR
	jsr screen_calculate_line_pointer
	jmp chrout_done
!:
chrout_try_CRSR_DOWN:

	cmp #$11
	bne !+

	lda PNTR
	clc
	adc #40
	sta PNTR
	// We need to advance the pointer manually, as normalising
	// now will break things. The pointer update is required
	// so that we can tell if we really are on the bottom phys
	// screen line or not
	jsr screen_scroll_up_if_on_last_line
	jsr screen_calculate_line_pointer
	jmp chrout_done
!:
chrout_try_CRSR_LEFT:

	cmp #$9D
	bne !+

	lda TBLX
	ora PNTR
	beq chrout_screen_control_done // if top-left screen character
	dec PNTR
	jmp chrout_screen_control_calcptr_done
!:
chrout_try_CRSR_RIGHT:

	cmp #$1D
	bne !+

	inc PNTR
	jsr screen_calculate_line_pointer
	jmp chrout_done
!:
chrout_try_RVS_ON:

	cmp #$12
	bne !+

	lda #$80
	sta RVS
	bne chrout_screen_control_done // branch always
!:
chrout_try_RVS_OFF:

	cmp #$92
	bne !+

	lda #$00
	sta RVS
	beq chrout_screen_control_done // branch always
!:
chrout_try_MODE_TXT:

	cmp #$0E
	bne !+

	// XXX

	jmp chrout_done
!:
chrout_try_MODE_GFX:

	cmp #$8E
	bne !+

	// XXX

	jmp chrout_done
!:
chrout_try_COLOR:

	ldx #$0F
colour_check_loop:	
	cmp colour_codes,x
	bne !+
	stx COLOR
	jmp chrout_done
!:	
	dex
	bpl colour_check_loop

chrout_try_SHIFT_ENABLE:

	cmp #$09
	bne !+

	// XXX

	jmp chrout_done
!:
chrout_try_SHIFT_DISABLE:

	cmp #$08
	bne !+

	// XXX

	jmp chrout_done
!:
chrout_try_HOME:

	cmp #$13
	bne !+

	// XXX try cursor_home instead
	lda #$00
	sta PNTR
	sta TBLX
	beq chrout_screen_control_calcptr_done // branch always
!:
chrout_try_CLR:

	cmp #$93
	bne !+

	jsr clear_screen
	jmp chrout_done
!:
chrout_try_INS:

	cmp #$94
	bne !+

	jmp chrout_screen_ins
!:
chrout_try_RUN_STOP:

	cmp #$03
	bne !+

	// XXX

	jmp chrout_done
!:
chrout_try_FKEY:

	// XXX

	// FALLTROUGH

chrout_screen_control_done:  // unknown, LF, or no more actions required // XXX to !csc_done

	jmp chrout_done

chrout_screen_control_calcptr_done: // XXX to !csc_calcptr_done

	jsr screen_calculate_line_pointer
	jmp chrout_done
