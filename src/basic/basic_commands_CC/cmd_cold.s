// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


#if !HAS_SMALL_BASIC

cmd_cold:

	jsr helper_ask_if_sure
	bcs !+

	jsr JCLALL                         // for extra safety
	jmp (vector_reset)                 // hardware CPU vector
!:
	rts

#endif
