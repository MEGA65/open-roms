;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - The floating point constant PI
;
; This is verified to be identical to the original Microsoft implementation where it was named PIVAL.
;
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - Computes Mapping the Commodore 64, page 103
;

const_PI:

; The original BASIC didn't have the most accurate PI.

!ifdef CONFIG_ORIGINAL_UNPATCHED_BASIC {
    +PUT_CONST_PI_MS
} else {
	+PUT_CONST_PI
}
