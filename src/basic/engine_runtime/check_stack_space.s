;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


check_stack_space:

	+phx_trash_a

	tsx
	cpx #$60                           ; XXX is this a safe threshold?
	+bcc do_FORMULA_TOO_COMPLEX_error

	+plx_trash_a

	rts
