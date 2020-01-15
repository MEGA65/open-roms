// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


// Routine is too long to fit in the original location


initmsg_real:

	// Clear the screen first, some cartridges (like IEEE-488) leeave a mess on the screen
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
#if CONFIG_SHOW_PAL_NTSC && CONFIG_SHOW_FEATURES
	jsr plot_set
	jsr print_features
	jmp print_pal_ntsc
#elif CONFIG_SHOW_PAL_NTSC
	jsr plot_set
	jmp print_pal_ntsc
#elif CONFIG_SHOW_FEATURES
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
#if CONFIG_SHOW_PAL_NTSC && CONFIG_SHOW_FEATURES
	jsr plot_set
	jsr print_features
	jmp print_pal_ntsc
#elif CONFIG_SHOW_PAL_NTSC
	jsr plot_set
	jmp print_pal_ntsc
#elif CONFIG_SHOW_FEATURES
	jsr plot_set
	jmp print_features
#else
	jmp plot_set
#endif

#elif CONFIG_BANNER_BRAND && CONFIG_BRAND_MEGA_65

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

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
	jsr print_features
	jmp print_return
#else
	ldx #$08
	ldy #$00
	jmp plot_set
#endif


#endif
