// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Not this is not an official Kernal API extension (yet)! It is subject to change!
//
// XXX consider turning this into vector table, the only jumptable extension
// would copy the vector table to given memory location


M65_JMODE64:
	jsr M65_MODE64

M65_JMODE65:
	jsr M65_MODE65

M65_JISMODE65:
	jsr M65_ISMODE65

M65_JSLOW:
	jsr M65_SLOW

M65_JFAST:
	jsr M65_FAST

M65_JSELDEV:
	jsr SELDEV
