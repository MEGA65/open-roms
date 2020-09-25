;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Helper table for 'MEM' command - list of minuend zeropage variables
;

!ifndef HAS_SMALL_BASIC {

helper_mem_tab_x:

	!byte FRETOP
	!byte MEMSIZ
	!byte STREND
	!byte ARYTAB
	!byte VARTAB
}
