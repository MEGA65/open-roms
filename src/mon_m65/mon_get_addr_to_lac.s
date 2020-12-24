

Get_Addr_To_LAC: ; XXX !!! seems to work correctly for hex only

   phx
   phy
   phz
   lda  #$00
   sta  Dig_Cnt              ; count columns read
   sta  Long_AC+0            ; clear result Long_AC
   sta  Long_AC+1
   sta  Long_AC+2
   sta  Long_AC+3

   jsr  Get_Glyph            ; get 1st. character
   beq  @exit

   ldy #$03                  ; here we allow '$', '+', '&', and '%' prefixes

@loop_prefix:

   cmp  Cons_Prefix,Y        ; Y = base index

   beq  @valid_prefix        ; -> valid prefix
   dey
   bpl  @loop_prefix
   iny                       ; Y = 0

@valid_prefix:

   ; at this point .Y value determines a numeric system

   jsr  Get_Char
   beq  @exit                ; '?', ':'', ';' and zero terminate
   cmp  #'0'
   bcc  @exit
   cmp  #':'
   bcc  @valid_digit         ; 0-9
   cmp  #'A'
   bcc  @exit
   cmp  #'G'
   bcs  @exit
   sbc  #$07                 ; hex conversion

@valid_digit:   

   sbc  #'0'-1
   cmp  Num_Base,Y
   +bcs Mon_Error            ; branch if digit above numerical system limit
   pha                       ; push digit to the stack
   inc  Dig_Cnt

   cpy  #$01
   bne  @laba                ; branch if not decimal

   ldx  #$03                 ; decimal - push Long_AC * 2
   clc

@push2x:

   lda  Long_AC,X
   rol
   pha
   dex
   bpl  @push2x

@laba:

   ldx  Num_Bits,Y           ; multiply Long_AC by power of 2 (depending on numeric system) 

@shift:
   
   asl  Long_AC+0
   rol  Long_AC+1
   row  Long_AC+2
   +bcs Mon_Error            ; overflow
   dex
   bne  @shift

   cpy  #$01                 ; decimal adjustment
   bne  @add_digit           ; branch if not a decimal number
   ldx  #$00
   ldz  #$03
   clc

@pull_and_add:

   pla
   adc  Long_AC,X
   sta  Long_AC,X
   inx
   dez
   bpl  @pull_and_add

@add_digit:

   pla                       ; pull digit
   clc
   adc  Long_AC+0
   sta  Long_AC+0
   bcc  @valid_prefix
   inc  Long_AC+1
   bne  @valid_prefix
   inw  Long_AC+2
   bne  @valid_prefix

   jmp  Mon_Error            ; number foo large

@exit:

   lda  Long_AC+3
   and  #%11110000
   +bne Mon_Error            ; MEGA65 has a 28-bit address bu

   lda  Dig_Cnt              ; check if we should enable long addressing mode
   cmp  Num_Limit,Y
   bcc  @check_done

   cpy  #$1
   bne  @set_long_mode

   lda  Long_AC+2            ; for decimal system check most significant bytes instead
   ora  Long_AC+3
   beq  @check_done

@set_long_mode:

   lda  #$80                 ; set addressing mode to long
   sta  Adr_Mode

@check_done:

   lda  Dig_Cnt

   plz
   ply
   plx

   cmp  #$00                 ; allow to easily check if a parameter was given
   rts
