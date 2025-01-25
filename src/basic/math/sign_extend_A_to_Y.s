;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - helper function to sign extend accumulator into Y

sign_extend_A_to_Y:
    cmp #$80                ; Copy sign into carry
    ldy #$00                ; Y = $00
    bcc @1                  ; Branch if not negative
    dey                     ; Y = $FF
@1: rts
