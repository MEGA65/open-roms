;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - cosine of FAC1 in radians
;
; Adds pi/2 to FAC1 and falls through to the sine function
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 210
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

COS:
    ldy #>const_HALF_PI
    lda #<const_HALF_PI
    jsr add_MEM_FAC1
    
    ; FALLTHROUGH to SIN
