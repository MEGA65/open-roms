// #LAYOUT# STD *        #TAKE
// #LAYOUT# X16 *        #IGNORE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Jumptable for screen control codes support. To improve performance, should be sorted
// starting from the least probable routine.
//


chrout_screen_jumptable_codes:

	.byte KEY_CLR 
	.byte KEY_HOME
	.byte KEY_C64_SHIFT_OFF
	.byte KEY_C64_SHIFT_ON
	.byte KEY_TXT
	.byte KEY_GFX
	.byte KEY_RVS_OFF
	.byte KEY_RVS_ON
	.byte KEY_CRSR_RIGHT
	.byte KEY_CRSR_LEFT
	.byte KEY_CRSR_DOWN
	.byte KEY_CRSR_UP
	.byte KEY_INS

__chrout_screen_jumptable_quote_guard:

#if CONFIG_EDIT_STOPQUOTE
	.byte KEY_STOP
#endif
#if CONFIG_EDIT_TABULATORS
	.byte KEY_C64_TAB_BW
	.byte KEY_C64_TAB_FW
#endif
	.byte KEY_DEL
	.byte KEY_RETURN

__chrout_screen_jumptable_codes_end:



.const chrout_list = List().add(

	chrout_screen_CLR,
	chrout_screen_HOME,
	chrout_screen_SHIFT_OFF,
	chrout_screen_SHIFT_ON,
	chrout_screen_TXT,
	chrout_screen_GFX,
	chrout_screen_RVS_OFF,
	chrout_screen_RVS_ON,
	chrout_screen_CRSR_RIGHT,
	chrout_screen_CRSR_LEFT,
	chrout_screen_CRSR_DOWN,
	chrout_screen_CRSR_UP,
	chrout_screen_INS,
#if CONFIG_EDIT_STOPQUOTE
	chrout_screen_STOP,
#endif
#if CONFIG_EDIT_TABULATORS
	chrout_screen_TAB_BW,
	chrout_screen_TAB_FW,
#endif
	chrout_screen_DEL,
	chrout_screen_RETURN
)


#if !HAS_OPCODES_65C02


chrout_screen_jumptable_lo:

	put_jumptable_lo(chrout_list)


chrout_screen_jumptable_hi:

	put_jumptable_hi(chrout_list)


#else // HAS_OPCODES_65C02

chrout_screen_jumptable:

	// Note: 65C02 has the page boundary vector bug fixed!
	put_jumptable(chrout_list)

#endif
