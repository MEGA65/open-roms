;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - Mov MEM to FAC2 with address in INDEX zero page register
;
; This is verified to be identical to the original Microsoft implementation where it was named CONUPK (partial).
;
; See also:
; - https://sourceforge.net/p/acme-crossass/code-0/38/tree/trunk/ACME_Lib/cbm/c64/float.a?force=True
;

; XXX implement, test

get_FAC2_via_INDEX:

    ldy #4
    lda (INDEX),Y
    sta FAC2_mantissa+3
    dey
    lda (INDEX),Y
    sta FAC2_mantissa+2
    dey
    lda (INDEX),Y
    sta FAC2_mantissa+1
    dey
    lda (INDEX),Y
    sta FAC2_sign
    eor FAC1_sign           ; Set sign for multiplication/division
    sta ARISGN
    lda FAC2_sign
    ora #$80                ; Set mantissa high bit
    sta FAC2_mantissa+0
    dey
    lda (INDEX),Y
    sta FAC2_exponent
    lda FAC1_exponent       ; Set flags from FAC1_exponent
    rts
