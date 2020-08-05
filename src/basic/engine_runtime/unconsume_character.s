// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Reverses character fetch
//

#if !HAS_OPCODES_65CE02

unconsume_character:

	lda TXTPTR+0
	sec
	sbc #$01
	sta TXTPTR+0
	lda TXTPTR+1
	sbc #$00
	sta TXTPTR+1

	rts

#endif
