// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


cmd_cold:

	jsr helper_ask_if_sure
	bcs_16 execute_statements

	jsr JCLALL                         // for extra safety
	jmp (vector_reset)                 // hardware CPU vector