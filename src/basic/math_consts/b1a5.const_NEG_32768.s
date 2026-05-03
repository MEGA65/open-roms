;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - The floating point constant -32768
;
; This is verified to be identical to the original Microsoft implementation where it was named N32768.
;
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - Computes Mapping the Commodore 64, page 105
;

CONST_NEG_32768:

	+PUT_CONST_NEG_32768
