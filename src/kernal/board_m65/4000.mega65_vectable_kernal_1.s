// #LAYOUT# M65 KERNAL_0 #TAKE-FLOAT
// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Definitions for communication with Mega65 segment KERNAL_1 from KERNAL_0
//


#if SEGMENT_KERNAL_0

	// Label definitions

	.label VK1__IOINIT                    = $4000 + 2 * 0
	.label VK1__RAMTAS                    = $4000 + 2 * 1
	.label VK1__setup_vicii               = $4000 + 2 * 2
	.label VK1__load_tape_normal          = $4000 + 2 * 3
	.label VK1__load_tape_turbo           = $4000 + 2 * 4
	.label VK1__load_tape_auto            = $4000 + 2 * 5
	.label VK1__tape_head_align           = $4000 + 2 * 6
	.label VK1__m65_chrout_screen         = $4000 + 2 * 7
	.label VK1__m65_chrin_keyboard        = $4000 + 2 * 8
	.label VK1__M65_MODE64                = $4000 + 2 * 9
	.label VK1__M65_MODE65                = $4000 + 2 * 10
	.label VK1__M65_SCRMODEGET            = $4000 + 2 * 11
	.label VK1__M65_SCRMODESET            = $4000 + 2 * 12
	.label VK1__M65_CLRSCR                = $4000 + 2 * 13
	.label VK1__M65_CLRWIN                = $4000 + 2 * 14
	.label VK1__m65_screen_upd_txtrow_off = $4000 + 2 * 15

#else

	// Vector table (Open ROMs private!)

	.word IOINIT
	.word RAMTAS
	.word setup_vicii

#if CONFIG_TAPE_NORMAL && !CONFIG_TAPE_AUTODETECT
	.word load_tape_normal
#else
	.word $0000
#endif

#if CONFIG_TAPE_TURBO && !CONFIG_TAPE_AUTODETECT
	.word load_tape_turbo
#else
	.word $0000
#endif

#if CONFIG_TAPE_AUTODETECT
	.word load_tape_auto
#else
	.word $0000
#endif

#if CONFIG_TAPE_HEAD_ALIGN
	.word tape_head_align
#else
	.word $0000
#endif

	.word m65_chrout_screen
	.word m65_chrin_keyboard

	.word M65_MODE64
	.word M65_MODE65
	.word M65_SCRMODEGET
	.word M65_SCRMODESET
	.word M65_CLRSCR	
	.word M65_CLRWIN
	.word m65_screen_upd_txtrow_off

#endif
