
// Routine is too long to fit in the original location


initmsg_real:

#if CONFIG_BANNER_SIMPLE

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

	ldx #$02
	ldy #$02
	jsr plot_set

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

	ldx #$04
	ldy #$02
	jsr plot_set

#if CONFIG_SHOW_PAL_NTSC
	jsr print_pal_ntsc
#endif

	jsr initmsg_bytes_free

	ldx #$07
	ldy #$00
	jmp plot_set

#elif CONFIG_BANNER_FANCY
	
	lda #<rainbow_logo
	ldy #>rainbow_logo
	jsr STROUT

	ldx #$01
	ldy #$0A
	jsr plot_set

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

	ldx #$03
	ldy #$0A
	jsr plot_set

	lda #<pre_revision_string
	ldy #>pre_revision_string
	jsr STROUT

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

	ldx #$05
	ldy #$00
	jsr plot_set

#if CONFIG_SHOW_PAL_NTSC
	jsr print_pal_ntsc
#endif

	jsr initmsg_bytes_free

	ldx #$07
	ldy #$00
	jmp plot_set

#elif CONFIG_BANNER_BRAND && CONFIG_BRAND_MEGA_65

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

	ldx #$03
	ldy #$12
	jsr plot_set

	jsr initmsg_bytes_free

	ldx #$05
	ldy #$00
	jmp plot_set

#endif
