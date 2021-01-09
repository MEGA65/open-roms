
; Based on BSM (Bit Shifter's Monitor)

Mon_Memory:

   jsr  Set_MODE_80
   lda  #$00
   sta  Adr_Mode             ; by default use C64-style addressing

   jsr  Get_Addr_To_LAC      ; get 1st parameter (start address)
   +beq Mon_Error
   jsr  LAC_To_LPC           ; Long_PC = start address

   jsr  Get_Addr_To_LAC      ; get 2nd parameter (end address)
   bne  @calcdiff

   lda  #$10                 ; by default display 16 rows
   sta  Long_CT+0
   lda  #$00
   sta  Long_CT+1
   sta  Long_CT+2
   sta  Long_CT+3

   bra  @loop

@calcdiff:
   jsr  LAC_Minus_LPC        ; Long_CT = range
   +bcc Mon_Error            ; error if negative range

   ldx  #$04                 ; for 80 character mode - 16 (2^4) bytes/line
   bbr7 MODE_80,@shift
   dex                       ; for 40 character mode - 8  (2^3) bytes/line

@shift:
   clc
   ror  Long_CT+3
   ror  Long_CT+2
   ror  Long_CT+1
   ror  Long_CT+0

   dex
   bne  @shift               ; at the ned of loop Long_CT contains number of rows to show minus 1

@loop:

   jsr  Dump_Row
   jsr  STOP
   beq  @exit                ; end if STOP pressed

   sec                       ; XXX consider moving this to separate subroutine
   lda  Long_CT+0
   sbc  #$01
   sta  Long_CT+0
   lda  Long_CT+1
   sbc  #$00
   sta  Long_CT+1
   lda  Long_CT+2
   sbc  #$00
   sta  Long_CT+2
   lda  Long_CT+3
   sbc  #$00
   sta  Long_CT+3
   bcs  @loop

@exit:

   jmp  Main
