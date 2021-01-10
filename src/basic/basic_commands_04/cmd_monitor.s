;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


cmd_monitor:

	jsr helper_ensure_native_mode
	jsr helper_ensure_direct_mode

	jsr MONITOR
	jmp end_of_program
