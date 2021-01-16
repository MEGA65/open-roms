; *******************************
; * BSM = Bit Shifter's Monitor *
; * for The MEGA65  10-Dec_2020 *
; * (adaped for the Open ROMs)  *
; *******************************


; *******
Mon_Call:
; *******

   jsr PRIMM
   !pet $0D, "* warning * port not finished yet", $0D, $0D, $00


         JSR  Print_Commands

;        set default addressing mode to 64K

         LDA  #0
         STA  Addr_Mode 

;        clear register for monitor call

         LDX  #6
@loop    STA  AC,X
         DEX
         BPL  @loop


;        set default PC to monitor exit point

         LDA  #<monitor_exit
         LDX  #>monitor_exit
         STA  PCL
         STA  X_Vector
         STX  PCH
         STX  X_Vector+1

; ********
Mon_Start:
; ********

         CLD
         TSY
         STY  SPH
         TSX
         STX  SPL
         STX  SP_Storage
         LDA  #$c0
         JSR  SETMSG
         CLI
         +NOP

; ***********
Mon_Register:
; ***********

         JSR  Reg_Text

; print PCH

         LDA  PCH
         JSR  Print_Hex

; print PCL,SR,PCL,A,X,Y,Z,BP

         LDY  #0
@loopb   LDA  PCL,Y
         JSR  Print_Hex_Blank
         INY
         CPY  #7
         BCC  @loopb

; print 16 bit stack pointer

         LDA  SPH
         JSR  Print_Hex
         LDA  SPL
         JSR  Print_Hex_Blank

; print flags

         LDY  #8
         LDA  SR
@loopc   ASL
         PHA
         LDA  #'-'
         BCC  @flag
         LDA  #'1'
@flag    JSR  CHROUT
         PLA
         DEY
         BNE  @loopc

; ***
Main:
; ***

         JSR  Print_CR
         LDX  #0

; read one line into buffer

; *****
Main_A:
; *****

@loop    JSR  CHRIN
         STA  BUF,X
         INX
         CPX  #80
         BCS  Mon_Error         ; input too long
         CMP  #KEY_RETURN
         BNE  @loop

         LDA  #0
         STA  Buf_Index
         STA  BUF-1,X        ; terminate buffer
@getcomm JSR  Get_Char
         BEQ  Main
         CMP  #' '
         BEQ  @getcomm

; *********
Mon_Switch:
; *********

         LDX  #24
@loop    CMP  Command_Char,X
         BEQ  Mon_Select
         DEX
         BPL  @loop

;        fall through to error routine if not found

; ********
Mon_Error:
; ********

; put a question mark at the end of the text

         JSR  PRIMM
         !pet KEY_ESC, 'o', KEY_CRSR_RIGHT, '?', 0
         LDX  SP_Storage        ; reset stack pointer
         TXS
         BRA  Main

; *********
Mon_Select:
; *********

         STA  VERCKK
         CPX  #22
         LBCS Load_Save
         TXA
         ASL
         TAX
         JMP  (Jump_Table,X)

; *************
Print_Commands:
; *************

         JSR  PRIMM
         !pet KEY_RETURN," ",KEY_RVS_ON," commands: "

; ***********
Command_Char:
; ***********

         ;     0123456789abcdef
         !pet "abcdfghjmrtx@.>;?"

; **********
Cons_Prefix:
; **********

         !pet "$+&%"

; ***************
Load_Save_Verify:
; ***************

         !pet "lsv ",KEY_RETURN,0
         RTS

; *********
Jump_Table:
; *********

         !word Mon_Assemble     ; A  XXX to be debugged/adapted
         !word Mon_Bits         ; B
         !word Mon_Compare      ; C
         !word Mon_Disassemble  ; D
         !word Mon_Fill         ; F
         !word Mon_Go           ; G  XXX to be debugged/adapted
         !word Mon_Hunt         ; H  XXX to be bugfixed
         !word Mon_JSR          ; J  XXX to be debugged/adapted
         !word Mon_Memory       ; M
         !word Mon_Register     ; R
         !word Mon_Transfer     ; T
         !word Mon_Exit         ; X
         !word Mon_DOS          ; @
         !word Mon_Assemble     ; .  XXX to be debugged/adapted
         !word Mon_Set_Memory   ; >  XXX to be debugged/adapted
         !word Mon_Set_Register ; ;  XXX to be debugged/adapted
         !word Mon_Help         ; ?
         !word Converter        ; $
         !word Converter        ; +
         !word Converter        ; &
         !word Converter        ; %

; *******
Mon_Exit:
; *******

         JMP  (X_Vector)

; ********
LAC_To_PC: ; XXX to be adapted
; ********

   inc $D020 ; XXX for debug only

; called from Mon_Set_Register, Mon_Go and Mon_JSR
; as the first instruction. The carry flag was set from
; the routine Got_LAC if an error occured.
; Notice that the Bank, PCH and PCL values are stored
; high to low, reverse to the standard order.

; Bank, PCH and PCL are part of a list, that is used by
; the routines FAR_JMP and FAR_JSR of the operating system

         BCS  @error
         ;LDA  Long_AC
         ;STA  Bank+2
         ;LDA  Long_AC+1
         ;STA  Bank+1
         ;LDA  Long_AC+2
         ;STA  Bank
@error   RTS

; *********
LAC_To_LPC:
; *********

   phx
   ldx  #$03

@loop:

   lda  Long_AC,X
   sta  Long_PC,X
   dex
   bpl  @loop
   plx

   rts

; *******************
LPC_Plus_Page_To_LAC:
; *******************

   phx
   ldx  #$03

@loop:

   lda  Long_PC,X
   sta  Long_AC,X
   dex
   bpl  @loop
   plx

   inc Long_AC+1
   bcc @exit
   inw Long_AC+2

@exit:

   rts


; *********
LAC_To_LCT:
; *********

         PHX
         LDX  #3
@loop    LDA  Long_AC,X
         STA  Long_CT,X
         DEX
         BPL  @loop
         PLX
         RTS

; *********
LAC_To_LDA:
; *********

         PHX
         LDX  #3
@loop    LDA  Long_AC,X
         STA  Long_DA,X
         DEX
         BPL  @loop
         PLX
         RTS

; ***********
LAC_Plus_LCT:
; ***********

         PHX
         LDX  #252              ; use ZP wrap around
         CLC
@loop    LDA  Long_AC+4,X
         ADC  Long_CT+4,X
         STA  Long_AC+4,X
         INX
         BNE  @loop
         PLX
         RTS

; ************
LAC_Minus_LPC:
; ************

         PHX
         LDX  #252              ; use ZP wrap around
         SEC
@loop    LDA  Long_AC+4,X
         SBC  Long_PC+4,X
         STA  Long_CT+4,X
         INX
         BNE  @loop
         PLX
         RTS

; **************
LAC_Compare_LPC:
; **************

         PHX
         LDX  #252              ; use ZP wrap around
         SEC
@loop    LDA  Long_AC+4,X
         SBC  Long_PC+4,X
         INX
         BNE  @loop
         PLX
         RTS

; ******
Inc_LAC:
; ******

         INW  Long_AC
         BNE  @return
         INW  Long_AC+2
@return  RTS

; ******
Dec_LAC:
; ******

         LDA  Long_AC
         ORA  Long_AC+1
         BNE  @skip
         DEW  Long_AC+2
@skip    DEW  Long_AC
         RTS

; ******
Inc_LPC:
; ******

         INW  Long_PC
         BNE  @return
         INW  Long_PC+2
@return  RTS

; ******
Dec_LDA:
; ******

         LDA  Long_DA
         ORA  Long_DA+1
         BNE  @skip
         DEW  Long_DA+2
@skip    DEW  Long_DA
         RTS

; ****
Fetch:
; ****

         PHZ
         TYA
         TAZ
         JSR  Get_From_Memory_LPC
         PLZ
         AND  #$ff
         RTS


; *********
Print_Bits:
; *********

         PHZ
         STA  Long_DA
         LDY  #8
@loop    LDA  #'*'
         BBS7 Long_DA,@set
         LDA  #'.'
@set     JSR  CHROUT
         ASL  Long_DA
         DEY
         BNE  @loop
         PLZ
         RTS


; ***************
Mon_Set_Register: ; XXX this needs adaptation
; ***************

         JSR  Get_LAC           ; get 1st. parameter
         JSR  LAC_To_PC
         LDY  #3
@loop    JSR  Get_LAC
         BCS  @exit
         LDA  Long_AC
         STA  Addr_Mode,Y
         INY
         CPY  #9
         BCC  @loop
@exit    JMP  Main

