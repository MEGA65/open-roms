;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


!ifndef HAS_SMALL_BASIC {

cmd_clear:

	; XXX in the future add separate implementation for graphics screen

	jmp clear_screen
}
