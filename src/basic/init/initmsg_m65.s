;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   *       #IGNORE


; Routine is too long to fit in the original location

; XXX banner-related code needs cleanup, move MEGA65 stuff to a separate file


INITMSG:

	jsr INITMSG_main_banner

	; Display additional information, depending on the mode

	jsr M65_MODEGET
	bcc @1

	; Legacy C64 compatibility mode

	jsr INITMSG_partial

	ldx #IDX__STR_ORS_LEGACY_2
	jsr print_packed_misc_str

	bra INITMSG_end
@1:
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

	jsr INITMSG_revision

	jsr print_return
	jsr print_return

	; FALLTROUGH

INITMSG_end:

	jsr initmsg_bytes_free

	ldx #$09
	ldy #$00
	jmp plot_set

INITMSG_main_banner:

	; Clear the screen first, some cartridges (like IEEE-488) are leaving a mess on the screen

	lda #147
	jsr JCHROUT

	; Display main banner

	lda #<startup_banner
	ldy #>startup_banner
	jmp STROUT

INITMSG_autoswitch: ; entry point for 'SYS command'

	jsr INITMSG_main_banner
	jsr INITMSG_partial

	jsr print_return
	jmp print_return

INITMSG_partial:

	ldx #IDX__STR_ORS_LEGACY_1
	jsr print_packed_misc_str

	; FALLTROUGH

INITMSG_revision:

	ldx #IDX__STR_PRE_REV
	jsr print_packed_misc_str

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jmp STROUT
