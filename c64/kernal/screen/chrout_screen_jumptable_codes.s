#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Jumptable for screen control codes support. To improve performance, should be sorted
// starting from the least probable routine.
//


chrout_screen_jumptable_codes:

	.byte KEY_CLR 
	.byte KEY_HOME
	.byte KEY_SHIFT_OFF
	.byte KEY_SHIFT_ON
	.byte KEY_TXT
	.byte KEY_GFX
	.byte KEY_RVS_OFF
	.byte KEY_RVS_ON
	.byte KEY_CRSR_RIGHT
	.byte KEY_CRSR_LEFT
	.byte KEY_CRSR_DOWN
	.byte KEY_CRSR_UP

__chrout_screen_jumptable_quote_guard:

#if CONFIG_EDIT_STOPQUOTE
	.byte KEY_STOP
#endif
#if CONFIG_EDIT_TABULATORS
	.byte KEY_TAB_BW
	.byte KEY_TAB_FW
#endif
	.byte KEY_INS
	.byte KEY_DEL
	.byte KEY_RETURN

__chrout_screen_jumptable_codes_end:


#if !HAS_OPCODES_65C02

chrout_screen_jumptable_lo:

	.byte <(chrout_screen_CLR        - 1)
	.byte <(chrout_screen_HOME       - 1)
	.byte <(chrout_screen_SHIFT_OFF  - 1)
	.byte <(chrout_screen_SHIFT_ON   - 1)
	.byte <(chrout_screen_TXT        - 1)
	.byte <(chrout_screen_GFX        - 1)
	.byte <(chrout_screen_RVS_OFF    - 1)
	.byte <(chrout_screen_RVS_ON     - 1)
	.byte <(chrout_screen_CRSR_RIGHT - 1)
	.byte <(chrout_screen_CRSR_LEFT  - 1)
	.byte <(chrout_screen_CRSR_DOWN  - 1)
	.byte <(chrout_screen_CRSR_UP    - 1)
#if CONFIG_EDIT_STOPQUOTE
	.byte <(chrout_screen_STOP       - 1)
#endif
#if CONFIG_EDIT_TABULATORS
	.byte <(chrout_screen_TAB_BW     - 1)
	.byte <(chrout_screen_TAB_FW     - 1)
#endif
	.byte <(chrout_screen_INS        - 1)
	.byte <(chrout_screen_DEL        - 1)
	.byte <(chrout_screen_RETURN     - 1)

chrout_screen_jumptable_hi:

	.byte >(chrout_screen_CLR        - 1)
	.byte >(chrout_screen_HOME       - 1)
	.byte >(chrout_screen_SHIFT_OFF  - 1)
	.byte >(chrout_screen_SHIFT_ON   - 1)
	.byte >(chrout_screen_TXT        - 1)
	.byte >(chrout_screen_GFX        - 1)
	.byte >(chrout_screen_RVS_OFF    - 1)
	.byte >(chrout_screen_RVS_ON     - 1)
	.byte >(chrout_screen_CRSR_RIGHT - 1)
	.byte >(chrout_screen_CRSR_LEFT  - 1)
	.byte >(chrout_screen_CRSR_DOWN  - 1)
	.byte >(chrout_screen_CRSR_UP    - 1)
#if CONFIG_EDIT_STOPQUOTE
	.byte >(chrout_screen_STOP       - 1)
#endif
#if CONFIG_EDIT_TABULATORS
	.byte >(chrout_screen_TAB_BW     - 1)
	.byte >(chrout_screen_TAB_FW     - 1)
#endif
	.byte >(chrout_screen_INS        - 1)
	.byte >(chrout_screen_DEL        - 1)
	.byte >(chrout_screen_RETURN     - 1)

#else

.if (mod(*, $2) == 1) { nop }          // align code so that vector never crosses page boundary

chrout_screen_jumptable:

	.word chrout_screen_CLR
	.word chrout_screen_HOME
	.word chrout_screen_SHIFT_OFF
	.word chrout_screen_SHIFT_ON
	.word chrout_screen_TXT
	.word chrout_screen_GFX
	.word chrout_screen_RVS_OFF
	.word chrout_screen_RVS_ON
	.word chrout_screen_CRSR_RIGHT
	.word chrout_screen_CRSR_LEFT
	.word chrout_screen_CRSR_DOWN
	.word chrout_screen_CRSR_UP
#if CONFIG_EDIT_STOPQUOTE
	.word chrout_screen_STOP
#endif
#if CONFIG_EDIT_TABULATORS
	.word chrout_screen_TAB_BW
	.word chrout_screen_TAB_FW
#endif
	.word chrout_screen_INS
	.word chrout_screen_DEL
	.word chrout_screen_RETURN

.if (mod(*, $2) == 0) { nop }          // make sure routine size is always the same, needed by build system

#endif


#endif // ROM layout
