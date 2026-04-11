;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - the floating point constant 1.0
;
; This is verified to be identical to the original Microsoft implementation where is part of the EXPCON polynomial
;
; - https://www.c64-wiki.com/wiki/BASIC-ROM
;

	+PUT_CONST_ONE                     ; duplicated constant - no label