; *************
Mon_Set_Memory:
; *************

         JSR  Set_MODE_80

         JSR  Get_LAC           ; get 1st. parameter
         BCS  @exit
         JSR  LAC_To_LPC        ; Long_PC = row address
         LDZ  #0
@loop    JSR  Get_LAC
         BCS  @exit
         LDA  Long_AC
         BBS7 Long_PC+3,@banked ; trigger banked access
         +NOP                   ; use STA  [Long_PC],Z
@banked  STA  (Long_PC),Z
         INZ
         CPZ  #16
         BBR7 MODE_80,@next
         CPZ  #8
@next    BCC  @loop

@exit    JSR  PRIMM
         !pet KEY_ESC, 'o'
         !pet $91,$00
         JSR  Dump_Row
         JMP  Main

; *****
Mon_Go:
; *****

         ; XXX to be rewritten for Open ROMs!
         jmp Main

; ******
Mon_JSR:
; ******

         ; XXX to be rewritten for Open ROMs!
         jmp Main

; ***********
Dump_4_Bytes:
; ***********

@loop    JSR  Get_From_Memory_LPC
         JSR  Print_Hex_Blank
         INZ
         TZA
         AND  #3
         BNE  @loop
         RTS

; ***********
Dump_4_Chars:
; ***********

@loop    JSR  Get_From_Memory_LPC
         TAY
         AND  #%01100000
         BNE  @laba
         LDY  #'.'
@laba    TYA
         JSR  CHROUT
         INZ
         TZA
         AND  #3
         BNE  @loop
         RTS

; *******
Dump_Row:
; *******

         PHZ
         JSR  Print_CR
         LDA  #'>'
         JSR  CHROUT
         JSR  Print_LPC_Addr

         LDZ  #0
         LDX  #2                ; 2 blocks in 80 columns
         BBR7 MODE_80,@loop
         DEX                    ; 1 block  in 40 columns
@loop    JSR  Print_Attr_Bold
         JSR  Dump_4_Bytes
         JSR  Print_Attr_NoBold
         JSR  Dump_4_Bytes
         DEX
         BNE  @loop

         BBS7 MODE_80,@done     ; in 40 columns, do not display chars

         JSR  PRIMM
         !byte $3a,$12,$00      ; reverse on

         LDZ  #0
         LDX  #2                ; 4 blocks in 80 columns
@lchr    JSR  Print_Attr_Bold
         JSR  Dump_4_Chars
         JSR  Print_Attr_NoBold
         JSR  Dump_4_Chars
         DEX
         BNE  @lchr
         TZA
@done
         JSR  Add_LPC
         PLZ
         RTS

; ********
Load_Save:
; ********

         ; XXX to be rewritten for Open ROMs!
         jmp Main

         ; LDY  Disk_Unit
         ; STY  FA
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

; ***********
Mon_Assemble:
; ***********

         JSR  Get_LAC           ; get 1st. parameter
         LBCS Mon_Error
         JSR  LAC_To_LPC        ; Long_PC = PC

@start   LDX  #0                ; mne letter counter
         STX  Long_DA+1         ; clear encoded MNE
         STX  Op_Flag           ; 6:long branch 5:32 bit
         STX  Op_Ix             ; operand byte index
         STX  Op_Len            ; operand length
@getin   JSR  Get_Char
         BNE  @laba
         CPX  #0
         LBEQ Main

@laba    CMP  #' '
         BEQ  @start            ; restart after blank

;        check for long branches

         CPX  #1
         BNE  @labb             ; -> not 2nd. char
         CMP  #'B'
         BNE  @labb             ; 2nd. char != 'B'
         LDZ  Op_Mne
         CPZ  #'L'
         BNE  @labb             ; 1st. Char != 'L'
         SMB6 Op_Flag           ; flag long branch
         DEX                    ; skip 'L'

@labb    STA  Op_Mne,X          ; next mne character
         INX
         CPX  #3
         BNE  @getin

;        encode 3 letter mnemonic

@lpenc   LDA  Op_Mne-1,X
         SEC
         SBC  #$3f              ; offset
         LDY  #5                ; 5 bit code
@lpbit   LSR
         ROR  Long_DA
         ROR  Long_DA+1
         DEY
         BNE  @lpbit
         DEX
         BNE  @lpenc

;        find packed MNE code in table

         LDX  #90               ; # of mnemonics
         LDA  Long_DA
@lpfind  CMP  MNE_L,X           ; compare left MNE
         BNE  @nxfind
         LDY  MNE_R,X
         CPY  Long_DA+1         ; compare right MNE
         BEQ  @found
@nxfind  DEX
         BPL  @lpfind
         JMP  Mon_Error

@found   STX  Ix_Mne

;        find 1st. opcode for this mnemonic

         TXA
         LDX  #0
@lpopc   CMP  MNE_Index,X
         BEQ  @exopc
         INX
         BNE  @lpopc
@exopc   STX  Op_Code

;        check for BBR BBS RMB SMB

         TXA
         AND  #7
         CMP  #7
         BNE  @labc

         JSR  Get_Char
         CMP  #'0'
         LBCC Mon_Error
         CMP  #'8'
         LBCS Mon_Error
         ASL
         ASL
         ASL
         ASL
         ORA  Op_Code
         STA  Op_Code

         JSR  Get_Char
         CMP  #' '
         LBNE Mon_Error

;        read operand

@labc    LDA  #0
@labd    STA  Mode_Flags
         JSR  Read_Number
         LBCS Mon_Error
         BEQ  @labg             ; no operand
         LDA  Long_AC+2
         LBNE Mon_Error         ; -> overflow
         LDY  #2                ; Y=2 word operand
         LDA  Long_AC+1
         BNE  @labf             ; high byte not zero
         DEY                    ; Y=1 byte operand
@labf    LDX  Op_Ix             ; X = operand value #
         TYA                    ; A = 1:byte or 2:word
         STA  Op_Len,X          ; store operand length
         INC  Op_Ix             ; ++index to operand value
         TXA                    ; A = current index
         BNE  @labg             ; -> at 2nd. byte
         JSR  LAC_To_LCT        ; Long_CT = 1st. operand
@labg    DEC  Buf_Index         ; back to delimiter

@lpnop   JSR  Get_Char          ; get delimiter
         LBEQ @adjust           ; end of operand
         CMP  #' '
         BEQ  @lpnop

;        immediate

         CMP  #'#'
         BNE  @lbra
         LDA  Mode_Flags
         BNE  @error
         LDA  #$80              ; immediate mode
         BRA  @labd

;        left bracket

@lbra    CMP  #'['
         BNE  @indir
         LDA  Mode_Flags
         BNE  @error
         SMB5 Op_Flag           ; 32 bit mode
         LDA  #$40              ; ( flag
         BRA  @labd

;        left parenthesis

@indir   CMP  #'('
         BNE  @comma
         LDA  Mode_Flags
         BNE  @error
         LDA  #$40              ; ( flag
         BRA  @labd

;        comma

@comma   CMP  #','
         BNE  @stack
         LDA  Op_Ix             ; operand value #
         BEQ  @error
         LDX  #4                ; outside comma
         LDA  Mode_Flags
         BEQ  @comma1           ; no flags yet
         CMP  #$78              ; ($nn,SP)
         BEQ  @comma1
         CMP  #$48              ; ($nn)
         BEQ  @comma1
         LDX  #$20              ; , inside comma
         CMP  #$40              ; (
         BNE  @error
@comma1  TXA
         ORA  Mode_Flags
         JMP  @labd

;        stack relative

@stack   CMP  #'S'
         BNE  @rbra
         JSR  Get_Char
         CMP  #'P'
         BNE  @error
         LDA  Mode_Flags
         CMP  #$60              ; ($nn,
         BNE  @error
         ORA  #%00010000        ; SP flag
         JMP  @labd

;        right bracket

@rbra    CMP  #']'
         BNE  @right
         BBR5 Op_Flag,@error
         LDA  Op_Ix
         LBEQ Mon_Error         ; no value
         LDA  Mode_Flags
         CMP  #$40              ; (
         LBNE Mon_Error
         ORA  #%00001000        ; )
         JMP  @labd

@error   JMP  Mon_Error

;        right parenthesis

@right   CMP  #')'
         BNE  @X
         LDA  Op_Ix
         LBEQ Mon_Error         ; no value
         LDA  Mode_Flags
         CMP  #$40              ; (
         BEQ  @right1
         CMP  #$61              ; ($nn,X
         BEQ  @right1
         CMP  #$70              ; ($nn,SP
         LBNE Mon_Error
@right1  ORA  #%00001000        ; )
         JMP  @labd

