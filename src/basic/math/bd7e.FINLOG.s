;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - add an ASCII digit in A that has been converted to a signed integer to FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named FINLOG.
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113
;

FINLOG:
        pha
        jsr mov_r_FAC1_FAC2
        pla
        jsr convert_A_to_FAC1
        lda FAC2_sign
        eor FAC1_sign
        sta ARISGN                  ; Resultant sign
        ldx FAC1_exponent           ; Set signs on thing to add
        jmp add_FAC2_FAC1
