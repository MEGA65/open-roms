;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - neg (2s complement) FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named NEGFAC.
;
; The alternative entry point inv_FAC1_mantissa (NEGFCH) will negate only the mantissa
;
; See also:
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - https://sta.c64.org/cbm64basconv.html
;

inv_FAC1:
	lda FAC1_sign
	eor #$FF
	sta FAC1_sign

inv_FAC1_mantissa:

    lda FAC1_mantissa+0
    eor #$FF
    sta FAC1_mantissa+0
    lda FAC1_mantissa+1
    eor #$FF
    sta FAC1_mantissa+1
    lda FAC1_mantissa+2
    eor #$FF
    sta FAC1_mantissa+2
    lda FAC1_mantissa+3
    eor #$FF
    sta FAC1_mantissa+3
    lda FACOV
    eor #$FF
    sta FACOV
    bne inc_FAC1_ret
    
    ; Fallthrough to inc_FAC1
