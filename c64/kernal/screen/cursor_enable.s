// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// Variables used:
// - BLNSW (cursor blink switch)
//


cursor_enable:

	lda #$00
	sta BLNSW
	rts
