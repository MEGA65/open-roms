
//
// Print one of the standard Kernal messages, index in .X
//

!:
	jsr JCHROUT
	inx

print_kernal_message:

	lda __kernal_messages_start, x
	bne !- // 0 marks end of string
	rts
