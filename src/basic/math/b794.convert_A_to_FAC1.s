;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - Convert A (uint8) to FAC1
;
; - https://sta.c64.org/cbm64basconv.html
;

convert_u8_A_to_FAC1:
    tay
    jmp convert_Y_to_FAC1
