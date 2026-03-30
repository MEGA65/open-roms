;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE



; This file is under the MIT license, it contains code released by Microsoft Corporation.
; See LICENSE for more information.

; Math package - rounds FAC1 before copying
;
; This is verified to be identical to the original Microsoft implementation where it was named ROUND.
;
; Alternative entry point: INCRND to increment mantissa and normalize if carry
;
; See also:
; - [CM64] Computes Mapping the Commodore 64 - page 115
; - https://codebase64.org/doku.php?id=base:kernal_floating_point_mathematics
;


round_FAC1:

    lda FAC1_exponent   ; Zero?
    beq MOVRTS          ; Yes. Done rounding
    asl FACOV           ; ROUND?
    bcc MOVRTS          ; No. MSB off.
INCRND:
    jsr inc_FAC1        ; Yes, add one to LSB
    bne MOVRTS          ; No carry means done
    jmp RNDSHF          ; Squeeze MSB in and RTS
                        ; CF=1 since inc_FAC1 doesn't touch CF
