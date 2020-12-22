;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   *       #IGNORE


; Routine is too long to fit in the original location

; XXX banner-related code needs cleanup, move MEGA65 stuff to a separate file


INITMSG:

	jsr INITMSG_main_banner

	jsr M65_MODEGET
	bcc INITMSG_native

INITMSG_legacy:

	; Legacy C64 compatibility mode

	ldx #IDX__STR_ORS_LEGACY
	jsr print_packed_misc_str

	jsr initmsg_bytes_free

	ldx #$07
	ldy #$00
	jmp plot_set

INITMSG_native:

	; Native mode	

	ldx #48
	ldy #0
	jsr M65_SETWIN_XY

	ldx #32
	ldy #9
	jsr M65_SETWIN_WH

	jsr M65_SETWIN_Y
	jsr print_sysinfo_banner
	jsr M65_SETWIN_N

	; Native mode - display revision and available memory

	ldx #$05
	ldy #$00
	jsr plot_set

	ldx #IDX__STR_ORS
	jsr print_packed_misc_str

	ldx #IDX__STR_PRE_REV
	jsr print_packed_misc_str

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

	jsr print_return
	jsr print_return

	jsr initmsg_bytes_free

!ifdef HAS_NOLGPL3_WARN {

	lda #<str_nonlgpl3_warn
	ldy #>str_nonlgpl3_warn
	jmp STROUT

} else {

	ldx #$09
	ldy #$00
	jmp plot_set
}

INITMSG_main_banner:

	; Clear the screen first, some cartridges (like IEEE-488) are leaving a mess on the screen

	lda #147
	jsr JCHROUT

	; Display main banner

	lda #<startup_banner
	ldy #>startup_banner
	jmp STROUT

INITMSG_autoswitch:

	jsr INITMSG_main_banner

	ldx #IDX__STR_ORS_LEGACY
	jsr print_packed_misc_str

	jmp print_return
