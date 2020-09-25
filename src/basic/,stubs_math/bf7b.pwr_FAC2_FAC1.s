;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - set FAC1 as FAC2 raised to the power of FAC1
;
; Input:
; - .A - must load FAC1 exponent ($61) beforehand to set the zero flag
;
; Note:
; - load FAC2 after FAC1, or mimic the Kernals sign comparison (XXX do we need it?)
; - uses exp(x*log(y)) formula to calculate y^x; slow and inaccurate
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 117
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

; XXX provide implementation

pwr_FAC2_FAC1:

	+STUB_IMPLEMENTATION