@X       CMP  #'X'
         BNE  @Y
         LDA  Op_Ix
         LBEQ Mon_Error
         LDA  Mode_Flags
         CMP  #$60
         BEQ  @X1
         CMP  #4
         LBNE Mon_Error
@X1      ORA  #%00000001
         JMP  @labd

;        Y

@Y       CMP  #'Y'
         BNE  @Z
         LDA  Op_Ix
         LBEQ Mon_Error
         LDA  Mode_Flags
         CMP  #$4c             ; ($nn),
         BEQ  @Y1
         CMP  #4               ; $nn,
         BEQ  @Y1
         CMP  #$7c             ; ($nn,SP),
         LBNE Mon_Error
@Y1      ORA  #%00000010       ; Y
         JMP  @labd

;        Z

@Z       CMP  #'Z'
         LBNE Mon_Error
         LDA  Op_Ix
         LBEQ Mon_Error
         LDA  Mode_Flags
         CMP  #$4c              ; $nn,
         LBNE Mon_Error
         ORA  #%00000011        ; Z
         JMP  @labd

;        BBR BBS RMB SMB  two operands

@adjust  LDA  Ix_Mne
         LDX  Op_Ix             ; # if values
         BEQ  @match            ; -> no operand
         DEX
         BEQ  @one              ; ->  one operand
         DEX
         LBNE Mon_Error         ; -> error if more than 2
         CMP  #5                ; BBR
         BEQ  @BB
         CMP  #6                ; BBS
         LBNE Mon_Error
@BB      LDA  Long_CT+1
         LBNE Mon_Error
         LDA  #3                ; offset
         JSR  Branch_Target
         LDA  Op_Code
         LDY  Long_AC
         LDX  Long_CT
         STX  Long_AC
         STY  Long_AC+1
         LDY  #2
         BRA  @store

;        one operand in Long_CT

@one     LDX  Long_CT
         LDY  Long_CT+1
         STX  Long_AC
         STY  Long_AC+1            ; Aval = operand
         LDX  #10
@lpbrain CMP  BRAIN-1,X
         BEQ  @branch
         DEX
         BNE  @lpbrain
         BRA  @match

;        branch instruction

@branch  LDA  Mode_Flags
         LBNE Mon_Error         ; only value
         LDA  #2                ; branch offset
         JSR  Branch_Target
         LDA  Op_Code
         LDY  #1                ; short branch
         BBR6 Op_Flag,@bran1
         INY                    ; long branch
         ORA  #3
@bran1   BRA  @store

;        find opcode matching mnemonic and address mode

@match   JSR  Mode_Index
@lpmatch JSR  Match_Mode
         BEQ  @okmat
         LDA  Op_Len
         LBEQ Mon_Error
         LDA  Mode_Flags
         LBMI Mon_Error
         AND  #%00111111
         STA  Mode_Flags
         INC  Op_Len
         JSR  Size_To_Mode
         BRA  @lpmatch
@okmat   LDY  Op_Len
         TXA

;        store instruction bytes
;        -----------------------
;        A    = opcode
;        Y    = operand length
;        Long_AC = operand value

@store   STA  Op_Code
         STY  Op_Size
         INC  Op_Size
         BBR5 Op_Flag,@storen
         LDA  #$ea              ; 32 bit prefix
         LDZ  #0
         STA  [Long_PC],Z       ; store prefix
         INZ
         LDA  Op_Code
         STA  [Long_PC],Z       ; store opcode
         INZ
         LDA  Long_AC
         STA  [Long_PC],Z       ; store address
         INC  Op_Size
         BRA  @print

@storen  PHY
         PLZ                    ; Z = Y
         BEQ  @store1

@lpsto   LDA  Long_AC-1,Y
         STA  [Long_PC],Z
         DEZ
         DEY
         BNE  @lpsto

@store1  LDA  Op_Code
         STA  [Long_PC],Z

@print   JSR  PRIMM
         !pet 13,$91,"a ", KEY_ESC, 'q', 0
         JSR  Print_Code
         INC  Op_Size
         LDA  Op_Size
         JSR  Add_LPC

; print out command 'A' together with next address
; and put it into buffer too,
; for easy entry of next assembler instruction

         JSR  PRIMM
         !pet KEY_RETURN,"a ",0

         LDA  #'A'
         STA  BUF
         LDA  #' '
         STA  BUF+1
         LDY  #2
         LDX  #2                ; 6 digits
         LDA  Long_PC,X
         BNE  @auto
         DEX                    ; 4 digits
@auto    PHX
         LDA  Long_PC,X
         JSR  A_To_Hex
         STA  BUF,Y
         JSR  CHROUT
         INY
         TXA
         STA  BUF,Y
         JSR  CHROUT
         INY
         PLX
         DEX
         BPL  @auto

         LDA  #' '
         STA  BUF,Y
         JSR  CHROUT
         INY
         TYA
         TAX
         JMP  Main_A

; ************
Branch_Target:
; ************

         DEW  Long_AC
         DEC
         BNE  Branch_Target

;        Target - PC

         SEC
         LDA  Long_AC
         SBC  Long_PC
         STA  Long_AC
         LDA  Long_AC+1
         SBC  Long_PC+1
         STA  Long_AC+1
         RTS

; *********
Match_Mode:
; *********

;        find matching mnemonic and address mode

         LDX  Op_Code           ; try this opcode
         LDA  Mode_Flags         ; size and address mode
@loop    CMP  LEN_ADM,X
         BEQ  @return           ; success  ZF=1

;        search for next opcode with same mnemonic

@next    INX                    ; next opcode
         BEQ @error
         LDY  MNE_Index,X
         CPY  Ix_Mne            ; same mnemonic ?
         BEQ  @loop             ; -> compare again
         BRA  @next

@error   DEX                    ; X = $ff ZF=0
@return  RTS

; *********
Mode_Index:
; *********

         LDA  Mode_Flags
         LDX  #0
@loop    CMP  ADMODE,X
         BEQ  @found
         INX
         CPX  #16
         BCC  @loop
         TXA
         RTS
@found   STX  Mode_Flags

; ***********
Size_To_Mode:
; ***********

         LDA  Op_Len
         LSR
         ROR
         ROR
         ORA  Mode_Flags
         STA  Mode_Flags
         LDX  #0
         RTS

; *******
Dis_Code:
; *******

         JSR  PRIMM
         !pet ". ",0

; *********
Print_Code:
; *********

;        print address of instruction

         JSR  Print_LPC_Addr

;        read opcode and calculate length and address mode

         LDY  #0
         STY  Op_Flag           ; clear flags
         JSR  Fetch             ; fetch from (banked) address

;        check for Q instructions

         CMP  #$42              ; NEG
         BNE  @nop
         INY                    ; Y = 1
         JSR  Fetch
         CMP  #$42              ; NEG
         BNE  @nop
         SMB4 Op_Flag           ; Q flag
         LDA  #2
         JSR  Add_LPC           ; skip NEG NEG

;        check for 32 bit address mode

@nop     LDY  #0
         JSR  Fetch
         STA  Op_Code
         TAX
         CMP  #$ea              ; prefix ?
         BNE  @normal
         INY
         JSR  Fetch             ; opcode after prefix
         AND  #%00011111        ; identify ($nn),Z codes
         CMP  #%00010010
         BNE  @normal
         SMB5 Op_Flag           ; set extended flag
         JSR  Fetch
         STA  Op_Code           ; code after prefix
         TAX

@normal  LDY  LEN_ADM,X         ; Y = length and address mode
         TYA                    ; A = length and address mode
         AND  #15               ; A = address mode
         TAX                    ; X = address mode
         LDA  ADMODE,X          ; A = mode flags
         STA  Adr_Flags         ; store
         TYA                    ; A = length and address mode
         AND  #%11000000        ; mask instruction length
         ASL                    ; rotate into lower two bits
         ROL
         ROL
         STA  Op_Size           ; store
         BBR5 Op_Flag,@norm1
         INC  Op_Size
@norm1

;        print instruction and operand bytes

         JSR  Print_Attr_Bold
         LDY  #0
         LDA  #' '
         BBR4 Op_Flag,@blpr
         LDA  #'*'              ; print * for NEG NEG
@blpr    JSR  CHROUT
@lphex   JSR  Fetch
         JSR  Print_Hex_Blank
         CPY  #2
         BEQ  @long             ; stop after 3 bytes
         CPY  Op_Size
         INY
         BCC  @lphex

;        fill up with blanks

@lpfill  CPY  #3
         BCS  @long
         JSR  PRIMM
         !pet "   ",0
         INY
         BRA  @lpfill

;        detect long branches

