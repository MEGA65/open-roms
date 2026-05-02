;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - imports string to FAC1, ignores spaces
;
; This is verified to be identical to the original Microsoft implementation where it was named FIN.
;
; Input:
; - .A needs to be loaded with first char of the string
; - Carry flag must be clear
; - string address in $7A/$7B
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 116
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;

; NUMBER INPUT IS LEFT IN FAC.
; AT ENTRY [TXTPTR] POINTS TO THE FIRST CHARACTER IN A TEXT BUFFER.
; THE FIRST CHARACTER IS ALSO IN ACCA. FIN PACKS THE DIGITS
; INTO THE FAC AS AN INTEGER AND KEEPS TRACK OF WHERE THE
; DECIMAL POINT IS. [DPTFLG] TELL WHETHER A DP HAS BEEN
; SEEN. [DECCNT] IS THE NUMBER OF DIGITS AFTER THE DP.
; AT THE END [DECCNT] AND THE EXPONENT ARE USED TO
; DETERMINE HOW MANY TIMES TO MULTIPLY OR DIVIDE BY TEN
; TO GET THE CORRECT NUMBER.


!ifdef CONFIG_MEMORY_MODEL_38K {

FIN:
        ldy #0          ; Zero FAC1_sign and SGNFLG
        ldx #10         ; Zero exp and hi bytes
FINZLP:
        sty DECCNT,X    ; Zero low bytes
        dex             ; Zero TENEXP and EXPSGN
        bpl FINZLP      ; Zero DECCNT, DPTFLG
        bcc FINDGQ      ; Flags still set from CHRGET
        cmp #'-'        ; A negative sign?
        bne QPLUS       ; No, try plus sign
        stx SGNFLG      ; It's negative
        beq FINC        ; Always branches
QPLUS:
        cmp #'+'        ; Plus sign?
        bne FIN1        ; Yes, skip it
FINC:
        jsr CHRGET
FINDGQ:
        bcc FINDIG
FIN1:
        cmp #'.'        ; The decimal point?
        beq FINDP       ; No kidding
        cmp #'E'        ; Exponent follows
        bne FINE        ; No
	    ;HERE TO CHECK FOR SIGN OF EXP.
        jsr CHRGET      ; Yes, Get another
        bcc FNEDG1      ; It is a digit. (Easier than backing up pointer)
        cmp #$AB        ; Minus with sign set (from table)
        beq FINEC1      ; Negate
        cmp #'-'        ; Minus sign?
        beq FINEC1
        cmp #$AA        ; Plus with sign set (from table)
        beq FINEC
        cmp #'+'        ; Plus sign?
        beq FINEC
        bne FINEC2
FINEC1:
        ror EXPSGN      ; Turn it on
FINEC:
        jsr CHRGET      ; Get another
FNEDG1:
        bcc FINEDG      ; It is a digit
FINEC2:
        bit EXPSGN
        bpl FINE
        lda #0
        sec
        sbc TENEXP
        jmp FINE1
FINDP:
        ror DPTFLG
        bit DPTFLG
        bvc FINC
FINE:
        lda TENEXP
FINE1:
        sec
        sbc DECCNT      ; Get number of places to shift
        sta TENEXP
        beq FINQNG      ; Negate?
        bpl FINMUL      ; Positive so multiply
FINDIV:
        jsr div10_FAC1_p
        inc TENEXP      ; Done?
        bne FINDIV      ; No
        beq FINQNG      ; Yes
FINMUL:
        jsr mul10_FAC1
        dec TENEXP      ; Done
        bne FINMUL      ; No
FINQNG:
        lda SGNFLG
        bmi NEGXQS      ; If positive, Return
        rts
NEGXQS:
        jmp toggle_sign_FAC1    ; Otherwise, negate and return

FINDIG:
        pha
        bit DPTFLG
        bpl FINDG1
        inc DECCNT
FINDG1:
        jsr mul10_FAC1
        pla             ; Get it back
        sec
        sbc #'0'
        jsr FINLOG      ; Add it in
        jmp FINC


} else {
    +STUB_IMPLEMENTATION
}
