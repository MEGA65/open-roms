;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Not this is not an official Kernal API extension (yet)! It is subject to change!
;
; XXX consider turning this into vector table, the only jumptable extension
; would copy the vector table to given memory location


M65_JMODEGET:
	jsr M65_MODEGET

M65_JISMODESET:
	jsr M65_MODESET

M65_JSELDEV:
	jsr SELDEV

M65_JCLRSCR:
	jsr M65_CLRSCR

M65_JCLRWIN: ; XXX consider combining with M65_JCLRSCR
	jsr M65_CLRWIN

M65_JSETWIN_XY:
	jsr M65_SETWIN_XY

M65_JSETWIN_WH: ; XXX combine this with M65_JSETWIN_N, M65_JSETWIN_Y, and possibly M65_JSETWIN_XY
	jsr M65_SETWIN_WH

M65_JSETWIN_N:
	jsr M65_SETWIN_N

M65_JSETWIN_Y:
	jsr M65_SETWIN_Y

; XXX add M65_HOME