@long    JSR  Print_Attr_NoBold
         LDA  #' '
         JSR  CHROUT
         LDX  Op_Code
         LDA  LEN_ADM,X
         CMP  #%10100000         ; long branch mode
         BNE  @locate
         SMB6 Op_Flag            ; set long branch flag
         LDA  #'L'
         JSR  CHROUT

;        locate mnemonic text

@locate  LDX  Op_Code           ; X = opcode
         LDY  MNE_Index,X       ; Y = index to mnemonic text
         LDA  MNE_L,Y           ; A = packed left part
         STA  Long_AC+1
         LDA  MNE_R,Y           ; A = packed right part
         STA  Long_AC

;        unpack and print mnemonic text

         LDX  #3                ; 3 letters
@lpmne   LDA  #0
         LDY  #5                ; 5 bits per letter
@lplet   ASL  Long_AC
         ROL  Long_AC+1
         ROL                    ; rotate letter into A
         DEY
         BNE  @lplet            ; next bit
         ADC  #$3f              ; add offset (C = 0)
         DEX
         BEQ  @lastc            ; 3rd. character
         TAZ                    ; remember
         JSR  CHROUT            ; and print it
         BRA  @lpmne            ; next letter

@lastc   BBR4 Op_Flag,@lbra     ; -> no Q
         CMP  #'A'              ; LDA, STA, ORA
         BEQ  @Q3
         CMP  #'C'              ; DEC, INC
         BNE  @Q4
         CPZ  #'E'              ; DEC
         BEQ  @Q3
         CPZ  #'N'              ; INC
         BNE  @Q4
@Q3      LDA  #'Q'              ; LDQ, STQ, ORQ, INQ, DEQ
         JSR  CHROUT
         BRA  @mne4
@Q4      JSR  CHROUT
         LDA  #'Q'              ; add Q as 4th. char
         JSR  CHROUT
         BRA  @mne5

@lbra    JSR  CHROUT            ; 3rd. character
         BBS6 Op_Flag,@mne5     ; long branch

;        check for 4-letter bit instructions

         LDA  Op_Code
         AND  #15
         CMP  #7                ; RMB & SMB
         BEQ  @biti
         CMP  #15               ; BBR & BBS
         BNE  @mne4
         SMB7 Op_Flag           ; flag two operands
@biti    LDA  Op_Code
         AND  #%01110000
         ASL
         ROL
         ROL
         ROL
         ROL
         ORA  #'0'
         JSR  CHROUT
         BRA  @mne5

@mne4    JSR  Print_Blank
@mne5    JSR  Print_Blank

;        check for accumulator operand

         LDA  Op_Code
         LDX  #8
@lpaccu  DEX
         BMI  @oper
         CMP  ACCUMODE,X
         BNE  @lpaccu

         LDA  #'A'
         BBR4 Op_Flag,@accu
         LDA  #'Q'
@accu    JSR  CHROUT
         JMP  @return

;        fetch and decode operand

@oper    LDX  Op_Size
         LBEQ @return           ; -> no operand

         BBR7 Adr_Flags,@laba   ; bit 7: immediate
         LDA  #'#'
         BRA  @labb
@laba    BBR6 Adr_Flags,@labc   ; bit 6: left (
         LDA  #'('
         BBR5 Op_Flag,@labb
         LDA  #'['
@labb    JSR  CHROUT
@labc    LDA  #'$'
         JSR  CHROUT

;        fetch operand to Long_AC

         LDY  #0
         STY  Long_AC+1
@lpfop   INY
         JSR  Fetch
         STA  Long_AC-1,Y
         CPY  Op_Size
         BCC  @lpfop

;        interpret address modes

         LDX  Op_Code
         LDA  LEN_ADM,X
         AND  #%00100000        ; branches
         LBNE @rel

;        print 16 bit operand hi/lo or 8 bit operand

         BBR5 Op_Flag,@proper
         LDA  Long_AC+1
         JSR  Print_Hex         ; [$nn],Z
         LDA  #']'
         JSR  CHROUT
         BRA  @labf

@proper  LDY  Op_Size
         BBR7 Op_Flag,@lpoper
         LDY  #1
@lpoper  LDA  Long_AC-1,Y
         JSR  Print_Hex
         DEY
         BNE  @lpoper

         BBR5 Adr_Flags,@labe   ; comma flag
         LDA  #','
         JSR  CHROUT

         BBR4 Adr_Flags,@labd   ; SP flag
         LDA  #'S'
         JSR  CHROUT
         LDA  #'P'
         JSR  CHROUT

@labd    BBR0 Adr_Flags,@labe   ; X flag
         LDA  #'X'
         JSR  CHROUT

@labe    BBR3 Adr_Flags,@labf   ; ) flag
         LDA  #')'
         JSR  CHROUT

@labf    BBR4 Op_Flag,@comch    ; not a Q instruction
         LDA  Adr_Flags
         AND  #3
         CMP  #1
         BNE  @return           ; Q only with ,X

@comch   BBR2 Adr_Flags,@labg   ; , flag
         LDA  #','
         JSR  CHROUT

         LDA  Adr_Flags
         AND  #%00000011  ; $03
         BEQ  @labg
         TAY
         LDA  Index_Char-1,Y
         JSR  CHROUT

;        fetch 2nd. operand for BBR and BBS

@labg    BBR7 Op_Flag,@return
         LDA  #','
         JSR  CHROUT
         LDA  #'$'
         JSR  CHROUT
         LDY  #2
         JSR  Fetch
         STA  Long_AC
         LDA  #0
         STA  Long_AC+1
         DEY
         STY  Op_Size           ; Op_Size = 1
         LDA  #3                ; offset for relative address
         BRA  @rela

@rel     LDA  #2                ; offset for relative address
@rela    PHA
         LDA  Op_Size           ; 1:short   2:long
         LSR
         ROR
         AND  Long_AC
         BPL  @labh
         LDA  #$ff              ; backward branch
         STA  Long_AC+1

@labh    PLX                    ; offset 2 or 3
@lpinw   INW  Long_AC
         DEX
         BNE  @lpinw

         CLC
         LDA  Long_AC
         ADC  Long_PC
         PHA
         LDA  Long_AC+1
         ADC  Long_PC+1
         TAX
         PLA
         JSR  Print_XA_Hex
         BBR7 Op_Flag,@return
         INC  Op_Size
@return  RTS

; ******
Got_LAC:  ; XXX to be replaced/adapted
; ******

         DEC  Buf_Index

; ******
Get_LAC: ; XXX to be replaced/adapted
; ******

         JSR  Read_Number
         BCS  @error            ; illegal character
         BEQ  @noval            ; no value
         JSR  Got_Char          ; delimiter ?
         BEQ  @end              ; end of input
         CMP  #' '
         BEQ  @ok
         CMP  #','
         BEQ  @ok
@error   JMP  Mon_Error         ; stack is reset in Mon_Error

@noval   SEC
         RTS

@end     DEC  Buf_Index
@ok      CLC
         RTS

; **********
Read_Number: ; XXX obsolete, to be replaced
; **********

         PHX
         PHY
         PHZ
         LDA  #0
         STA  Dig_Cnt           ; count columns read
         STA  Long_AC           ; clear result Long_AC
         STA  Long_AC+1
         STA  Long_AC+2
         STA  Long_AC+3

         JSR  Get_Glyph         ; get 1st. character
         BEQ  @exit
         CMP  #KEY_APOSTROPHE   ; character entry 'C
         BNE  @numeric
         JSR  Get_Char          ; character after '
         STA  Long_AC
         INC  Dig_Cnt
         BRA  @exit

@numeric LDY  #3                ; $ + % %
@prefix  CMP  Cons_Prefix,Y     ; Y = base index
         BEQ  @digit            ; -> valid prefix
         DEY
         BPL  @prefix
         INY                    ; Y = 0
         DEC  Buf_Index         ; character is digit

@digit   JSR  Get_Char          ; hex -> BCD
         BEQ  @exit             ; ? : ; and zero terminate
         CMP  #'0'
         BCC  @exit
         CMP  #':'
         BCC  @valid            ; 0-9
         CMP  #'A'
         BCC  @exit
         CMP  #'G'
         BCS  @exit
         SBC  #7                ; hex conversion
@valid   SBC  #'0'-1
         CMP  Num_Base,Y
         BCS  @error
         PHA                    ; push digit
         INC  Dig_Cnt

         CPY  #1                ; decimal
         BNE  @laba
         LDX  #3                ; push Long_AC * 2
         CLC
@push    LDA  Long_AC,X
         ROL
         PHA
         DEX
         BPL  @push

@laba    LDX  Num_Bits,Y
@shift   ASL  Long_AC
         ROL  Long_AC+1
         ROW  Long_AC+2
         BCS  @error            ; overflow
         DEX
         BNE  @shift

         CPY  #1                ; decimal adjustment
         BNE  @labc
         LDX  #0
         LDZ  #3
         CLC
