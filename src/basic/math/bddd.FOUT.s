;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - outputs FAC1 to string at $0100
;
; This is verified to be identical to the original Microsoft implementation where it was named FOUT
;
; Output:
; - .A - address low byte
; - .Y - address high byte
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 116
; - https://www.c64-wiki.com/wiki/Floating_point_arithmetic
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


FOUT:
        ldy #1
FOUTC:
        lda #' '        ; Print space if positive.
        bit FAC1_sign
        bpl FOUT1
        lda #$2D
FOUT1:          ; FIXME FBUFFR is $0100 13 bytes fstring buffer
        sta FBUFFR-1,Y  ; STore the character.
        sta FAC1_sign   ; Make FAC1 pos for QINT
        sty FBUFPT      ; Save for later
        iny
        lda #'0'        ; Get zero to type if FAC1=0
        ldx FAC1_exponent
        bne @1
        jmp FOUT19
@1      lda #0
        cpx #$80        ; Is number .LT. 1.0 ?
        beq FOUT37      ; No
        bcs FOUT7
FOUT37:
        lda #<const_NZMIL
        ldy #>const_NZMIL
        jsr mul_MEM_FAC1
        lda #$F7
FOUT7:
        sta DECCNT      ; Save count or zero it
FOUT4:
        lda #<const_NZ9999
        ldy #>const_NZ9999
        jsr FCOMP       ; Is number .GT. 999999.499 ? or 999999999.499?
        beq BIGGES
        bpl FOUT9       ; Yes. Make it smaller
FOUT3:
        lda #<const_NZ0999
        ldy #>const_NZ0999
        jsr FCOMP       ; Is number .GT. 99999.9499 ? or 99999999.9499?
        beq FOUT38
        bpl FOUT5       ; Yes. Done multiplying

FOUT38:
        jsr MUL10       ; Make it bigger
        dec DECCNT
        bne FOUT3       ; See if that does it.
FOUT9:
        jsr div10_FAC1_p        ; Make it smaller
        inc DECCNT
        bne FOUT4               ; See if that does it
FOUT5:
        jsr add_HALF_FAC1       ; Add a half to round up
BIGGES:
        jsr QINT
        ldx #1          ; Decimal point count
        lda DECCNT
        clc
        adc #$0A        ; Should the number be printed in E notation? i.e. is number .LT. .01 ?
        bmi FOUTPI      ; Yes
        cmp #$0B        ; Is it .GT. 999999 (999999999)?
        bcs FOUT6       ; Yes. Use E notation.
        adc #$FF        ; Number of places before decimal point
        tax
        lda #2          ; No E notation

FOUTPI: 
        sec
FOUT6:
        sbc #2          ; Effectively add 5 to orig exp
        sta TENEXP      ; That is the exponent to print
        stx DECCNT      ; Number of decimal places
        txa
        beq FOUT39
        bpl FOUT8       ; Some places before dec pnt
FOUT39:
        ldy FBUFPT      ; Get pointer to output
        lda #'.'        ; Put in "."
        iny
        sta FBUFFR-1,Y
        txa
        beq FOUT16
        lda #'0'        ; Get the ensuing zero
        iny
        sta FBUFFR-1,Y
FOUT16:
        sty FBUFPT      ; Save for later.
FOUT8:
        ldy #0
FOUTIM:
        ldx #$80        ; First pass thru, X has MSB set
FOUT2:
        lda FAC1_mantissa+3
        clc
        adc FOUTBL+3,Y
        sta FAC1_mantissa+3
        lda FAC1_mantissa+2
        adc FOUTBL+2,Y
        sta FAC1_mantissa+2
        lda FAC1_mantissa+1
        adc FOUTBL+1,Y
        sta FAC1_mantissa+1
        lda FAC1_mantissa+0
        adc FOUTBL,Y
        sta FAC1_mantissa+0
        inx             ; It was done yet another time
        bcs FOUT41
        bpl FOUT2
        bmi FOUT40        
FOUT41:
        bmi FOUT2
FOUT40:
        txa
        bcc FOUTYP      ; Can use A as is
        eor #$FF        ; Find 11.-[A]
        adc #10         ; CF C is still on to complete negation. And will always be on after

FOUTYP: 
        adc #'0' - 1    ; Get a character to print
        iny             ; Bum pointer up
        iny
        iny
        iny
        sty FDECPT
        ldy FBUFPT
        iny             ; Point to place to store output
        tax
        and #$7F        ; Get rid of MSB
        sta FBUFFR-1,Y
        dec DECCNT
        bne STXBUF      ; Not time for DP yet
	    lda #'.'        ; "."
        iny
        sta FBUFFR-1,Y  ; Store DP
STXBUF:
        sty FBUFPT      ; Store PNTR for later
        ldy FDECPT
FOUTCM:
        txa             ; Complement X
        eor #$FF        ; Complement A
        and #$80        ; Save only MSB
        tax
        cpy #FDCEND-FOUTBL

        beq FOULDY
        cpy #TIMEND-FOUTBL
        bne FOUT2       ; Continue with output
FOULDY:
        ldy FBUFPT      ; Get back output PNTR
FOUT11:
        lda FBUFFR-1,Y  ; Remove trailing zeroes
        dey
        cmp #'0'
        beq FOUT11
        cmp #'.'
        beq FOUT12      ; Run into DP STOP
        iny             ; Something else. Save it
FOUT12:
        lda #'+'
        ldx TENEXP
        beq FOUT17      ; No exponent to output
        bpl FOUT14
        lda #0
        sec
        sbc TENEXP
        tax
        lda #'-'        ; Exponent is negative
FOUT14:
        sta FBUFFR+1,Y  ; Store sign of exp
        lda #'E'
        sta FBUFFR,Y    ; Store the "E" character
        txa
        ldx #'0' - 1
        sec
FOUT15:
        inx             ; Move closer to output value
        sbc #10
        bcs FOUT15      ; Not negative yet
        adc #'0' + 10   ; Get second output character
        sta FBUFFR+3,Y  ; Store high digit
        txa
        sta FBUFFR+2,Y  ; Store low digit
        lda #0          ; Put in terminator
        sta FBUFFR+4,Y
        beq FOUT20      ; Return (always branches)
FOUT19:
        sta FBUFFR-1,Y  ; Store the character
FOUT17:
        lda #0          ; A terminator
        sta FBUFFR,Y
FOUT20:
        lda #<FBUFFR
        ldy #>FBUFFR
FPWRRT:
         rts            ; All done


