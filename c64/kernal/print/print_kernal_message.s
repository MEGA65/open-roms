#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Print one of the standard Kernal messages, index in .X
//

!:
	jsr JCHROUT
	inx

print_kernal_message:

	lda __msg_kernal_first, x
	bpl !- // 0 marks end of string
	and #$7F
	jmp JCHROUT


#endif // ROM layout