@pull    PLA
         ADC  Long_AC,X
         STA  Long_AC,X
         INX
         DEZ
         BPL  @pull

@labc    PLA                    ; pull digit
         CLC
         ADC  Long_AC
         STA  Long_AC
         BCC  @digit
         INC  Long_AC+1
         BNE  @digit
         INW  Long_AC+2
         BNE  @digit

@error   SEC
         BRA  @return
@exit    CLC
@return  PLZ
         PLY
         PLX
         LDA  Dig_Cnt           ; digits read
         RTS

; *************
Print_LPC_Addr: ; prints out the address in PC
; *************

   bbr7 Addr_Mode, @short

   lda  Long_PC+3
   jsr  Print_Hex_Low_Digit
   lda  Long_PC+2
   jsr  Print_Hex

@short:

   lda  Long_PC+1
   jsr  Print_Hex
   lda  Long_PC+0
   bra  Print_Hex_Blank

; ***********
Print_XA_Hex:
; ***********

         PHA
         TXA
         JSR  Print_Hex
         PLA

; **************
Print_Hex_Blank:
; **************

         JSR  Print_Hex

; **********
Print_Blank:
; **********

         LDA  #' '
         JMP  CHROUT

; *******
Print_CR:
; *******

         LDA  #13
         JMP  CHROUT

; *******
CR_Erase:
; *******

         JSR  PRIMM
         !pet KEY_RETURN, KEY_ESC, 'q', 0
         RTS

; ******************
Print_Hex_Low_Digit:
; ******************

   phx
   jsr  A_To_Hex
   txa
   jsr  CHROUT
   plx

   rts

; ********
Print_Hex:
; ********

         PHX
         JSR  A_To_Hex
         JSR  CHROUT
         TXA
         PLX
         JMP  CHROUT

; *******
A_To_Hex:
; *******

         PHA
         JSR  @nibble
         TAX
         PLA
         LSR
         LSR
         LSR
         LSR

@nibble  AND  #15
         CMP  #10
         BCC  @lab
         ADC  #6
@lab     ADC  #'0'
         RTS

; ********
Get_Glyph:
; ********

         PHX
         LDA  #' '
@loop    LDX  Buf_Index
         INC  Buf_Index
         CMP  BUF,X
         BEQ  @loop
         PLX                    ; fall through

; *******
Got_Char:
; *******

         DEC  Buf_Index

; *******
Get_Char:
; *******

         PHX
         LDX  Buf_Index
         INC  Buf_Index
         LDA  BUF,X
         CPX  #1
         PLX
         BCC  @regc
         CMP  #';'            ; register
         BEQ  @return
         CMP  #'?'            ; help
         BEQ  @return
@regc    CMP  #0
         BEQ  @return
         CMP  #':'
@return  RTS


; ******
Dec_LCT:
; ******

         LDA  Long_CT
         ORA  Long_CT+1
         BNE  @skip
         DEW  Long_CT+2
@skip    DEW  Long_CT
         LDA  Long_CT+3         ; set N flag
         RTS

; ******
Add_LPC:
; ******

         CLC
         ADC  Long_PC
         STA  Long_PC
         BCC  Inc_LPC_Page_return

; ***********
Inc_LPC_Page:
; ***********

         INC  Long_PC+1
         BNE  Inc_LPC_Page_return
         INW  Long_PC+2
Inc_LPC_Page_return
         RTS


; ********
Converter:
; ********

         LDX  #0
         STX  Buf_Index
         JSR  Get_Addr_To_LAC
         LBEQ Mon_Error
         JSR  Print_CR
         LDX  #0
@loop    PHX
         JSR  CR_Erase
         LDA  Cons_Prefix,X
         JSR  CHROUT
         TXA
         ASL
         TAX
         JSR  (Conv_Tab,X)
         PLX
         INX
         CPX  #4
         BCC  @loop
         JSR  Print_CR
         JMP  Main

Conv_Tab !word Print_Hexval
         !word Print_Decimal
         !word Print_Octal
         !word Print_Dual

; *********
Print_Dual:
; *********

         LDX  #24               ; digits
         LDY  #1                ; bits per digit
         BRA  Print_Octal_entry

; **********
Print_Octal:
; **********

         LDX  #8                ; digits
         LDY  #3                ; bits per digit

Print_Octal_entry
         JSR  LAC_To_LCT
         LDZ  #0
         STZ  Long_PC
         LDZ  #'0'
         PHY                    ; save start value
@loopa   PLY                    ; reinitialise
         PHY
         LDA  #0
@loopb   ASL  Long_CT
         ROW  Long_CT+1
         ROL
         DEY
         BNE  @loopb
         CPX  #1                ; print last character
         BEQ  @skip
         ORA  Long_PC
         BEQ  @next
@skip    ORA  #'0'
         STZ  Long_PC
         JSR  CHROUT
@next    DEX
         BNE  @loopa
         PLY                    ; cleanup stack
         RTS

; ***********
Print_Hexval:
; ***********

        JSR  LAC_To_LPC
        LDA  #0
        STA  Long_PC+3
        BRA  Print_BCD

; ************
Print_Decimal:
; ************

; max $ffffff = 16777215 (8 digits)

         JSR  LAC_To_LCT
         LDX  #3                ; 4 BCD bytes = 8 digits
         LDA  #0
@clear   STA  Long_PC,X
         DEX
         BPL  @clear

         LDX  #32               ; source bits
         SED
@loop    ASL  Long_CT
         ROL  Long_CT+1
         ROW  Long_CT+2
         LDA  Long_PC
         ADC  Long_PC
         STA  Long_PC
         LDA  Long_PC+1
         ADC  Long_PC+1
         STA  Long_PC+1
         LDA  Long_PC+2
         ADC  Long_PC+2
         STA  Long_PC+2
         LDA  Long_PC+3
         ADC  Long_PC+3
         STA  Long_PC+3
         DEX
         BNE  @loop
         CLD

; ********
Print_BCD:
; ********

         LDA  #0
         STA  Long_CT
         LDZ  #'0'
         LDY  #8                ; max. digits
@loopa   LDX  #3                ; 4 bytes
         LDA  #0
@loopb   ASL  Long_PC
         ROL  Long_PC+1
         ROW  Long_PC+2
         ROL
         DEX
         BPL  @loopb

         CPY  #1                ; print last character
         BEQ  @skip
         ORA  Long_CT
         BEQ  @next
@skip    ORA  #'0'
         STZ  Long_CT
         CMP  #$3a
         BCC  @print
         ADC  #6                ; + carry
@print   JSR  CHROUT
@next    DEY
         BNE  @loopa
         RTS

; ******
Mon_DOS:
; ******

         JSR  wedge_dos_monitor
         JSR  Print_CR
         JMP  Main


; The 3 letter mnemonics are encoded as three 5-bit values
; and stored in a left byte MNE_L and a right byte MNE_R
; The 5 bit value is computed by subtracting $3f from the
; ASCII value, so '?'-> 0, '@'->1, 'A'->2, 'B'->3,'Z'->27
; For example "ADC" is encoded as 2, 5, 4
; ----------------
; 7654321076543210
; 00010
;      00101
;           00100
;                0
;
               
!set ENC_A = %00000010 +  0
!set ENC_B = %00000010 +  1
!set ENC_C = %00000010 +  2
!set ENC_D = %00000010 +  3
!set ENC_E = %00000010 +  4
!set ENC_F = %00000010 +  5
!set ENC_G = %00000010 +  6
!set ENC_H = %00000010 +  7
!set ENC_I = %00000010 +  8
!set ENC_J = %00000010 +  9
!set ENC_K = %00000010 + 10
!set ENC_L = %00000010 + 11
!set ENC_M = %00000010 + 12
!set ENC_N = %00000010 + 13
!set ENC_O = %00000010 + 14
!set ENC_P = %00000010 + 15
!set ENC_Q = %00000010 + 16
!set ENC_R = %00000010 + 17
!set ENC_S = %00000010 + 18
!set ENC_T = %00000010 + 19
!set ENC_U = %00000010 + 20
!set ENC_V = %00000010 + 21
!set ENC_W = %00000010 + 22
!set ENC_X = %00000010 + 23
!set ENC_Y = %00000010 + 24
!set ENC_Z = %00000010 + 25

