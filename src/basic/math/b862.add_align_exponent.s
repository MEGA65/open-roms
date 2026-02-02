;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - align FAC1 and FAC2 exponents for addition
;
; This is verified to be identical to the original Microsoft implementation where it was named FADD5.
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/BASIC-ROM

add_align_exponents:
    jsr shiftr_FAC
    bcc FADD4
    
    ; Fallthrough to add_MEM_FAC1
