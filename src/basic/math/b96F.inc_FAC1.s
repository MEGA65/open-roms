;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - increment FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named INCFAC.
;
; See also:
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - https://sta.c64.org/cbm64basconv.html
;

inc_FAC1:

    inc FAC1_mantissa+3
    bne inc_FAC1_ret
    inc FAC1_mantissa+2
    bne inc_FAC1_ret
    inc FAC1_mantissa+1
    bne inc_FAC1_ret
    inc FAC1_mantissa+0

inc_FAC1_ret:

    rts
