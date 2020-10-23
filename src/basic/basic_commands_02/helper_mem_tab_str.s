;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_1 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Helper table for 'MEM' command - list of strings to print
;

!ifndef HAS_SMALL_BASIC {

helper_mem_tab_str:

	!byte IDX__STR_MEM_FREE
	!byte IDX__STR_MEM_STRS
	!byte IDX__STR_MEM_ARRS
	!byte IDX__STR_MEM_VARS
	!byte IDX__STR_MEM_TEXT
}
