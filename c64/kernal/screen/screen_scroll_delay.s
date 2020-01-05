
//
// Handles CTRL and NO_SCRL during screen scroll
//


screen_scroll_delay:

#if CONFIG_KEYBOARD_C128 || CONFIG_KEYBOARD_C65

	// Do not scroll if NO_SCRL is pressed and interrupts are enabled
!:
	php
	pla
	and #%00000010
	bne !+                             // branch if IRQs disabled, we cannot detect NO_SCRL status

	lda SHFLAG
	and #KEY_FLAG_NO_SCRL
	bne !-
!:

#endif

	// Check if CTRL key pressed - if so, perform a delay

	lda SHFLAG
	and #KEY_FLAG_CTRL
	beq screen_scroll_delay_done

	ldy #$09
!:
	ldx #$FF
	jsr wait_x_bars
	dey
	bne !-

screen_scroll_delay_done:
	
	rts
