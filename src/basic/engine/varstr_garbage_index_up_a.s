// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Helper routine, used by garbage collector
//


varstr_INDEX_up_A:                     // .A - bytes to increase TXTPTR, uses DSCPNT+0

	sta DSCPNT+0 

	clc
	lda INDEX+0
	adc DSCPNT+0 
	sta INDEX+0
	bcc !+
	dec INDEX+1
!:
	rts
