;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - absolute value of FAC1
;
; This is verified to be identical to the original Microsoft implementation where it was named ABS.
;

abs_FAC1:

    lsr FAC1_sign
    rts
