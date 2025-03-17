;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - add an ASCII digit in A that has been converted to a signed integer to FAC1
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113
;

FINLOG:
    pha
    jsr mov_FAC1_FAC2
    pla
    jsr convert_A_to_FAC1
    jsr add_FAC2_FAC1
    rts
