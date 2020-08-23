// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


// Routine is too long to fit in the original location


#if ROM_LAYOUT_M65

INITMSG:

#else

initmsg_real:

#endif

	// Clear the screen first, some cartridges (like IEEE-488) are leaving a mess on the screen
	lda #147
	jsr JCHROUT

#if CONFIG_BANNER_SIMPLE

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

#if !CONFIG_BRAND_CUSTOM_BUILD

	ldx #$01
	ldy #$04
	jsr plot_set

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

#endif // no CONFIG_BRAND_CUSTOM_BUILD

#if !CONFIG_BRAND_CUSTOM_BUILD
	ldx #$03
#else
	ldx #$02
#endif
	ldy #$04
	jsr plot_set

	jsr initmsg_bytes_free

#if !CONFIG_BRAND_CUSTOM_BUILD
	ldx #$06
#else
	ldx #$05
#endif
	ldy #$00
#if CONFIG_SHOW_FEATURES
	jsr plot_set
	jmp print_features
#else
	jmp plot_set
#endif

#elif CONFIG_BANNER_FANCY
	
	lda #<rainbow_logo
	ldy #>rainbow_logo
	jsr STROUT

	ldx #$00
	ldy #$0A
	jsr plot_set

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

#if !CONFIG_BRAND_CUSTOM_BUILD

	ldx #$01
	ldy #$0A
	jsr plot_set

	lda #<pre_revision_string
	ldy #>pre_revision_string
	jsr STROUT

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

#endif // no CONFIG_BRAND_CUSTOM_BUILD

#if !CONFIG_BRAND_CUSTOM_BUILD
	ldx #$03
#else
	ldx #$02
#endif
	ldy #$0A
	jsr plot_set

	jsr initmsg_bytes_free

#if !CONFIG_BRAND_CUSTOM_BUILD
	ldx #$06
#else
	ldx #$05
#endif
	ldy #$00
#if CONFIG_SHOW_FEATURES
	jsr plot_set
	jmp print_features
#else
	jmp plot_set
#endif

#elif CONFIG_BANNER_BRAND && CONFIG_BRAND_MEGA_65

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

#if ROM_LAYOUT_M65

	jsr M65_ISMODE65
	bcc !+                             // XXX for MEGA65 native mode, display something else instead

	ldx #$02
	ldy #$21
	jsr plot_set

	lda #<text_mode_64
	ldy #>text_mode_64
	jsr STROUT
!:

#endif

	ldx #$05
	ldy #$00
	jsr plot_set

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

	ldx #$05
	ldy #$12
	jsr plot_set

	jsr initmsg_bytes_free

#if CONFIG_SHOW_FEATURES
	ldx #$08
	ldy #$00
	jsr plot_set
	jmp print_features
#else
	ldx #$07
	ldy #$00
	jmp plot_set
#endif


#endif
