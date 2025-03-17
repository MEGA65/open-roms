;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - converts string to FAC1
;
; Input:
; - .A needs to be loaded with string length
; - string address in $22/$23
;
; See also:
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://www.c64-wiki.com/wiki/STRVAL
;

!ifdef CONFIG_MEMORY_MODEL_38K {
; Only supported model for now since needs CHRGOT and FIN

STRVAL:

    ldx TXTPTR          ; Save TXTPTR
    stx FBUFPT
    ldx TXTPTR+1
    stx FBUFPT+1

    ldx INDEX           ; Move string address into TXTPTR
    stx TXTPTR
    ldx INDEX+1
    stx TXTPTR+1
 
    pha                 ; Save string length
    tay
    lda (INDEX),Y
    sta TEMPF1          ; Save byte after string
    lda #0
    sta (INDEX),Y       ; NULL terminate string

    jsr CHRGOT
    jsr FIN
 
    pla                 ; Retrieve string length
    tay
    lda TEMPF1
    sta (INDEX),Y       ; Restore byte after string
 
    ldx FBUFPT          ; Restore TXTPTR
    stx TXTPTR
    ldx FBUFPT+1
    stx TXTPTR+1
    rts
}
