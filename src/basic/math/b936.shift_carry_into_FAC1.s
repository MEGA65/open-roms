;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - shift carry into FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named SQUEEZ.
;
; Alternative entry point: RNDSHF to also shift in a CF=0
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 113
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

shift_carry_into_FAC1:

SQUEEZ:
    bcc RNDRTS
RNDSHF:
    inc FAC1_exponent
    beq overflow_error
    ror FAC1_mantissa+0
    ror FAC1_mantissa+1
    ror FAC1_mantissa+2
    ror FAC1_mantissa+3
    ror FACOV
RNDRTS:
    rts
