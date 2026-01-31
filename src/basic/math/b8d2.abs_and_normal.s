;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - abs and noramlize FAC1
;
; Input:
; CF - Sign of number
;
; This is verified to be identical to the original Microsoft implementation where it was named FADFLT.
;

abs_and_normal_FAC1:

    bcs normal_FAC1             ; If CF set only normalize
    jsr inv_FAC1
    
    ; Fallthrough to normal_FAC1
