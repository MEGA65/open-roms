;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - evaluate polynomial with odd powers only for FAC1 value
;
; Input:
; - .A - table address low byte
; - .Y - table address low byte
; - table format:
;   - polynomial degree (8 bit integer)
;   - oefficients (floats), starting from highest degree, times 1+degree
;
; Notes:
; - calls POLY2(table, X*X)*X
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 206
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://www.c64-wiki.com/wiki/POLY1
;

; XXX provide implementation

poly1_FAC1:

	+STUB_IMPLEMENTATION
