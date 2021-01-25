
; Based on BSM (Bit Shifter's Monitor)


Load_Save:

   stx  VERCKK               ; store command

	; Retrieve file name

@skip1:

	jsr  Get_Char
	+beq Mon_Error
	cmp  #' '
	beq  @skip1
	cmp  #KEY_QUOTE
	+bne Mon_Error

	lda  #$FF
	sta  FNLEN
	lda  Buf_Index
	sta  FNADDR+0
	lda  #>BUF
	sta  FNADDR+1

@skip2:
	inc  FNLEN
	jsr  Get_Char
	+beq Mon_Error
	cmp  #KEY_QUOTE
	bne  @skip2

	; Separate flow for SAVE

	lda  VERCKK
	cmp  #21                 ; 'S'
	beq  Mon_Save
   sec
   sbc  #20                 ; 'L'
   sta  VERCKK              ; 0 for load, other value for verify

	; FALLTROUGH

Mon_Load_Verify:

	; Determine unit

	jsr  SELDEV              ; set default unit
	stx  FA

	jsr  Get_DecVal_To_LAC
   +bcs Mon_Error
	beq  @got_unit
	jsr  Syntax_Byte_AC
	lda  Long_AC+0
	sta  FA

@got_unit:

	; Determine start address

   lda  #$00
   sta  Addr_Mode
   jsr  Get_Val_To_LAC
   beq  @no_startaddr
   lda  Addr_Mode
   +bne Mon_Error 

   ; Load/Verify with fixed start address

   ldx  Long_AC+0
   ldy  Long_AC+1

   lda #$00
   +skip_2_bytes_trash_nvz

@no_startaddr:

   ; Load/Verify without fixed start address

   lda  #$01

@load:

   sta  SA

   jsr  Print_CR
   lda  VERCKK
   jsr  LOAD
   bra  Mon_Load_Save_Common

Mon_Save:

	; Determine unit

	jsr  Get_DecVal_To_LAC
   +bcs Mon_Error
	+beq Mon_Error
	jsr  Syntax_Byte_AC
	lda  Long_AC+0
	sta  FA

   ; Determine start address

   lda  #$00
   sta  Addr_Mode
   jsr  Get_Val_To_LAC
   +bne Mon_Error
   lda  Addr_Mode
   +bne Mon_Error 

   lda Long_AC+1
   pha
   lda Long_AC+0
   pha

   ; Determine end address

   jsr  Get_Val_To_LAC
   +bne Mon_Error
   lda  Addr_Mode
   +bne Mon_Error 

   inw  Long_AC+0
   ldx  Long_AC+0
   ldy  Long_AC+1

   pla                       ; set start address for SAVE            
   sta  TXTTAB+0
   pla
   sta  TXTTAB+1

   jsr  Print_CR
   lda  #TXTTAB
   jsr  SAVE

   ; FALLTROUGH

Mon_Load_Save_Common:

   bcc  @end
   pha
   jsr  Print_CR
   pla
   jsr  print_kernal_error
   jsr  Print_CR

@end:

	jmp Main
