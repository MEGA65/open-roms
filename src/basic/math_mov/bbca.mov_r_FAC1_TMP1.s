;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - store FAC1 (rounds) in TEMPF1
;
; This is verified to be identical to the original Microsoft implementation where it was named MOV1F.
;
; See also:
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - https://sta.c64.org/cbm64basconv.html
;

mov_r_FAC1_TMP1:

    ldx #TEMPF1
    ldy #0

    beq mov_r_FAC1_MEM      ; Always branches
