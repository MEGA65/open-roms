;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


; BASIC Cold start entry point
; Computes Mapping the 64 p211

basic_cold_start:

!ifdef ROM_LAYOUT_STD { ; skip on non-standard ROM layouts - they produce single image nevertheless

!ifdef CONFIG_MEMORY_MODEL_38K {
    ; Special version in high memory for the 38K memory layout
    jsr revision_check
} else {


	; Before doing anything, check if we have a compatible BASIC/KERNAL pair

	ldy #(__rom_revision_basic_end - rom_revision_basic - 1)
@1:
	lda rom_revision_basic, y
	cmp rom_revision_kernal, y
	beq @2

	+panic P_ERR_ROM_MISMATCH

@2:
	dey
	bpl @1
}
}

	; Remaining part would not fit here

	jmp basic_cold_start_internal
