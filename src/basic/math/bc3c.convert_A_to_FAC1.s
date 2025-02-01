;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - convert int8 in A to FAC1
;
; Input: A - int8 to convert to float
; Result: FAC1
;
; Sets first byte of FAC1 to A, sign extends A into tge second byte and falls through to convert_i16_to_FAC1
;
; - https://codebase64.org/doku.php?id=base:asm_include_file_for_basic_routines
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


convert_A_to_FAC1:
    sta FAC1_mantissa
    jsr sign_extend_A_to_Y
    sty FAC1_mantissa+1
    +nop                    ; To not leave a gap to the fallthrough
    ; Fall through to convert_i16_to_FAC1
