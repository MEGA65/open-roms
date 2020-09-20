;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - compare FAC1 with RAM location
;
; Input:
; - .A - address low byte
; - .Y - address high byte
;
; Output:
; - .A - $00 for equal, $01 for FAC1 > RAM, $FF for FAC1 < RAM
; - flags N/Z, depending on whether FAC1 is 0, positive, or negative
;
; Notes:
; - uses vector at $24, leaves FAC1 and FAC2 unchanged (Codebase64)
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

; XXX provide implementation

FCOMP:

	+STUB_IMPLEMENTATION
