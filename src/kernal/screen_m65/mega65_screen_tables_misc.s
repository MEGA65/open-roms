;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_scrtab_vic_ctrlb:        ; parameters for VIC control register B

	!byte %01100000 ; 40x25 + extended attributes + VFAST
	!byte %11100000 ; 80x25 + extended attributes + VFAST
	!byte %11101000 ; 80x50 + extended attributes + VFAST

m65_scrtab_colviewmax_lo:       ; maximum allowed color viewport start - low byte

	!byte <((MEMCONF_SCRROWS - 25) * 80)
	!byte <((MEMCONF_SCRROWS - 25) * 80)
	!byte <((MEMCONF_SCRROWS - 50) * 80)

m65_scrtab_colviewmax_hi:       ; maximum allowed color viewport start - high byte

	!byte >((MEMCONF_SCRROWS - 25) * 80)
	!byte >((MEMCONF_SCRROWS - 25) * 80)
	!byte >((MEMCONF_SCRROWS - 50) * 80)

m65_scrtab_scrolx:           ; values for VIC_SCROLX

	!byte $C8
	!byte $C9
	!byte $C9

m65_scrtab_rowoffset_lo:     ; row offsets - low bytes

	!byte <(80 *  0), <(80 *  1), <(80 *  2), <(80 *  3), <(80 *  4), <(80 *  5), <(80 *  6), <(80 *  7), <(80 *  8), <(80 *  9)
	!byte <(80 * 10), <(80 * 11), <(80 * 12), <(80 * 13), <(80 * 14), <(80 * 15), <(80 * 16), <(80 * 17), <(80 * 18), <(80 * 19)
	!byte <(80 * 20), <(80 * 21), <(80 * 22), <(80 * 23), <(80 * 24), <(80 * 25), <(80 * 26), <(80 * 27), <(80 * 28), <(80 * 29)
	!byte <(80 * 30), <(80 * 31), <(80 * 32), <(80 * 33), <(80 * 34), <(80 * 35), <(80 * 36), <(80 * 37), <(80 * 38), <(80 * 39)
	!byte <(80 * 40), <(80 * 41), <(80 * 42), <(80 * 43), <(80 * 44), <(80 * 45), <(80 * 46), <(80 * 47), <(80 * 48), <(80 * 49)

m65_scrtab_rowoffset_hi:     ; row offsets - high bytes

	!byte >(80 *  0), >(80 *  1), >(80 *  2), >(80 *  3), >(80 *  4), >(80 *  5), >(80 *  6), >(80 *  7), >(80 *  8), >(80 *  9)
	!byte >(80 * 10), >(80 * 11), >(80 * 12), >(80 * 13), >(80 * 14), >(80 * 15), >(80 * 16), >(80 * 17), >(80 * 18), >(80 * 19)
	!byte >(80 * 20), >(80 * 21), >(80 * 22), >(80 * 23), >(80 * 24), >(80 * 25), >(80 * 26), >(80 * 27), >(80 * 28), >(80 * 29)
	!byte >(80 * 30), >(80 * 31), >(80 * 32), >(80 * 33), >(80 * 34), >(80 * 35), >(80 * 36), >(80 * 37), >(80 * 38), >(80 * 39)
	!byte >(80 * 40), >(80 * 41), >(80 * 42), >(80 * 43), >(80 * 44), >(80 * 45), >(80 * 46), >(80 * 47), >(80 * 48), >(80 * 49)

; Jumptable for screen control codes support. To improve performance, should be sorted
; starting from the least probable routine.

m65_chrout_screen_jumptable_codes:

	!byte KEY_CLR 
	!byte KEY_HOME
	!byte KEY_C65_SHIFT_OFF
	!byte KEY_C65_SHIFT_ON
	!byte KEY_TXT
	!byte KEY_GFX
	!byte KEY_RVS_OFF
	!byte KEY_RVS_ON
	!byte KEY_CRSR_RIGHT
	!byte KEY_CRSR_LEFT
	!byte KEY_CRSR_DOWN
	!byte KEY_CRSR_UP
	!byte KEY_TAB
	!byte KEY_LINE_FEED
	!byte KEY_UNDERLINE_ON
	!byte KEY_UNDERLINE_OFF
	!byte KEY_FLASHING_ON
	!byte KEY_FLASHING_OFF
	!byte KEY_TAB_SET_CLR
	!byte KEY_ESC
	!byte KEY_BELL

