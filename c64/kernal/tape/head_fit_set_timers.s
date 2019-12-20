
//
// Save system switcher for head alignment tool
//


#if CONFIG_HEAD_FIT_TOOL


head_fit_switch_system:

	lda #$01
	eor HF_IS_TURBO
	sta HF_IS_TURBO

	// FALLTROUNG

head_fit_setup_timers:

	ldx #$08
	lda HF_IS_TURBO
	beq !+
	ldx #$04
!:

	jsr tape_normal_setup_timers_custom

	rts


#endif
