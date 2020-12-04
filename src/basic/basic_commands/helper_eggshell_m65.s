;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   *       #IGNORE


helper_eggshell:

!ifdef SEGMENT_M65_BASIC_0 {

	jsr map_BASIC_1
	jsr (VB1__helper_eggshell)
	jmp map_NORMAL

} else {

	; XXX implement till Easter

	rts
}
