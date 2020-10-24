;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   *       #IGNORE



!ifdef HAS_NOLGPL3_WARN {

str_nonlgpl3_warn:

	!byte $0D, $0D, $0D, $0D
	!pet "build contains non-lgpl3 code"
	!byte $0D
	!pet "  *** do not distribute ***"
	!byte $0D, $0D, $00
}
