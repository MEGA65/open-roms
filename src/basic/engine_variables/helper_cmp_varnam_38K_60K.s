;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifndef CONFIG_MEMORY_MODEL_46K_OR_50K {

helper_cmp_varnam:

	ldy #$00

!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<VARPNT
	jsr peek_under_roms
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (VARPNT),y
}

	cmp VARNAM+0
	bne @1

	iny

!ifdef CONFIG_MEMORY_MODEL_60K {
	jsr peek_under_roms
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (VARPNT),y
}

	cmp VARNAM+1
@1:
	rts
}
