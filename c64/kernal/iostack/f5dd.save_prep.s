// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// SAVE preparation routine
//

//
// Input (according to http://sta.c64.org/cbm64krnfunc.html)
// .A        - address of zero page register holding start address of memory area to save
// .X and .Y - end address of memory area plus 1
//

//
// Note: Experimenting can easily confirm that SAVE preparation routine does similar
// actions as LOAD preparation routine.
//

SAVE_PREP:

	sty EAL+1
	stx EAL+0

	tax

	lda $01, x
	sta STAL+1
	lda $00, x
	sta STAL+0

    jmp (ISAVE)
