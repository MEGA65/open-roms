;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - table of powers of ten
;
; This is verified to be identical to the original Microsoft implementation where it was named FOUTBL


FOUTBL:
    +be32 -100000000
    +be32 10000000
    +be32 -1000000
    +be32 100000
    +be32 -10000
    +be32 1000
    +be32 -100
    +be32 10
    +be32 -1
FDCEND:
