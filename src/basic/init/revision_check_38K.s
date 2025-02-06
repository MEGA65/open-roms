;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; A high memory version of the revision check specific to the 38K memory layout
;


!ifdef CONFIG_MEMORY_MODEL_38K {
!ifdef ROM_LAYOUT_STD {

revision_check:
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
	rts
}
}
