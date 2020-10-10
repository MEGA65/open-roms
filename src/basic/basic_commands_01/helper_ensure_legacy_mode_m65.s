;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


helper_ensure_legacy_mode:

	jsr M65_MODEGET
	+bcc do_LEGACY_MODE_ONLY_error

	rts
