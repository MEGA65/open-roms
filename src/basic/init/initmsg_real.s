;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


; Routine is too long to fit in the original location


initmsg_real:

	; Clear the screen first, some cartridges (like IEEE-488) are leaving a mess on the screen
	lda #147
	jsr JCHROUT

!ifdef CONFIG_BANNER_SIMPLE {

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

!ifndef CONFIG_BRAND_CUSTOM {

	ldx #$01
	ldy #$04
	jsr plot_set

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

} ; no CONFIG_BRAND_CUSTOM

!ifndef CONFIG_BRAND_CUSTOM {
	ldx #$03
} else {
	ldx #$02
}
	ldy #$04
	jsr plot_set

	jsr initmsg_bytes_free

!ifndef CONFIG_BRAND_CUSTOM {
	ldx #$06
} else {
	ldx #$05
}
	ldy #$00
!ifdef CONFIG_SHOW_FEATURES {
	jsr plot_set
	jmp print_features
} else {
	jmp plot_set
}

} else ifdef CONFIG_BANNER_FANCY {
	
	lda #<rainbow_logo
	ldy #>rainbow_logo
	jsr STROUT

	ldx #$00
	ldy #$0A
	jsr plot_set

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

!ifndef CONFIG_BRAND_CUSTOM {

	ldx #$01
	ldy #$0A
	jsr plot_set

	ldx #IDX__STR_PRE_REV
	jsr print_packed_misc_str

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

} ; no CONFIG_BRAND_CUSTOM

!ifndef CONFIG_BRAND_CUSTOM {
	ldx #$03
} else {
	ldx #$02
}
	ldy #$0A
	jsr plot_set

	jsr initmsg_bytes_free

!ifndef CONFIG_BRAND_CUSTOM {
	ldx #$06
} else {
	ldx #$05
}
	ldy #$00
!ifdef CONFIG_SHOW_FEATURES {
	jsr plot_set
	jmp print_features
} else {
	jmp plot_set
}

}

!ifdef HAS_NOLGPL3_WARN { !error "HAS_NOLGPL3_WARN not implemented" 
