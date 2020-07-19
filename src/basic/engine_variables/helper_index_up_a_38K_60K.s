// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine, used by garbage collector and string concatenation
//

#if CONFIG_MEMORY_MODEL_38K || CONFIG_MEMORY_MODEL_60K

helper_INDEX_up_A:                     // .A - bytes to increase INDEX, uses DSCPNT+0

	sta DSCPNT+0 

	clc
	lda INDEX+0
	adc DSCPNT+0 
	sta INDEX+0
	bcc !+
	dec INDEX+1
!:
	rts

#endif
