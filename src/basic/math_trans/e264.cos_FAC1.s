;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - cosine of FAC1 in radians
;
; This is verified to be identical to the original Microsoft implementation where it was named COS
;
; Adds pi/2 to FAC1 and falls through to the sine function
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 210
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


COS:

    lda #<const_HALF_PI
    ldy #>const_HALF_PI
    jsr add_MEM_FAC1
 
    ; FALLTHROUGH to SIN


} else {
    jmp do_NOT_IMPLEMENTED_error
}
