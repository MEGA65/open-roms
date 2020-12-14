;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


helper_ensure_direct_mode:

	ldx CURLIN+1
	inx
	+bne do_DIRECT_MODE_ONLY_error

	rts