!set ENC_ADC = (ENC_A * 32 * 32 + ENC_D * 32 + ENC_C) * 2
!set ENC_AND = (ENC_A * 32 * 32 + ENC_N * 32 + ENC_D) * 2
!set ENC_ASL = (ENC_A * 32 * 32 + ENC_S * 32 + ENC_L) * 2
!set ENC_ASR = (ENC_A * 32 * 32 + ENC_S * 32 + ENC_R) * 2
!set ENC_ASW = (ENC_A * 32 * 32 + ENC_S * 32 + ENC_W) * 2
!set ENC_BBR = (ENC_B * 32 * 32 + ENC_B * 32 + ENC_R) * 2
!set ENC_BBS = (ENC_B * 32 * 32 + ENC_B * 32 + ENC_S) * 2
!set ENC_BCC = (ENC_B * 32 * 32 + ENC_C * 32 + ENC_C) * 2
!set ENC_BCS = (ENC_B * 32 * 32 + ENC_C * 32 + ENC_S) * 2
!set ENC_BEQ = (ENC_B * 32 * 32 + ENC_E * 32 + ENC_Q) * 2
!set ENC_BIT = (ENC_B * 32 * 32 + ENC_I * 32 + ENC_T) * 2
!set ENC_BMI = (ENC_B * 32 * 32 + ENC_M * 32 + ENC_I) * 2
!set ENC_BNE = (ENC_B * 32 * 32 + ENC_N * 32 + ENC_E) * 2
!set ENC_BPL = (ENC_B * 32 * 32 + ENC_P * 32 + ENC_L) * 2
!set ENC_BRA = (ENC_B * 32 * 32 + ENC_R * 32 + ENC_A) * 2
!set ENC_BRK = (ENC_B * 32 * 32 + ENC_R * 32 + ENC_K) * 2
!set ENC_BSR = (ENC_B * 32 * 32 + ENC_S * 32 + ENC_R) * 2
!set ENC_BVC = (ENC_B * 32 * 32 + ENC_V * 32 + ENC_C) * 2
!set ENC_BVS = (ENC_B * 32 * 32 + ENC_V * 32 + ENC_S) * 2
!set ENC_CLC = (ENC_C * 32 * 32 + ENC_L * 32 + ENC_C) * 2
!set ENC_CLD = (ENC_C * 32 * 32 + ENC_L * 32 + ENC_D) * 2
!set ENC_CLE = (ENC_C * 32 * 32 + ENC_L * 32 + ENC_E) * 2
!set ENC_CLI = (ENC_C * 32 * 32 + ENC_L * 32 + ENC_I) * 2
!set ENC_CLV = (ENC_C * 32 * 32 + ENC_L * 32 + ENC_V) * 2
!set ENC_CMP = (ENC_C * 32 * 32 + ENC_M * 32 + ENC_P) * 2
!set ENC_CPX = (ENC_C * 32 * 32 + ENC_P * 32 + ENC_X) * 2
!set ENC_CPY = (ENC_C * 32 * 32 + ENC_P * 32 + ENC_Y) * 2
!set ENC_CPZ = (ENC_C * 32 * 32 + ENC_P * 32 + ENC_Z) * 2
!set ENC_DEC = (ENC_D * 32 * 32 + ENC_E * 32 + ENC_C) * 2
!set ENC_DEW = (ENC_D * 32 * 32 + ENC_E * 32 + ENC_W) * 2
!set ENC_DEX = (ENC_D * 32 * 32 + ENC_E * 32 + ENC_X) * 2
!set ENC_DEY = (ENC_D * 32 * 32 + ENC_E * 32 + ENC_Y) * 2
!set ENC_DEZ = (ENC_D * 32 * 32 + ENC_E * 32 + ENC_Z) * 2
!set ENC_EOR = (ENC_E * 32 * 32 + ENC_O * 32 + ENC_R) * 2
!set ENC_INC = (ENC_I * 32 * 32 + ENC_N * 32 + ENC_C) * 2
!set ENC_INW = (ENC_I * 32 * 32 + ENC_N * 32 + ENC_W) * 2
!set ENC_INX = (ENC_I * 32 * 32 + ENC_N * 32 + ENC_X) * 2
!set ENC_INY = (ENC_I * 32 * 32 + ENC_N * 32 + ENC_Y) * 2
!set ENC_INZ = (ENC_I * 32 * 32 + ENC_N * 32 + ENC_Z) * 2
!set ENC_JMP = (ENC_J * 32 * 32 + ENC_M * 32 + ENC_P) * 2
!set ENC_JSR = (ENC_J * 32 * 32 + ENC_S * 32 + ENC_R) * 2
!set ENC_LDA = (ENC_L * 32 * 32 + ENC_D * 32 + ENC_A) * 2
!set ENC_LDX = (ENC_L * 32 * 32 + ENC_D * 32 + ENC_X) * 2
!set ENC_LDY = (ENC_L * 32 * 32 + ENC_D * 32 + ENC_Y) * 2
!set ENC_LDZ = (ENC_L * 32 * 32 + ENC_D * 32 + ENC_Z) * 2
!set ENC_LSR = (ENC_L * 32 * 32 + ENC_S * 32 + ENC_R) * 2
!set ENC_MAP = (ENC_M * 32 * 32 + ENC_A * 32 + ENC_P) * 2
!set ENC_NEG = (ENC_N * 32 * 32 + ENC_E * 32 + ENC_G) * 2
!set ENC_NOP = (ENC_N * 32 * 32 + ENC_O * 32 + ENC_P) * 2
!set ENC_ORA = (ENC_O * 32 * 32 + ENC_R * 32 + ENC_A) * 2
!set ENC_PHA = (ENC_P * 32 * 32 + ENC_H * 32 + ENC_A) * 2
!set ENC_PHP = (ENC_P * 32 * 32 + ENC_H * 32 + ENC_P) * 2
!set ENC_PHW = (ENC_P * 32 * 32 + ENC_H * 32 + ENC_W) * 2
!set ENC_PHX = (ENC_P * 32 * 32 + ENC_H * 32 + ENC_X) * 2
!set ENC_PHY = (ENC_P * 32 * 32 + ENC_H * 32 + ENC_Y) * 2
!set ENC_PHZ = (ENC_P * 32 * 32 + ENC_H * 32 + ENC_Z) * 2
!set ENC_PLA = (ENC_P * 32 * 32 + ENC_L * 32 + ENC_A) * 2
!set ENC_PLP = (ENC_P * 32 * 32 + ENC_L * 32 + ENC_P) * 2
!set ENC_PLX = (ENC_P * 32 * 32 + ENC_L * 32 + ENC_X) * 2
!set ENC_PLY = (ENC_P * 32 * 32 + ENC_L * 32 + ENC_Y) * 2
!set ENC_PLZ = (ENC_P * 32 * 32 + ENC_L * 32 + ENC_Z) * 2
!set ENC_RMB = (ENC_R * 32 * 32 + ENC_M * 32 + ENC_B) * 2
!set ENC_ROL = (ENC_R * 32 * 32 + ENC_O * 32 + ENC_L) * 2
!set ENC_ROR = (ENC_R * 32 * 32 + ENC_O * 32 + ENC_R) * 2
!set ENC_ROW = (ENC_R * 32 * 32 + ENC_O * 32 + ENC_W) * 2
!set ENC_RTI = (ENC_R * 32 * 32 + ENC_T * 32 + ENC_I) * 2
!set ENC_RTS = (ENC_R * 32 * 32 + ENC_T * 32 + ENC_S) * 2
!set ENC_SBC = (ENC_S * 32 * 32 + ENC_B * 32 + ENC_C) * 2
!set ENC_SEC = (ENC_S * 32 * 32 + ENC_E * 32 + ENC_C) * 2
!set ENC_SED = (ENC_S * 32 * 32 + ENC_E * 32 + ENC_D) * 2
!set ENC_SEE = (ENC_S * 32 * 32 + ENC_E * 32 + ENC_E) * 2
!set ENC_SEI = (ENC_S * 32 * 32 + ENC_E * 32 + ENC_I) * 2
!set ENC_SMB = (ENC_S * 32 * 32 + ENC_M * 32 + ENC_B) * 2
!set ENC_STA = (ENC_S * 32 * 32 + ENC_T * 32 + ENC_A) * 2
!set ENC_STX = (ENC_S * 32 * 32 + ENC_T * 32 + ENC_X) * 2
!set ENC_STY = (ENC_S * 32 * 32 + ENC_T * 32 + ENC_Y) * 2
!set ENC_STZ = (ENC_S * 32 * 32 + ENC_T * 32 + ENC_Z) * 2
!set ENC_TAB = (ENC_T * 32 * 32 + ENC_A * 32 + ENC_B) * 2
!set ENC_TAX = (ENC_T * 32 * 32 + ENC_A * 32 + ENC_X) * 2
!set ENC_TAY = (ENC_T * 32 * 32 + ENC_A * 32 + ENC_Y) * 2
!set ENC_TAZ = (ENC_T * 32 * 32 + ENC_A * 32 + ENC_Z) * 2
!set ENC_TBA = (ENC_T * 32 * 32 + ENC_B * 32 + ENC_A) * 2
!set ENC_TRB = (ENC_T * 32 * 32 + ENC_R * 32 + ENC_B) * 2
!set ENC_TSB = (ENC_T * 32 * 32 + ENC_S * 32 + ENC_B) * 2
!set ENC_TSX = (ENC_T * 32 * 32 + ENC_S * 32 + ENC_X) * 2
!set ENC_TSY = (ENC_T * 32 * 32 + ENC_S * 32 + ENC_Y) * 2
!set ENC_TXA = (ENC_T * 32 * 32 + ENC_X * 32 + ENC_A) * 2
!set ENC_TXS = (ENC_T * 32 * 32 + ENC_X * 32 + ENC_S) * 2
!set ENC_TYA = (ENC_T * 32 * 32 + ENC_Y * 32 + ENC_A) * 2
!set ENC_TYS = (ENC_T * 32 * 32 + ENC_Y * 32 + ENC_S) * 2
!set ENC_TZA = (ENC_T * 32 * 32 + ENC_Z * 32 + ENC_A) * 2

