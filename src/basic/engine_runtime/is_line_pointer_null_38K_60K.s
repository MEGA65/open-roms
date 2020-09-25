;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; Return pointer in BASIC memory space status in Z flag


!ifndef CONFIG_MEMORY_MODEL_46K_OR_50K {

is_line_pointer_null:

	; Check the pointer

	ldy #$01                 ; for non-NULL pointer, high byte is almost certainly not NULL

!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<OLDTXT+0
	jsr peek_under_roms
	cmp #$00
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	bne @1
	dey

!ifdef CONFIG_MEMORY_MODEL_60K {
	jsr peek_under_roms
	cmp #$00
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

@1:
	rts
}
