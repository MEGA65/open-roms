;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - clear FAC1
;
; Set each byte of the mantissa of FAC1 to the value of A
;
; This is verified to be identical to the original Microsoft implementation where it was named CLRFAC.
;
; See also:
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - https://sta.c64.org/cbm64basconv.html
;


clear_FAC1:
    sta FAC1_mantissa+0
    sta FAC1_mantissa+1
    sta FAC1_mantissa+2
    sta FAC1_mantissa+3
    tay
clear_FAC1_rts:             ; Return point needed elsewhere
    rts
