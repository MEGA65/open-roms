;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Print one of the standard Kernal messages, index in .X
;

print_kernal_message_loop:

	jsr JCHROUT
	inx

print_kernal_message:

	lda __msg_kernal_first, x
	bpl print_kernal_message_loop ; 0 marks end of string
	and #$7F
	jmp JCHROUT