; ****
MNE_L:
; ****

         !byte >ENC_ADC, >ENC_AND, >ENC_ASL, >ENC_ASR, >ENC_ASW, >ENC_BBR, >ENC_BBS, >ENC_BCC
         !byte >ENC_BCS, >ENC_BEQ, >ENC_BIT, >ENC_BMI, >ENC_BNE, >ENC_BPL, >ENC_BRA, >ENC_BRK
         !byte >ENC_BSR, >ENC_BVC, >ENC_BVS, >ENC_CLC, >ENC_CLD, >ENC_CLE, >ENC_CLI, >ENC_CLV
         !byte >ENC_CMP, >ENC_CPX, >ENC_CPY, >ENC_CPZ, >ENC_DEC, >ENC_DEW, >ENC_DEX, >ENC_DEY
         !byte >ENC_DEZ, >ENC_EOR, >ENC_INC, >ENC_INW, >ENC_INX, >ENC_INY, >ENC_INZ, >ENC_JMP
         !byte >ENC_JSR, >ENC_LDA, >ENC_LDX, >ENC_LDY, >ENC_LDZ, >ENC_LSR, >ENC_MAP, >ENC_NEG
         !byte >ENC_NOP, >ENC_ORA, >ENC_PHA, >ENC_PHP, >ENC_PHW, >ENC_PHX, >ENC_PHY, >ENC_PHZ
         !byte >ENC_PLA, >ENC_PLP, >ENC_PLX, >ENC_PLY, >ENC_PLZ, >ENC_RMB, >ENC_ROL, >ENC_ROR
         !byte >ENC_ROW, >ENC_RTI, >ENC_RTS, >ENC_SBC, >ENC_SEC, >ENC_SED, >ENC_SEE, >ENC_SEI
         !byte >ENC_SMB, >ENC_STA, >ENC_STX, >ENC_STY, >ENC_STZ, >ENC_TAB, >ENC_TAX, >ENC_TAY
         !byte >ENC_TAZ, >ENC_TBA, >ENC_TRB, >ENC_TSB, >ENC_TSX, >ENC_TSY, >ENC_TXA, >ENC_TXS
         !byte >ENC_TYA, >ENC_TYS, >ENC_TZA

; ****
MNE_R:
; ****

         !byte <ENC_ADC, <ENC_AND, <ENC_ASL, <ENC_ASR, <ENC_ASW, <ENC_BBR, <ENC_BBS, <ENC_BCC
         !byte <ENC_BCS, <ENC_BEQ, <ENC_BIT, <ENC_BMI, <ENC_BNE, <ENC_BPL, <ENC_BRA, <ENC_BRK
         !byte <ENC_BSR, <ENC_BVC, <ENC_BVS, <ENC_CLC, <ENC_CLD, <ENC_CLE, <ENC_CLI, <ENC_CLV
         !byte <ENC_CMP, <ENC_CPX, <ENC_CPY, <ENC_CPZ, <ENC_DEC, <ENC_DEW, <ENC_DEX, <ENC_DEY
         !byte <ENC_DEZ, <ENC_EOR, <ENC_INC, <ENC_INW, <ENC_INX, <ENC_INY, <ENC_INZ, <ENC_JMP
         !byte <ENC_JSR, <ENC_LDA, <ENC_LDX, <ENC_LDY, <ENC_LDZ, <ENC_LSR, <ENC_MAP, <ENC_NEG
         !byte <ENC_NOP, <ENC_ORA, <ENC_PHA, <ENC_PHP, <ENC_PHW, <ENC_PHX, <ENC_PHY, <ENC_PHZ
         !byte <ENC_PLA, <ENC_PLP, <ENC_PLX, <ENC_PLY, <ENC_PLZ, <ENC_RMB, <ENC_ROL, <ENC_ROR
         !byte <ENC_ROW, <ENC_RTI, <ENC_RTS, <ENC_SBC, <ENC_SEC, <ENC_SED, <ENC_SEE, <ENC_SEI
         !byte <ENC_SMB, <ENC_STA, <ENC_STX, <ENC_STY, <ENC_STZ, <ENC_TAB, <ENC_TAX, <ENC_TAY
         !byte <ENC_TAZ, <ENC_TBA, <ENC_TRB, <ENC_TSB, <ENC_TSX, <ENC_TSY, <ENC_TXA, <ENC_TXS
         !byte <ENC_TYA, <ENC_TYS, <ENC_TZA


; ********
MNE_Index:
; ********

; an index for all 256 opcodes, describing
; where to find the 3-letter mnemonic

         !byte $0f,$31,$15,$46,$53,$31,$02,$3d
         !byte $33,$31,$02,$55,$53,$31,$02,$05
         !byte $0d,$31,$31,$0d,$52,$31,$02,$3d
         !byte $13,$31,$22,$26,$52,$31,$02,$05
         !byte $28,$01,$28,$28,$0a,$01,$3e,$3d
         !byte $39,$01,$3e,$59,$0a,$01,$3e,$05
         !byte $0b,$01,$01,$0b,$0a,$01,$3e,$3d
         !byte $44,$01,$1c,$20,$0a,$01,$3e,$05
         !byte $41,$21,$2f,$03,$03,$21,$2d,$3d
         !byte $32,$21,$2d,$50,$27,$21,$2d,$05
         !byte $11,$21,$21,$11,$03,$21,$2d,$3d
         !byte $16,$21,$36,$4d,$2e,$21,$2d,$05
         !byte $42,$00,$42,$10,$4c,$00,$3f,$3d
         !byte $38,$00,$3f,$5a,$27,$00,$3f,$05
         !byte $12,$00,$00,$12,$4c,$00,$3f,$3d
         !byte $47,$00,$3b,$51,$27,$00,$3f,$05
         !byte $0e,$49,$49,$0e,$4b,$49,$4a,$48
         !byte $1f,$0a,$56,$4b,$4b,$49,$4a,$06
         !byte $07,$49,$49,$07,$4b,$49,$4a,$48
         !byte $58,$49,$57,$4a,$4c,$49,$4c,$06
         !byte $2b,$29,$2a,$2c,$2b,$29,$2a,$48
         !byte $4f,$29,$4e,$2c,$2b,$29,$2a,$06
         !byte $08,$29,$29,$08,$2b,$29,$2a,$48
         !byte $17,$29,$54,$2c,$2b,$29,$2a,$06
         !byte $1a,$18,$1b,$1d,$1a,$18,$1c,$48
         !byte $25,$18,$1e,$04,$1a,$18,$1c,$06
         !byte $0c,$18,$18,$0c,$1b,$18,$1c,$48
         !byte $14,$18,$35,$37,$1b,$18,$1c,$06
         !byte $19,$43,$29,$23,$19,$43,$22,$48
         !byte $24,$43,$30,$40,$19,$43,$22,$06
         !byte $09,$43,$43,$09,$34,$43,$22,$48
         !byte $45,$43,$3a,$3c,$34,$43,$22,$06

; ****
BRAIN:
; ****

;              index values for branch mnemonics

;              BCC BCS BEQ BMI BNE BPL BRA BSR BVC BVS
         !byte $07,$08,$09,$0b,$0c,$0d,$0e,$10,$11,$12

; ******
LEN_ADM:
; ******

; a table of instruction length, flags
; and address mode for all 256 opcodes

; 7-6: operand length %00.. 0: implied
;                     %01.. 1: direct page, indirect
;                     %10.. 2: absolute, etc.
;                     %11.. 3: BBR and BBS

