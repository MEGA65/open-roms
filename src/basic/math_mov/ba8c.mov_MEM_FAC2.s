;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE
;
; Math package - fetch FAC2 from memory location
;
; Input:
; - .A - address low byte
; - .Y - address high byte
;
; Output:
; - .A - FAC1 exponent (yes, really - Codebase64 is right)
; - .Y - 0 (experimentation with original ROM)
;
; Preserves:
; - .X - (experimentation with original ROM)
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 114
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


mov_MEM_FAC2:
	sty INDEX+1
	sta INDEX+0

    ; FALLTHROUGH to get_FAC2_via_INDEX