__m65_chrout_screen_jumptable_quote_guard:

	!byte KEY_INS
	!byte KEY_STOP
	!byte KEY_DEL
	!byte KEY_RETURN
	!byte KEY_SHIFT_RETURN

__m65_chrout_screen_jumptable_codes_end:


m65_chrout_screen_jumptable:

	; Note: 65C02 has the page boundary vector bug fixed!

	!word m65_chrout_screen_CLR
	!word m65_chrout_screen_HOME
	!word m65_chrout_screen_SHIFT_OFF
	!word m65_chrout_screen_SHIFT_ON
	!word m65_chrout_screen_TXT
	!word m65_chrout_screen_GFX
	!word m65_chrout_screen_RVS_OFF
	!word m65_chrout_screen_RVS_ON
	!word m65_chrout_screen_CRSR_RIGHT
	!word m65_chrout_screen_CRSR_LEFT
	!word m65_chrout_screen_CRSR_DOWN
	!word m65_chrout_screen_CRSR_UP
	!word m65_chrout_screen_TAB
	!word m65_chrout_screen_LINE_FEED
	!word m65_chrout_screen_UNDERLINE_ON
	!word m65_chrout_screen_UNDERLINE_OFF
	!word m65_chrout_screen_FLASHING_ON
	!word m65_chrout_screen_FLASHING_OFF
	!word m65_chrout_screen_TAB_SET_CLR
	!word m65_chrout_screen_ESC
	!word m65_chrout_screen_BELL
	!word m65_chrout_screen_INS
	!word m65_chrout_screen_STOP
	!word m65_chrout_screen_DEL
	!word m65_chrout_screen_RETURN
	!word m65_chrout_screen_RETURN

m65_chrout_screen_jumptable_escape:

	!word m65_chrout_esc_0
	!word m65_chrout_esc_1
	!word m65_chrout_esc_2
	!word m65_chrout_esc_3
	!word m65_chrout_esc_4
	!word m65_chrout_esc_5
	!word m65_chrout_esc_6
	!word m65_chrout_esc_7
	!word m65_chrout_esc_8
	!word m65_chrout_esc_9
	!word m65_chrout_screen_done ; ':'
	!word m65_chrout_screen_done ; ';'
	!word m65_chrout_screen_done ; '<'
	!word m65_chrout_screen_done ; '='
	!word m65_chrout_screen_done ; '>'
	!word m65_chrout_screen_done ; '?'
	!word m65_chrout_esc_AT
	!word m65_chrout_esc_A
	!word m65_chrout_esc_B
	!word m65_chrout_esc_C
	!word m65_chrout_esc_D
	!word m65_chrout_esc_E
	!word m65_chrout_esc_F
	!word m65_chrout_esc_G
	!word m65_chrout_esc_H
	!word m65_chrout_esc_I
	!word m65_chrout_esc_J
	!word m65_chrout_esc_K
	!word m65_chrout_esc_L
	!word m65_chrout_esc_M
	!word m65_chrout_esc_N
	!word m65_chrout_esc_O
	!word m65_chrout_esc_P
	!word m65_chrout_esc_Q
	!word m65_chrout_esc_R
	!word m65_chrout_esc_S
	!word m65_chrout_esc_T
	!word m65_chrout_esc_U
	!word m65_chrout_esc_V
	!word m65_chrout_esc_W
	!word m65_chrout_esc_X
	!word m65_chrout_esc_Y
	!word m65_chrout_esc_Z
	!word m65_chrout_esc_LBR
	!word m65_chrout_screen_done ; pound symbol
	!word m65_chrout_esc_RBR
