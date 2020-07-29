// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_60K

helper_cmp_varnam:

	ldy #$00

#if CONFIG_MEMORY_MODEL_60K
	ldx #<VARPNT
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (VARPNT),y
#endif

	cmp VARNAM+0
	bne !+

	iny

#if CONFIG_MEMORY_MODEL_60K
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (VARPNT),y
#endif

	cmp VARNAM+1
!:
	rts

#endif
