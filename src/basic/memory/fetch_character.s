;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Fetches a single character
;

!set NEEDED = 0
; For these configurations we have optimized version in another file
!ifndef CONFIG_MB_M65                  { !set NEEDED = 1 }
!ifndef CONFIG_MEMORY_MODEL_46K_OR_50K { !set NEEDED = 1 }

!if NEEDED {

fetch_character:

	ldy #0

!ifdef CONFIG_MEMORY_MODEL_60K {

	ldx #<TXTPTR
	jsr peek_under_roms

} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

	jsr peek_under_roms_via_TXTPTR

} else { ; CONFIG_MEMORY_MODEL_38K

	lda (TXTPTR),y
}

!ifndef HAS_OPCODES_65CE02 {

	; FALLTHROUGH
	
consume_character:

	; Advance basic text pointer

	inc TXTPTR+0
	bne @1
	inc TXTPTR+1
@1:

} else { ; HAS_OPCODES_65CE02

	; Advance basic text pointer

	inw TXTPTR
}

	rts
}