;   5: relative       %0110 0000 $60 short branch
;                     %1010 0000 $a0 long  branch

;   4:

; 3-0: index of address mode

; ( %11...... BBR BBS)

         !byte $00,$44,$00,$00,$40,$40,$40,$40 ; $00
         !byte $00,$41,$00,$00,$80,$80,$80,$c0 ; $08
         !byte $60,$45,$46,$a0,$40,$47,$47,$40 ; $10
         !byte $00,$88,$00,$00,$80,$87,$87,$c0 ; $18
         !byte $80,$44,$8b,$84,$40,$40,$40,$40 ; $20
         !byte $00,$41,$00,$00,$80,$80,$80,$c0 ; $28
         !byte $60,$45,$46,$a0,$47,$47,$47,$40 ; $30
         !byte $00,$88,$00,$00,$87,$87,$87,$c0 ; $38
         !byte $00,$44,$00,$00,$40,$40,$40,$40 ; $40
         !byte $00,$41,$00,$00,$80,$80,$80,$c0 ; $48
         !byte $60,$45,$46,$a0,$47,$47,$47,$40 ; $50
         !byte $00,$88,$00,$00,$00,$87,$87,$c0 ; $58
         !byte $00,$44,$41,$a0,$40,$40,$40,$40 ; $60
         !byte $00,$41,$00,$00,$8b,$80,$80,$c0 ; $68
         !byte $60,$45,$46,$a0,$47,$47,$47,$40 ; $70
         !byte $00,$88,$00,$00,$84,$87,$87,$c0 ; $78
         !byte $60,$44,$4d,$a0,$40,$40,$40,$40 ; $80
         !byte $00,$41,$00,$87,$80,$80,$80,$c0 ; $88
         !byte $60,$45,$46,$a0,$47,$47,$48,$40 ; $90
         !byte $00,$88,$00,$88,$80,$87,$87,$c0 ; $98
         !byte $41,$44,$41,$41,$40,$40,$40,$40 ; $a0
         !byte $00,$41,$00,$80,$80,$80,$80,$c0 ; $a8
         !byte $60,$45,$46,$a0,$47,$47,$48,$40 ; $b0
         !byte $00,$88,$00,$87,$87,$87,$88,$c0 ; $b8
         !byte $41,$44,$41,$40,$40,$40,$40,$40 ; $c0
         !byte $00,$41,$00,$80,$80,$80,$80,$c0 ; $c8
         !byte $60,$45,$46,$a0,$40,$47,$47,$40 ; $d0
         !byte $00,$88,$00,$00,$80,$87,$87,$c0 ; $d8
         !byte $41,$44,$4d,$40,$40,$40,$40,$40 ; $e0
         !byte $00,$41,$00,$80,$80,$80,$80,$c0 ; $e8
         !byte $60,$45,$46,$a0,$81,$47,$47,$40 ; $f0
         !byte $00,$88,$00,$00,$80,$87,$87,$c0 ; $f8

; *****
ADMODE:
; *****

; printout flags for 16 address modes
;               76543210
;               --------
;            7  x         #
;            6   x        (
;            5    x       ,
;            4     x      SP
;            3      x     )
;            2       x    ,
;            1/0      xx  01:X  10:Y  11:Z

         !byte %00000000 ; 0             implicit/direct
         !byte %10000000 ; 1 #$nn        immediate
         !byte %00000000 ; 2             ----------
         !byte %00000000 ; 3             ----------
         !byte %01101001 ; 4 ($nn,X)     indirect X
         !byte %01001110 ; 5 ($nn),Y     indirect Y
         !byte %01001111 ; 6 ($nn),Z     indirect Z
         !byte %00000101 ; 7 $nn,X       indexed  X
         !byte %00000110 ; 8 $nn,Y       indexed  Y
         !byte %00000101 ; 9 $nn,X       indexed  X
         !byte %00000110 ; a $nn,Y       ----------
         !byte %01001000 ; b ($nnnn,X)   JMP & JSR
         !byte %01101001 ; c ($nn,X)     ----------
         !byte %01111110 ; d ($nn,SP),Y  LDA & STA
         !byte %00000000 ; e
         !byte %00000100 ; f

;                  ASL INC ROL DEC LSR ROR NEG ASR
ACCUMODE:    !byte $0a,$1a,$2a,$3a,$4a,$6a,$42,$43

Num_Base:    !byte 16,10, 8,  2 ; hex, dec, oct, bin
Num_Bits:    !byte  4, 3, 3,  1 ; hex, dec, oct, bin
Num_Limit:   !byte  5, 5, 9, 33 ; hex, dec, oct, bin  

Index_Char:  !pet "xyz"
;                  0123456789abcd
U1:          !pet "u1:9 0 000 000",0 ; channel 9, drive, track, sector
BP_ZERO:     !pet "b-p 9 0",0        ; set buffer pointer to 0

; *******
Reg_Text:
; *******

         JSR  PRIMM
         !pet KEY_RETURN, "   pc  sr ac xr yr zr bp  sp  nvebdizc", KEY_RETURN, "; ", KEY_ESC, 'q', 0
         RTS

; *******
Mon_Help:
; *******

         JSR  PRIMM
         
         !pet KEY_RETURN, KEY_RETURN
         !pet KEY_ESC,'s',"a",KEY_ESC,'u',"ssemble     - a address mnemonic operand",KEY_RETURN
         !pet KEY_ESC,'s',"b",KEY_ESC,'u',"itmaps      - b [from]",KEY_RETURN
         !pet KEY_ESC,'s',"c",KEY_ESC,'u',"ompare      - c from to with",KEY_RETURN
         !pet KEY_ESC,'s',"d",KEY_ESC,'u',"isassemble  - d [from [to]]",KEY_RETURN
         !pet KEY_ESC,'s',"f",KEY_ESC,'u',"ill         - f from to fillbyte",KEY_RETURN
         !pet KEY_ESC,'s',"g",KEY_ESC,'u',"o           - g [address]",KEY_RETURN
         !pet KEY_ESC,'s',"h",KEY_ESC,'u',"unt         - h from to (string or bytes)",KEY_RETURN
         !pet KEY_ESC,'s',"j",KEY_ESC,'u',"sr          - j address",KEY_RETURN
         !pet KEY_ESC,'s',"l",KEY_ESC,'u',"oad         - l filename [unit [address]]",KEY_RETURN
         !pet KEY_ESC,'s',"m",KEY_ESC,'u',"emory       - m [from [to]]",KEY_RETURN
         !pet KEY_ESC,'s',"r",KEY_ESC,'u',"egisters    - r",KEY_RETURN
         !pet KEY_ESC,'s',"s",KEY_ESC,'u',"ave         - s filename unit from to",KEY_RETURN
         !pet KEY_ESC,'s',"t",KEY_ESC,'u',"ransfer     - t from to target",KEY_RETURN
         !pet KEY_ESC,'s',"v",KEY_ESC,'u',"erify       - v filename [unit [address]]",KEY_RETURN
         !pet "e",KEY_ESC,'s',"x",KEY_ESC,'u',"it         - x",KEY_RETURN
         !pet KEY_ESC,'s',".",KEY_ESC,'u',"<dot>       - . address mnemonic operand",KEY_RETURN
         !pet KEY_ESC,'s',">",KEY_ESC,'u',"<greater>   - > address byte sequence",KEY_RETURN
         !pet KEY_ESC,'s',";",KEY_ESC,'u',"<semicolon> - ; register contents",KEY_RETURN
         !pet KEY_ESC,'s',"@",KEY_ESC,'u',"dos         - @[dos wedge command]",KEY_RETURN
         !pet KEY_ESC,'s',"$",KEY_ESC,'u',"<dollar>    - hexadecimal number (default)",KEY_RETURN
         !pet KEY_ESC,'s',"+",KEY_ESC,'u',"<plus>      - decimal number",KEY_RETURN
         !pet KEY_ESC,'s',"&",KEY_ESC,'u',"<ampersand> - octal number",KEY_RETURN
         !pet KEY_ESC,'s',"%",KEY_ESC,'u',"<percent>   - binary number",KEY_RETURN
         !pet KEY_ESC,'s',"?",KEY_ESC,'u',"help        - ?",KEY_RETURN
         !pet 0

         JMP Main


; **********
Set_MODE_80:
; **********

        ; Not too effective, but allows to retain more original code

        PHP
        PHA
        PHX
        PHY

        JSR SCREEN
        CPX #80
        BEQ @1
        LDA #$FF
        +skip_2_bytes_trash_nvz
@1      LDA #$00
        STA MODE_80

        PLY
        PLX
        PLA
        PLP

        RTS
