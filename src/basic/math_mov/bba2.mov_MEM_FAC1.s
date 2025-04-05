;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


; Math package - fetch FAC1 from RAM location
;
; Input:
; - .A - address low byte
; - .Y - address high byte
;
; Output:
; - .A - FAC1 exponent, affects status flags
; - .Y - always 0
;
; Preserves:
; - .X - (experimentation with original ROM)
;
; See also:
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics



mov_MEM_FAC1:
	sty INDEX+1
	sta INDEX+0

    ; FALLTHROUGH to get_FAC1_via_INDEX
