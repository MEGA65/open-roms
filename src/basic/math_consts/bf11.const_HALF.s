;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - the constant 1/2
;
; This is verified to be identical to the original Microsoft implementation where it was named FHALF
;
; - https://www.c64-wiki.com/wiki/BASIC-ROM
; - Computes Mapping the Commodore 64, page 116
;

const_HALF:

	+PUT_CONST_HALF
