;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - square root of FAC2
;
; This is verified to be identical to the original Microsoft implementation where it was unnamed
;
; Note:
; - loads .5 into FAC1 and falling through to the exponentiation routine
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 117
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


sqr_FAC2:

        lda #<const_HALF
        ldy #>const_HALF

        ; FALLLTROUGH to pwr_FAC2_MEM


} else {
    jmp do_NOT_IMPLEMENTED_error
}
