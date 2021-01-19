
; Based on BSM (Bit Shifter's Monitor)


Load_Save:

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
	cmp  #$02
	beq  Mon_Save

	; FALLTROUGH

Mon_Load_Verify:

	; Determine unit

	jsr  SELDEV              ; set default unit
	stx  FA

	jsr  Get_Val_To_LAC
	beq  @got_unit
	jsr  Syntax_Byte_AC
	lda  Long_AC+0
	sta  FA

@got_unit:

	; XXX to be finished

	jmp Main


Mon_Save:

	; Determine unit

	jsr  Get_Val_To_LAC
	+beq Mon_Error
	jsr  Syntax_Byte_AC



	; XXX to be finished

	jmp Main




         ; LDY  #8
         ; STY  SA
         ; LDY  #0
         ; STY  BA
         ; STY  FNLEN
         ; STY  FNBANK
         ; STY  IOSTATUS
         ; LDA  #>Mon_Data
         ; STA  FNADR+1
         ; LDA  #<Mon_Data
         ; STA  FNADR
; @skip    JSR  Get_Char          ; skip blanks
         ; LBEQ Mon_Error
         ; CMP  #' '
         ; BEQ  @skip
         ; CMP  #KEY_QUOTE        ; must be quote
         ; LBNE Mon_Error

         ; LDX  Buf_Index
; @copyfn  LDA  BUF,X             ; copy filename
         ; BEQ  @do               ; no more input
         ; INX
         ; CMP  #KEY_QUOTE
         ; BEQ  @unit             ; end of filename
         ; STA  (FNADR),Y         ; store to filename
         ; INC  FNLEN
         ; INY
         ; CPY  #19               ; max = 16 plus prefix "@0:"
         ; BCC  @copyfn
         ; JMP  Mon_Error         ; filename too long

; @unit    STX  Buf_Index         ; update read position
         ; JSR  Get_Char
         ; BEQ  @do               ; no more parameter
         ; JSR  Get_LAC
         ; BCS  @do
         ; LDA  Long_AC           ; unit #
         ; STA  FA
         ; JSR  Get_LAC
         ; BCS  @do
         ; JSR  LAC_To_LPC        ; Long_PC = start address
         ; STA  BA                ; Bank
         ; JSR  Get_LAC           ; Long_AC = end address + 1
         ; BCS  @load             ; no end address -> load/verify
         ; JSR  Print_CR
         ; LDX  Long_AC           ; X/Y = end address
         ; LDY  Long_AC+1
         ; LDA  VERCKK            ; A = load/verify/save
         ; CMP  #'S'
         ; LBNE Mon_Error         ; must be Save
         ; LDA  #0
         ; STA  SA                ; set SA for PRG
         ; LDA  #Long_PC          ; Long_PC = start address
         ; JSR  SAVE
; @exit    JMP  Main

; @do      LDA  VERCKK
         ; CMP  #'V'              ; Verify
         ; BEQ  @exec
         ; CMP  #'L'              ; Load
         ; LBNE Mon_Error
         ; LDA  #0                ; 0 = LOAD
; @exec    JSR  LOAD              ; A == 0 : LOAD else VERIFY
         ; BBR4 IOSTATUS,@exit
         ; LDA  VERCKK
         ; LBEQ Mon_Error
         ; LBCS Main
         ; JSR  PRIMM
         ; !pet " error",0
         ; JMP  Main

; @load    LDX  Long_PC
         ; LDY  Long_PC+1
         ; LDA  #0                ; 0 = use X/Y as load address
         ; STA  SA                ; and ignore load address from file
         ; BRA  @do
