;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifndef CONFIG_MEMORY_MODEL_46K_OR_50K {

follow_link_to_next_line:

	ldy #0
	
!ifdef CONFIG_MEMORY_MODEL_60K {

	ldx #<OLDTXT+0
	jsr peek_under_roms

	pha
	iny

	jsr peek_under_roms

} else { ; CONFIG_MEMORY_MODEL_38K

	lda (OLDTXT),y

	pha
	iny

	lda (OLDTXT),y
}

	sta OLDTXT+1
	pla
	sta OLDTXT+0

	rts
}
