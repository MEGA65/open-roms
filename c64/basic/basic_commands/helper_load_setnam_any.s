// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Set '*' as file name
//


helper_load_setnam_any:

	lda #$01                           // name length
	ldx #<filename_any
	ldy #>filename_any
	jmp JSETNAM
