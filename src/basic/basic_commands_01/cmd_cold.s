;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifndef HAS_SMALL_BASIC {

cmd_cold:

	jsr helper_ask_if_sure
	bcs @1

	jsr JCLALL                         ; for extra safety
	jmp (vector_reset)                 ; hardware CPU vector
@1:
	rts
}
