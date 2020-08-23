// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# *   *       #IGNORE


// Routine is too long to fit in the original location

// XXX banner-related code needs cleanup, move MEGA65 stuff to a separate file


INITMSG:

	// Clear the screen first, some cartridges (like IEEE-488) are leaving a mess on the screen
	lda #147
	jsr JCHROUT

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

	jsr M65_ISMODE65
	bcc !+                             // XXX for MEGA65 native mode, display something else instead

	ldx #$02
	ldy #$21
	jsr plot_set

	lda #<startup_banner_legacy
	ldy #>startup_banner_legacy
	jsr STROUT
!:

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
