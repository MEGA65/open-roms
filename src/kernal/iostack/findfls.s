;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; Just a helper routine

; Find the LAT / SAT / FAT entry index where LAT corresponds to A, returns index in Y
; Carry flag set means not found

find_fls:

	ldy LDTND
@1:
	dey
	bmi find_fls_not_found ; no more entries
	cmp LAT, y
	bne @1 ; does not match, try the next one

	clc
	rts

find_fls_not_found:

	sec
	rts
