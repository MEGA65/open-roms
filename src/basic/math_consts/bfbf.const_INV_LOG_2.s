;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - log2(e) = 1 / log(2)
;
; This is verified to be identical to the original Microsoft implementation where it was named LOGEB2
;
; See also:
; - https://www.c64-wiki.com/wiki/BASIC-ROM
;

const_INV_LOG_2:

	+PUT_CONST_INV_LOG_2
