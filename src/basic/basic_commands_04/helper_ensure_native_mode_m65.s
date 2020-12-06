;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


helper_ensure_native_mode:

	jsr M65_MODEGET
	+bcs do_NATIVE_MODE_ONLY_error

	rts
