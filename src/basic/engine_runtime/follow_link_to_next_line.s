;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

follow_link_to_next_line:

	ldy #0

	; XXX! for models 46K/50K provide optimized version
	
!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<OLDTXT+0
	jsr peek_under_roms
} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	jsr peek_under_roms_via_OLDTXT
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	pha
	iny

!ifdef CONFIG_MEMORY_MODEL_60K {
	jsr peek_under_roms
} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	jsr peek_under_roms_via_OLDTXT
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	sta OLDTXT+1
	pla
	sta OLDTXT+0

	rts
