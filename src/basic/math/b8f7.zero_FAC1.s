;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - zero FAC1 exponent and sign
;
; This is verified to be identical to the original Microsoft implementation where it was named ZEROFC.
;
; Alternative entry points ZEROF1 if A alread is 0 and ZEROML to store A to sign only.
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


zero_FAC1:
    lda #0
ZEROF1:
    sta FAC1_exponent
ZEROML:
    sta FAC1_sign
    rts
