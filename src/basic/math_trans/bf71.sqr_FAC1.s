;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - square root of FAC1
;
; Note:
; - transfers FAC1 to FAC2 and falls through to SQR2
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 117
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

!ifdef CONFIG_TRANSCENDENTAL_FUNCTIONS {


sqr_FAC1:

	jsr mov_FAC1_FAC2
	
	; FALLLTROUGH to sqr_FAC2


} else {
    jmp do_NOT_IMPLEMENTED_error
}
