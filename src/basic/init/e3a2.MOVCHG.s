;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


; init - This is the implementation of the CHARGET and CHARGOT functions
;        The basic cold start will copy this into the zero page
;        We will only use this for the 38K memory model for maximum C64 compatibility
;
; Input: Nothing
; Output: Nothing
; Clobbers: A, X
;
; See also:
; https://www.c64-wiki.com/wiki/CHRGET
;

!ifdef CONFIG_MEMORY_MODEL_38K {

MOVCHG:

    inc TXTPTR
    bne @1
    inc TXTPTR+1

@1:

    lda $0000       ; The address in this instruction will be at TXTPTR in the zero page
    beq @2          ; If NULL byte
    cmp #$20        ; Is space?
    beq MOVCHG
    cmp #$30        ; is less than '0'?
    bcc @2
    cmp #$3A        ; '9' + 1 and also ':'
    rts
@2:
    sec
    rts
}
