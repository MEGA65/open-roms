;; #LAYOUT# M65 KERNAL_0 #TAKE-FLOAT
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Definitions for communication with MEGA65 segment KERNAL_1 from KERNAL_0
;


!ifdef SEGMENT_KERNAL_0 {

	; Label definitions

	!addr VK1__IOINIT                    = $4000 + 2 * 0
	!addr VK1__RAMTAS                    = $4000 + 2 * 1
	!addr VK1__vicii_init                = $4000 + 2 * 2
	!addr VK1__load_tape_normal          = $4000 + 2 * 3
	!addr VK1__load_tape_turbo           = $4000 + 2 * 4
	!addr VK1__load_tape_auto            = $4000 + 2 * 5
	!addr VK1__tape_head_align           = $4000 + 2 * 6
	!addr VK1__m65_chrout_screen         = $4000 + 2 * 7
	!addr VK1__m65_chrin_keyboard        = $4000 + 2 * 8
	!addr VK1__M65_MODESET               = $4000 + 2 * 9
	!addr VK1__M65_SCRMODEGET            = $4000 + 2 * 10
	!addr VK1__M65_SCRMODESET            = $4000 + 2 * 11
	!addr VK1__M65_CLRSCR                = $4000 + 2 * 12
	!addr VK1__M65_CLRWIN                = $4000 + 2 * 13
	!addr VK1__m65_screen_upd_txtrow_off = $4000 + 2 * 14
	!addr VK1__m65_shadow_BZP            = $4000 + 2 * 15
	!addr VK1__m65_colorset_reset        = $4000 + 2 * 16
	!addr VK1__m65_colorset              = $4000 + 2 * 17

} else {

	; Vector table (Open ROMs private!)

	!word IOINIT
	!word RAMTAS
	!word vicii_init

!ifdef CONFIG_TAPE_NORMAL { !ifndef CONFIG_TAPE_AUTODETECT {
	!word load_tape_normal
} else { !word $0000 } } else { !word $0000 }

!ifdef CONFIG_TAPE_TURBO { !ifndef CONFIG_TAPE_AUTODETECT {
	!word load_tape_turbo
} else { !word $0000 } } else { !word $0000 }

!ifdef CONFIG_TAPE_AUTODETECT {
	!word load_tape_auto
} else { !word $0000 }

!ifdef CONFIG_TAPE_HEAD_ALIGN {
	!word tape_head_align
} else { !word $0000 }

	!word m65_chrout_screen
	!word m65_chrin_keyboard

	!word M65_MODESET
	!word M65_SCRMODEGET
	!word M65_SCRMODESET
	!word M65_CLRSCR	
	!word M65_CLRWIN
	!word m65_screen_upd_txtrow_off
	!word m65_shadow_BZP
	!word m65_colorset_reset
	!word m65_colorset
}
