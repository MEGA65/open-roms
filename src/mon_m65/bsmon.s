; *******************************
; * BSM = Bit Shifter's Monitor *
; * for The MEGA65  10-Dec_2020 *
; * (adaped for the Open ROMs)  *
; *******************************

!ifdef CONFIG_DEV_BSMON {

; XXX adapt all the addresses/constants!


; *************
; * Constants *
; *************

!set WHITE  = $05
!set YELLOW = $9e
!set LRED   = $96

!set CR     = $0d
!set REV    = $12
!set CRIGHT = $1d
!set QUOTE  = $22
!set APOSTR = $27

; ************************************************
; * Register storage for JMPFAR and JSRFAR calls *
; ************************************************

!addr Bank        =  2
!addr PCH         =  3
!addr PCL         =  4
!addr SR          =  5
!addr AC          =  6
!addr XR          =  7
!addr YR          =  8
!addr ZR          =  9

; *************************************
; * Used direct (zero) page addresses *
; *************************************

!addr BP          = 10
!addr SPH         = 11
!addr SPL         = 12

; following variables overlap with the BASIC floating point area

; $59 - $5d : temporary floating point accumulator
; $5e - $62 : temporary floating point accumulator
; $63 - $69 : primary   floating point accumulator
; $6a - $6f : secondary floating point accumulator

; A set of 32 bit variables also used as 32 bit pointer

!addr Long_AC     = $59 ; 32 bit accumulator
!addr Long_CT     = $5d ; 32 bit counter
!addr Long_PC     = $61 ; 32 bit program counter
!addr Long_DA     = $65 ; 32 bit data pointer

; Flags are used in BBR BBS instructions

!addr Adr_Flags   = $69
!addr Mode_Flags  = $6a
!addr Op_Code     = $6b
!addr Op_Flag     = $6c ; 7: two operands
                        ; 6: long branch
                        ; 5: 32 bit address
                        ; 4: Q register
!addr Op_Size     = $6d
!addr Dig_Cnt     = $6e
!addr Buf_Index   = $6f

; operating system variables


!addr STATUS      = $90
!addr VERCK       = $93
!addr FNLEN       = $b7
!addr SA          = $b9
!addr FA          = $ba
!addr FNADR       = $bb
!addr BA          = $bd
!addr FNBANK      = $be

!addr NDX         = $d0        ; length of keyboard buffer
!addr MODE_80     = $d7        ; 80 column / 40 volumn flag

!addr QTSW        = $f4        ; Quote switch

!addr Buffer      = $0200      ; input buffer

!addr IIRQ        = $0314
!addr IBRK        = $0316
!addr EXMON       = $032e

                               ; bottom of BASIC runtime stack
                               ; should be a safe space
!addr X_Vector    = $400       ; exit vector (ROM version dependent)
!addr Ix_Mne      = $402       ; index to mnemonics table
!addr Op_Mne      = $403       ; 3 bytes for mnemonic
!addr Op_Ix       = $406       ; type of constant
!addr Op_Len      = $407       ; length of operand
!addr Disk_Unit   = $408       ; unit = device
!addr Disk_Track  = $409       ; logical track  1 -> 255
!addr Disk_Sector = $40A       ; logical sector 0 -> 255
!addr Disk_Status = $40B       ; BCD value of status

Mon_Data    .BSS 40     ; buffer for hunt and filename
Disk_Msg    .BSS 40     ; disk status as text message

!addr EXIT_OLD   = $cf2e      ; exit address for ROM 910110
!addr EXIT       = $cfa4      ; exit address for ROM 911001

!addr PRIMM      = $ff7d
!addr CINT       = $ff81
!addr IOINIT     = $ff84
!addr SETMSG     = $ff90
!addr SECOND     = $ff93
!addr TKSA       = $ff96
!addr KEY        = $ff9f
!addr ACPTR      = $ffa5
!addr CIOUT      = $ffa8
!addr UNTALK     = $ffab
!addr UNLSN      = $ffae
!addr LISTEN     = $ffb1
!addr TALK       = $ffb4
!addr OPEN       = $ffc0
!addr CLOSE      = $ffc3
!addr CHRIN      = $ffcf
!addr CHROUT     = $ffd2
!addr LOAD       = $ffd5
!addr SAVE       = $ffd8
!addr STOP       = $ffe1


; *******
Mon_Break
; *******

         JSR  PRIMM
         .BYTE "\rBREAK\a",0
         JSR  Print_Commands

; pull BP, Z, Y, X, A,SR,PCL,PCH
;       7  6  5  4  3  2  1  0

         LDX  #7
         BIT  EXIT      ; version
         BPL  @loop
         DEX
@loop    PLA
         STA  PCH,X
         DEX
         BPL  @loop

; decrement PC to point after BRK

         LDA  PCL
         BNE  @nopage
         DEC  PCH
@nopage  DEC  PCL

         LDA  $011d
         BBR7 Bank,@bank
         LDA  $011f
@bank    AND  #15
         STA  Bank
         BRA  Mon_Start

; ******
Mon_Call
; ******

         JSR  Print_Commands

;        clear register for monitor call

         LDA  #0
         LDX  #6
@loop    STA  AC,X
         DEX
         BPL  @loop

;        set default PC to "exit to BASIC"

         LDA  #<EXIT     ; ROM 911110
         LDX  #>EXIT
         BIT  EXIT       ; $20 (JSR) or $ff ?
         BPL  @store
         LDA  #<EXIT_OLD ; ROM 910111
         LDX  #>EXIT_OLD
@store   STA  PCL
         STA  X_Vector
         STX  PCH
         STX  X_Vector+1

; *******
Mon_Start
; *******

         CLD
         TSY
         STY  SPH
         TSX
         STX  SPL
         LDA  #$c0
         JSR  SETMSG
         CLI
         NOP

; **********
Mon_Register
; **********

         JSR  Reg_Text

; print Bank,PCH

         LDY  #0
@loopa   LDA  Bank,Y
         JSR  Print_Hex
         INY
         CPY  #2
         BCC  @loopa

; print SR,PCL,A,X,Y,Z,BP

@loopb   LDA  Bank,Y
         JSR  Print_Hex_Blank
         INY
         CPY  #9
         BCC  @loopb

; print 16 bit stack pointer

         LDA  SPH
         JSR  Print_Hex
         LDA  SPL
         JSR  Print_Hex_Blank

; print flags

         LDY  #8
         LDA  SR
@loopc   ASL  A
         PHA
         LDA  #'-'
         BCC  @flag
         LDA  #'1'
@flag    JSR  CHROUT
         PLA
         DEY
         BNE  @loopc

; **
Main
; **

         JSR  Print_CR
         LDX  #0

; read one line into buffer

; ****
Main_A
; ****

@loop    JSR  CHRIN
         STA  Buffer,X
         INX
         CPX  #80
         BCS  Mon_Error         ; input too long
         CMP  #CR
         BNE  @loop

         LDA  #0
         STA  Buf_Index
         STA  Buffer-1,X        ; terminate buffer
@getcomm JSR  Get_Char
         BEQ  Main
         CMP  #' '
         BEQ  @getcomm

; ********
Mon_Switch
; ********

         LDX  #24
@loop    CMP  Command_Char,X
         BEQ  Mon_Select
         DEX
         BPL  @loop

;        fall through to error routine if not found

; *******
Mon_Error
; *******

; put a question mark at the end of the text

         JSR  PRIMM
         .BYTE "\eO",CRIGHT,'?',0
         LDX  #$f8              ; reset stack pointer
         TXS
         BRA  Main

; ********
Mon_Select
; ********

         STA  VERCK
         CPX  #22
         LBCS  Load_Save
         TXA
         ASL  A
         TAX
         JMP  (Jump_Table,X)

; ************
Print_Commands
; ************

         JSR  PRIMM
         .BYTE CR,YELLOW,REV,"BS MONITOR COMMANDS:"

; **********
Command_Char
; **********

         ;      0123456789abcdef
         .BYTE "ABCDFGHJMRTX@.>;?"

; *********
Cons_Prefix
; *********

         .BYTE "$+&%'"

; **************
Load_Save_Verify
; **************

         .BYTE "LSV",WHITE,0
         RTS

; ********
Jump_Table
; ********

         !word Mon_Assemble     ; A
         !word Mon_Bits         ; B
         !word Mon_Compare      ; C
         !word Mon_Disassemble  ; D
         !word Mon_Fill         ; F
         !word Mon_Go           ; G
         !word Mon_Hunt         ; H
         !word Mon_JSR          ; J
         !word Mon_Memory       ; M
         !word Mon_Register     ; R
         !word Mon_Transfer     ; T
         !word Mon_Exit         ; X
         !word Mon_DOS          ; @
         !word Mon_Assemble     ; .
         !word Mon_Set_Memory   ; >
         !word Mon_Set_Register ; ;
         !word Mon_Help         ; ?
         !word Converter        ; $
         !word Converter        ; +
         !word Converter        ; &
         !word Converter        ; %


; ******
Mon_Exit
; ******

         JMP  (X_Vector)

; *******
LAC_To_PC
; *******

; called from Mon_Set_Register, Mon_Go and Mon_JSR
; as the first instruction. The carry flag was set from
; the routine Got_LAC if an error occured.
; Notice that the Bank, PCH and PCL values are stored
; high to low, reverse to the standard order.

; Bank, PCH and PCL are part of a list, that is used by
; the routines FAR_JMP and FAR_JSR of the operating system

         BCS  @error
         LDA  Long_AC
         STA  Bank+2
         LDA  Long_AC+1
         STA  Bank+1
         LDA  Long_AC+2
         STA  Bank
@error   RTS

; ********
LAC_To_LPC
; ********

         PHX
         LDX  #3
@loop    LDA  Long_AC,X
         STA  Long_PC,X
         DEX
         BPL  @loop
         PLX
         RTS

; ********
LAC_To_LCT
; ********

         PHX
         LDX  #3
@loop    LDA  Long_AC,X
         STA  Long_CT,X
         DEX
         BPL  @loop
         PLX
         RTS

; ********
LAC_To_LDA
; ********

         PHX
         LDX  #3
@loop    LDA  Long_AC,X
         STA  Long_DA,X
         DEX
         BPL  @loop
         PLX
         RTS

; **********
LAC_Plus_LCT
; **********

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

; ***********
LAC_Minus_LPC
; ***********

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

; *************
LAC_Compare_LPC
; *************

         PHX
         LDX  #252              ; use ZP wrap around
         SEC
@loop    LDA  Long_AC+4,X
         SBC  Long_PC+4,X
         INX
         BNE  @loop
         PLX
         RTS

; *****
Inc_LAC
; *****

         INW  Long_AC
         BNE  @return
         INW  Long_AC+2
@return  RTS

; *****
Dec_LAC
; *****

         LDA  Long_AC
         ORA  Long_AC+1
         BNE  @skip
         DEW  Long_AC+2
@skip    DEW  Long_AC
         RTS

; *****
Inc_LPC
; *****

         INW  Long_PC
         BNE  @return
         INW  Long_PC+2
@return  RTS

; *****
Dec_LDA
; *****

         LDA  Long_DA
         ORA  Long_DA+1
         BNE  @skip
         DEW  Long_DA+2
@skip    DEW  Long_DA
         RTS

; ***
Fetch
; ***

         PHZ
         TYA
         TAZ
         BBS7 Long_PC+3,@banked ; trigger banked access
         NOP                    ; use LDA  [Long_PC],Z
@banked  LDA  (Long_PC),Z
         PLZ
         AND  #$ff
         RTS

; ********
Mon_Memory
; ********

         JSR  Get_LAC           ; get 1st. parameter
         LDZ  #16               ; default row count
         BCS  @row              ; no address
         JSR  LAC_To_LPC        ; Long_PC = start address
         JSR  Get_LAC           ; Long_AC = end address
         BCS  @row              ; not given

         JSR  LAC_Minus_LPC     ; Long_CT = range
         LBCC Mon_Error         ; negative range -> error
         LDX  #4                ; 16 bytes / line
         BBR7 MODE_80,@shift
         DEX                    ;  8 bytes / line
@shift   LSR  Long_CT+1
         ROR  Long_CT
         DEX
         BNE  @shift
         LDZ  Long_CT           ; row count
         INZ

@row     JSR  STOP
         BEQ  @exit
         JSR  Dump_Row
         DEZ
         BNE  @row
@exit    JMP  Main

; ********
Print_Bits
; ********

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

; ******
Mon_Bits
; ******

         JSR  Get_LAC           ; get 1st. parameter
         BCS  @lab
         JSR  LAC_To_LPC        ; Long_PC = start address
@lab     JSR  Print_CR
         LDA  #WHITE
         STA  Long_DA+1

         LDX  #8
@row     PHX
         JSR  Hex_LPC
         LDZ  #0
@col     SEC
         LDA  #WHITE+LRED       ; toggle colour
         SBC  Long_DA+1
         STA  Long_DA+1
         JSR  CHROUT
         LDA  [Long_PC],Z
         JSR  Print_Bits
         CLC
         TZA
         ADC  #8
         TAZ
         CMP  #64
         BCC  @col
         JSR  Print_CR
         JSR  Inc_LPC
         PLX
         DEX
         BNE  @row
         JMP  Main

; **************
Mon_Set_Register
; **************

         JSR  Get_LAC           ; get 1st. parameter
         JSR  LAC_To_PC
         LDY  #3
@loop    JSR  Get_LAC
         BCS  @exit
         LDA  Long_AC
         STA  Bank,Y
         INY
         CPY  #9
         BCC  @loop
@exit    JMP  Main

; ************
Mon_Set_Memory
; ************

         JSR  Get_LAC           ; get 1st. parameter
         BCS  @exit
         JSR  LAC_To_LPC        ; Long_PC = row address
         LDZ  #0
@loop    JSR  Get_LAC
         BCS  @exit
         LDA  Long_AC
         BBS7 Long_PC+3,@banked ; trigger banked access
         NOP                    ; use STA  [Long_PC],Z
@banked  STA  (Long_PC),Z
         INZ
         CPZ  #16
         BBR7 MODE_80,@next
         CPZ  #8
@next    BCC  @loop

@exit    JSR  PRIMM
         .BYTE "\eO"
         .BYTE $91,$00
         JSR  Dump_Row
         JMP  Main

; ****
Mon_Go
; ****

         JSR  Get_LAC           ; get 1st. parameter
         JSR  LAC_To_PC
         LDX  SPL
         TXS
         JMP  JMPFAR

; *****
Mon_JSR
; *****

         JSR  Get_LAC           ; get 1st. parameter
         JSR  LAC_To_PC
         LDX  SPL
         TXS
         JSR  JSRFAR
         TSX
         STX  SPL
         JMP  Main

; **********
Dump_4_Bytes
; **********

         JSR  CHROUT            ; colour
@loop    BBS7 Long_PC+3,@banked ; trigger banked access
         NOP                    ; use LDA  [Long_PC],Z
@banked  LDA  (Long_PC),Z
         JSR  Print_Hex_Blank
         INZ
         TZA
         AND  #3
         BNE  @loop
         RTS

; **********
Dump_4_Chars
; **********

         LDY  #0
         STY  QTSW              ; disable quote mode
         JSR  CHROUT            ; colour
@loop    BBS7 Long_PC+3,@banked ; trigger banked access
         NOP                    ; use LDA  [Long_PC],Z
@banked  LDA  (Long_PC),Z
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

; ******
Dump_Row
; ******

         PHZ
         JSR  Print_CR
         LDA  #'>'
         JSR  CHROUT
         JSR  Hex_LPC

         LDZ  #0
         LDX  #2                ; 2 blocks in 80 columns
         BBR7 MODE_80,@loop
         DEX                    ; 1 block  in 40 columns
@loop    LDA  #LRED
         JSR  Dump_4_Bytes
         LDA  #WHITE
         JSR  Dump_4_Bytes
         DEX
         BNE  @loop

         JSR  PRIMM
         .BYTE $3a,$12,$00      ; : reverse on

         LDZ  #0
         LDX  #2                ; 4 blocks in 80 columns
         BBR7 MODE_80,@lchr
         DEX                    ; 2 blocks in 40 columns
@lchr    LDA  #LRED
         JSR  Dump_4_Chars
         LDA  #WHITE
         JSR  Dump_4_Chars
         DEX
         BNE  @lchr
         TZA
         JSR  Add_LPC
         PLZ
         RTS

; **********
Mon_Transfer
; **********

         JSR  Param_Range       ; Long_PC = source
         LBCS Mon_Error         ; Long_CT = count
         JSR  Get_LAC           ; Long_AC = target
         LBCS Mon_Error

         LDZ  #0
         JSR  LAC_Compare_LPC   ; target - source
         BCC  @forward

;        source < target: backward transfer

         JSR  LAC_Plus_LCT      ; Long_AC = end of target

@lpback  LDA  [Long_DA],Z       ; backward copy
         STA  [Long_AC],Z
         JSR  Dec_LDA
         JSR  Dec_LAC
         JSR  Dec_LCT
         BPL  @lpback
         JMP  Main

@forward LDA  [Long_PC],Z       ; forward copy
         STA  [Long_AC],Z
         JSR  Inc_LPC
         JSR  Inc_LAC
         JSR  Dec_LCT
         BPL  @forward
         JMP  Main

; *********
Mon_Compare
; *********

         JSR  Param_Range       ; Long_PC = source
         LBCS Mon_Error         ; Long_CT = count
         JSR  Get_LAC           ; Long_AC = target
         LBCS Mon_Error
         JSR  Print_CR
         LDZ  #0
@loop    LDA  [Long_PC],Z
         CMP  [Long_AC],Z
         BEQ  @laba
         JSR  Hex_LPC
@laba    JSR  Inc_LAC
         JSR  Inc_LPC
         JSR  Dec_LCT
         BPL  @loop
         JMP  Main

; ******
Mon_Hunt
; ******

         JSR  Param_Range       ; Long_PC = start
         LBCS Mon_Error         ; Long_CT = count
         LDY  #0
         JSR  Get_Char
         CMP  #APOSTR
         BNE  @bin
         JSR  Get_Char          ; string hunt
         CMP  #0
         LBEQ Mon_Error         ; null string

@lpstr   STA  Mon_Data,Y
         INY
         JSR  Get_Char
         BEQ  @hunt
         CPY  #32               ;max. string length
         BNE  @lpstr
         BRA  @hunt

@bin     JSR  Got_LAC
@lpbin   LDA  Long_AC
         STA  Mon_Data,Y
         INY
         JSR  Get_LAC
         BCS  @hunt
         CPY  #32               ;max. data length
         BNE  @lpbin

@hunt    STY  Long_DA           ; hunt length
         JSR  Print_CR

@lpstart LDY  #0
@lpins   JSR  Fetch
         CMP  Mon_Data,Y
         BNE  @next
         INY
         CPY  Long_DA
         BNE  @lpins
         JSR  Hex_LPC           ; match
@next    JSR  STOP
         LBEQ Main
         JSR  Inc_LPC
         JSR  Dec_LCT
         BPL  @lpstart
         JMP  Main

; *******
Load_Save
; *******

         LDY  Disk_Unit
         STY  FA
         LDY  #8
         STY  SA
         LDY  #0
         STY  BA
         STY  FNLEN
         STY  FNBANK
         STY  STATUS
         LDA  #>Mon_Data
         STA  FNADR+1
         LDA  #<Mon_Data
         STA  FNADR
@skip    JSR  Get_Char          ; skip blanks
         LBEQ Mon_Error
         CMP  #' '
         BEQ  @skip
         CMP  #QUOTE            ; must be quote
         LBNE Mon_Error

         LDX  Buf_Index
@copyfn  LDA  Buffer,X          ; copy filename
         BEQ  @do               ; no more input
         INX
         CMP  #QUOTE
         BEQ  @unit             ; end of filename
         STA  (FNADR),Y         ; store to filename
         INC  FNLEN
         INY
         CPY  #19               ; max = 16 plus prefix "@0:"
         BCC  @copyfn
         JMP  Mon_Error         ; filename too long

@unit    STX  Buf_Index         ; update read position
         JSR  Get_Char
         BEQ  @do               ; no more parameter
         JSR  Get_LAC
         BCS  @do
         LDA  Long_AC           ; unit #
         STA  FA
         JSR  Get_LAC
         BCS  @do
         JSR  LAC_To_LPC        ; Long_PC = start address
         STA  BA                ; Bank
         JSR  Get_LAC           ; Long_AC = end address + 1
         BCS  @load             ; no end address -> load/verify
         JSR  Print_CR
         LDX  Long_AC           ; X/Y = end address
         LDY  Long_AC+1
         LDA  VERCK             ; A = load/verify/save
         CMP  #'S'
         LBNE Mon_Error         ; must be Save
         LDA  #0
         STA  SA                ; set SA for PRG
         LDA  #Long_PC          ; Long_PC = start address
         JSR  SAVE
@exit    JMP  Main

@do      LDA  VERCK
         CMP  #'V'              ; Verify
         BEQ  @exec
         CMP  #'L'              ; Load
         LBNE Mon_Error
         LDA  #0                ; 0 = LOAD
@exec    JSR  LOAD              ; A == 0 : LOAD else VERIFY
         BBR4 STATUS,@exit
         LDA  VERCK
         LBEQ Mon_Error
         LBCS Main
         JSR  PRIMM
         .BYTE " ERROR",0
         JMP  Main

@load    LDX  Long_PC
         LDY  Long_PC+1
         LDA  #0                ; 0 = use X/Y as load address
         STA  SA                ; and ignore load address from file
         BRA  @do

; ******
Mon_Fill
; ******

         JSR  Param_Range       ; Long_PC = target
         LBCS Mon_Error         ; Long_CT = count
         JSR  Get_LAC           ; Long_AC = fill byte
         LBCS Mon_Error
         JSR  Print_CR
         LDZ  #0
@loop    LDA  Long_AC
         STA  [Long_PC],Z
         JSR  Inc_LPC
         JSR  Dec_LCT
         BPL  @loop
         JMP  Main

; **********
Mon_Assemble
; **********

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
@lpbit   LSR  A
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
         ASL  A
         ASL  A
         ASL  A
         ASL  A
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
         BBR5 Op_Flag,_error
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
         BEQ  @one             ; ->  one operand
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
         BBR6 Op_Flag,_bran1
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
         .BYTE 13,$91,"A \eQ",0
         JSR  Print_Code
         INC  Op_Size
         LDA  Op_Size
         JSR  Add_LPC

; print out command 'A' together with next address
; and put it into buffer too,
; for easy entry of next assembler instruction

         JSR  PRIMM
         .BYTE CR,"A ",0

         LDA  #'A'
         STA  Buffer
         LDA  #' '
         STA  Buffer+1
         LDY  #2
         LDX  #2                ; 6 digits
         LDA  Long_PC,X
         BNE  @auto
         DEX                    ; 4 digits
@auto    PHX
         LDA  Long_PC,X
         JSR  A_To_Hex
         STA  Buffer,Y
         JSR  CHROUT
         INY
         TXA
         STA  Buffer,Y
         JSR  CHROUT
         INY
         PLX
         DEX
         BPL  @auto

         LDA  #' '
         STA  Buffer,Y
         JSR  CHROUT
         INY
         TYA
         TAX
         JMP  Main_A

; ***********
Branch_Target
; ***********

         DEW  Long_AC
         DEC  A
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

; ********
Match_Mode
; ********

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

; ********
Mode_Index
; ********

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

; **********
Size_To_Mode
; **********

         LDA  Op_Len
         LSR  A
         ROR  A
         ROR  A
         ORA  Mode_Flags
         STA  Mode_Flags
         LDX  #0
         RTS

; *************
Mon_Disassemble
; *************

         JSR  Get_LAC           ; get 1st. parameter
         BCS  @nopar
         JSR  LAC_To_LPC        ; Long_PC = start address
         JSR  Get_LAC           ; Long_AC = end address
         BCC  range
@nopar   LDA  #32               ; disassemble 32 bytes
         STA  Long_CT
         BRA  @loop
range    JSR  LAC_Minus_LPC     ; Long_CT = range
         LBCC Mon_Error         ; -> negative

@loop    JSR  CR_Erase          ; prepare empty line
         JSR  STOP
         LBEQ Main
         JSR  Dis_Code          ; disassemble one line
         INC  Op_Size
         LDA  Op_Size
         JSR  Add_LPC           ; advance address
         LDA  Long_CT
         SEC
         SBC  Op_Size
         STA  Long_CT
         BCS  @loop
         JMP  Main

; ******
Dis_Code
; ******

         JSR  PRIMM
         .BYTE ". ",0

; ********
Print_Code
; ********

;        print 24 bit address of instruction

         JSR  Hex_LPC          ; 24 bit address

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
         ASL  A                 ; rotate into lower two bits
         ROL  A
         ROL  A
         STA  Op_Size           ; store
         BBR5 Op_Flag,@norm1
         INC  Op_Size
@norm1

;        print instruction and operand bytes

         LDY  #0
         LDA  #' '
         BBR4 Op_Flag,_blpr
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
         .BYTE "   ",0
         INY
         BRA  @lpfill

;        detect long branches

@long    LDA  #YELLOW
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
         ROL  A                 ; rotate letter into A
         DEY
         BNE  @lplet            ; next bit
         ADC  #$3f              ; add offset (C = 0)
         DEX
         BEQ  @lastc            ; 3rd. character
         TAZ                    ; remember
         JSR  CHROUT            ; and print it
         BRA  @lpmne            ; next letter

@lastc   BBR4 Op_Flag,_lbra     ; -> no Q
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
         BBS6 Op_Flag,_mne5     ; long branch

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
         ASL  A
         ROL  A
         ROL  A
         ROL  A
         ROL  A
         ORA  #'0'
         JSR  CHROUT
         BRA  @mne5

@mne4    JSR  Print_Blank
@mne5    JSR  Print_Blank
         LDA  #WHITE
         JSR  CHROUT

;        check for accumulator operand

         LDA  Op_Code
         LDX  #8
@lpaccu  DEX
         BMI  @oper
         CMP  ACCUMODE,X
         BNE  @lpaccu

         LDA  #'A'
         BBR4 Op_Flag,_accu
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

         BBR5 Op_Flag,_proper
         LDA  Long_AC+1
         JSR  Print_Hex         ; [$nn],Z
         LDA  #']'
         JSR  CHROUT
         BRA  @labf

@proper  LDY  Op_Size
         BBR7 Op_Flag,_lpoper
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

@labf    BBR4 Op_Flag,_comch    ; not a Q instruction
         LDA  Adr_Flags
         AND  #3
         CMP  #1
         BNE  @return           ; Q only with ,X

_comch   BBR2 Adr_Flags,@labg   ; , flag
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
         LSR  A
         ROR  A
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

; *****
Got_LAC
; *****

         DEC  Buf_Index

; *****
Get_LAC
; *****

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

; *********
Read_Number
; *********

         PHX
         PHY
         PHZ
         LDA  #0
         STA  Dig_Cnt               ; count columns read
         STA  Long_AC           ; clear result Long_AC
         STA  Long_AC+1
         STA  Long_AC+2
         STA  Long_AC+3

         JSR  Get_Glyph         ; get 1st. character
         BEQ  @exit
         CMP  #APOSTR           ; character entry 'C
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
         ROL  A
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

; *****
Hex_LPC
; *****

         LDX  Long_PC+3
         BEQ  @laba
         LDA  #YELLOW
         JSR  CHROUT
         TXA
         JSR  Print_Hex
         LDA  Long_PC+2
         JSR  Print_Hex
         LDA  #WHITE
         JSR  CHROUT
         BRA  @labb
@laba    LDA  Long_PC+2
         BEQ  @labb
         JSR  Print_Hex
@labb    LDX  Long_PC+1
         LDA  Long_PC

; **********
Print_XA_Hex
; **********

         PHA
         TXA
         JSR  Print_Hex
         PLA

; *************
Print_Hex_Blank
; *************

         JSR  Print_Hex

; *********
Print_Blank
; *********

         LDA  #' '
         JMP  CHROUT

; ******
Print_CR
; ******

         LDA  #13
         JMP  CHROUT

; ******
CR_Erase
; ******

         JSR  PRIMM
         .BYTE "\r\eQ",0
         RTS

; *******
Print_Hex
; *******

         PHX
         JSR  A_To_Hex
         JSR  CHROUT
         TXA
         PLX
         JMP  CHROUT

; ******
A_To_Hex
; ******

         PHA
         JSR  @nibble
         TAX
         PLA
         LSR  A
         LSR  A
         LSR  A
         LSR  A

@nibble  AND  #15
         CMP  #10
         BCC  @lab
         ADC  #6
@lab     ADC  #'0'
         RTS

; *******
Get_Glyph
; *******
         PHX
         LDA  #' '
@loop    LDX  Buf_Index
         INC  Buf_Index
         CMP  Buffer,X
         BEQ  @loop
         PLX                    ; fall through

; ******
Got_Char
; ******

         DEC  Buf_Index

; ******
Get_Char
; ******

         PHX
         LDX  Buf_Index
         INC  Buf_Index
         LDA  Buffer,X
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


; *****
Dec_LCT
; *****

         LDA  Long_CT
         ORA  Long_CT+1
         BNE  @skip
         DEW  Long_CT+2
@skip    DEW  Long_CT
         LDA  Long_CT+3         ; set N flag
         RTS

; *****
Add_LPC
; *****

         CLC
         ADC  Long_PC
         STA  Long_PC
         BCC  @return

; **********
Inc_LPC_Page
; **********

         INC  Long_PC+1
         BNE  @return
         INW  Long_PC+2
@return  RTS

; *********
Param_Range
; *********

; read two (address) parameters

; Long_CT = difference (2nd. minus 1st.)
; Long_PC = 1st. parameter
; Long_DA = 2nd. parameter

; carry on exit flags error

         JSR  Get_LAC           ; get 1st. parameter
         BCS  @error
         JSR  LAC_To_LPC        ; Long_PC = 1st. address
         JSR  Get_LAC
         BCS  @error
         JSR  LAC_To_LDA        ; Long_DA = 2nd. address
         JSR  LAC_Minus_LPC     ; Long_CT = range
         BCC  @error
         CLC
         RTS
@error   SEC
         RTS

; *******
Converter
; *******

         LDX  #0
         STX  Buf_Index
         JSR  Get_LAC
         LBCS Mon_Error
         LDX  #0
@loop    PHX
         JSR  CR_Erase
         LDA  Cons_Prefix,X
         JSR  CHROUT
         TXA
         ASL  A
         TAX
         JSR  (Conv_Tab,X)
         PLX
         INX
         CPX  #4
         BCC  @loop
         JMP  Main

Conv_Tab !word Print_Hexval
         !word Print_Decimal
         !word Print_Octal
         !word Print_Dual

; ********
Print_Dual
; ********

         LDX  #24               ; digits
         LDY  #1                ; bits per digit
         BRA  Print_Octal_entry

; *********
Print_Octal
; *********

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
         ROL  A
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

; **********
Print_Hexval
; **********

        JSR  LAC_To_LPC
        LDA  #0
        STA  Long_PC+3
        BRA  Print_BCD

; ***********
Print_Decimal
; ***********

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

; *******
Print_BCD
; *******

         LDA  #0
         STA  Long_CT
         LDZ  #'0'
         LDY  #8                ; max. digits
@loopa   LDX  #3                ; 4 bytes
         LDA  #0
@loopb   ASL  Long_PC
         ROL  Long_PC+1
         ROW  Long_PC+2
         ROL  A
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
Mon_Disk
; ******

         DEC  Buf_Index
         LDX  Buf_Index
         LDA  Buffer,X
         BEQ  Print_Disk_Status
         STA  Long_CT           ; dir marker
         LDY  #$ff              ; SA = 15
         CMP  #'$'
         BNE  @lab
         LDY  #$f0              ; SA =  0
@lab     LDA  FA
         JSR  LISTEN
         TYA                    ; SA
         JSR  SECOND
@loop    LDA  Buffer,X
         BEQ  @close
         JSR  CIOUT
         INX
         BRA  @loop
@close   JSR  UNLSN
         LDA  Long_CT
         CMP  #'$'
         BNE  Print_Disk_Status
         JMP  Directory

; *************
Get_Disk_Status
; *************

         LDA  FA
         JSR  TALK
         LDA  #$6f
         JSR  TKSA
         JSR  ACPTR             ; 1st. digit
         STA  Disk_Msg
         ASL  A
         ASL  A
         ASL  A
         ASL  A
         STA  Disk_Status       ; BCD
         JSR  ACPTR             ; 2nd. digit
         STA  Disk_Msg+1
         AND  #15
         ORA  Disk_Status
         STA  Disk_Status       ; complete BCD number

         LDY  #1
@loop    INY
         JSR  ACPTR
         STA  Disk_Msg,Y
         CMP  #' '
         BCS  @loop
         LDA  #0
         STA  Disk_Msg,Y
         JSR  UNTALK
         LDA  Disk_Status
         RTS

; ***************
Print_Disk_Status
; ***************

         JSR  Get_Disk_Status

; ************
Print_Disk_Msg
; ************

         JSR  Print_CR
         LDY  #0
@loop    LDA  Disk_Msg,Y
         BEQ  @exit
         JSR  CHROUT
         INY
         BRA  @loop
@exit    JMP  Print_CR

; @[u] : print disk status for unit u
; @[u],$[=pattern] : print directory
; @[u],command : send disk command and read status
; @[u],U1 mem track startsec [endsec] : read  disk sector(s)
; @[u],U2 mem track startsec [endsec] : write disk sector(s)

; *****
Mon_DOS
; *****

         LDX  #8                ; default device
         JSR  Get_Glyph
         CMP  #'0'
         BCC  @unit
         CMP  #':'
         BCS  @unit
         DEC  Buf_Index
         JSR  Read_Number
         BCS  @unit
         LDX  Long_AC           ; unit
         CPX  #4
         LBCC Mon_Error
         CPX  #31
         LBCS Mon_Error
@unit    STX  FA
         DEC  Buf_Index
@next    JSR  Get_Char
         BEQ  @status           ; only @u
         CMP  #' '
         BEQ  @next
         CMP  #','
         BEQ  @next
         CMP  #'U'              ; sector read/write
         BEQ  DOS_U
@status  JSR  Mon_Disk
         JMP  Main

; *******
Directory
; *******

         LDA  FA
         JSR  TALK
         LDA  #$60
         STA  SA
         JSR  TKSA
         LDA  #0
         STA  STATUS

         LDZ  #6                ; load address, pseudo link, pseudo number
@loopb   TAX                    ; X = previous byte
         JSR  ACPTR             ; A = current  byte
         LDY  STATUS
         BNE  @exit
         DEZ
         BNE  @loopb            ; X/A = last read word

         STX  Long_AC
         STA  Long_AC+1
         STZ  Long_AC+2
         STZ  Long_AC+3
         JSR  Print_Decimal     ; file size
         JSR  Print_Blank

@loopc   JSR  ACPTR             ; print file entry
         BEQ  @cr
         LDY  STATUS
         BNE  @exit
         JSR  CHROUT
         BCC  @loopc

@cr      JSR  Print_CR
         JSR  STOP
         BEQ  @exit
         LDZ  #4
         BRA  @loopb            ; next file
@exit    JMP  UNTALK

; ***
DOS_U
; ***

         JSR  Get_Char
         CMP  #'1'            ; U1: read
         LBCC Mon_Error
         CMP  #'3'            ; U2: write
         LBCS Mon_Error
         STA  Mon_Data+1      ; U type
         INC  Buf_Index
         JSR  Get_LAC
         LBCS Mon_Error
         JSR  LAC_To_LPC      ; Long_PC = memory address

         JSR  Get_LAC
         LBCS Mon_Error
         LDA  Long_AC
         STA  Disk_Track

         JSR  Get_LAC
         LBCS Mon_Error
         LDA  Long_AC
         STA  Disk_Sector

         JSR  Get_LAC
         JSR  LAC_To_LCT        ; Long_CT = sector count
         DEW  Long_CT           ; Long_CT = -1 for single

         JSR  Open_Disk_Buffer

@loop    LDA  Mon_Data+1
         LSR  A
         BEQ  @write
         JSR  Find_next_Sector
         BNE  @error
         JSR  Read_Sector
         BRA  @next

@write   JSR  Write_Sector
         JSR  Find_next_Sector
         BNE  @error

@next    JSR  Inc_LPC_Page
         INC  Disk_Sector
         DEW  Long_CT
         BPL  @loop

@error   JSR  Print_Disk_Msg
         JSR  Close_Disk_Buffer
         JMP  Main

; **************
Find_next_Sector
; **************

         JSR  Build_U_String
         JSR  Send_Disk_Command
         JSR  Get_Disk_Status
         BEQ  @return           ; OK
         CMP  #$66              ; illegal track or sector
         BNE  @error            ; error
         LDA  #0
         STA  Disk_Sector
         INC  Disk_Track        ; try next track
         JSR  Build_U_String
         JSR  Send_Disk_Command
         JSR  Get_Disk_Status
         BEQ  @return
@error   JSR  Print_Disk_Msg
         LDA  Disk_Status
@return  RTS

; ******************
Open_Command_Channel
; ******************

         LDA  FA
         JSR  LISTEN
         LDA  #$ff
         JSR  SECOND
         LDY  #0
         STY  STATUS
         RTS

; ******
Reset_BP
; ******

         JSR  Open_Command_Channel
@loop    LDA  BP_ZERO,Y
         BEQ  @end
         JSR  CIOUT
         INY
         BRA  @loop
@end     JMP  UNLSN

; ***************
Send_Disk_Command
; ***************

         JSR  Open_Command_Channel
@loop    LDA  Mon_Data,Y
         BEQ  @end
         JSR  CIOUT
         INY
         BRA  @loop
@end     JMP  UNLSN

; *********
Read_Sector
; *********

         LDA  FA
         JSR  TALK
         LDA  #$69              ; SA = 9
         JSR  TKSA
         LDZ  #0
         STZ  STATUS
@loop    JSR  ACPTR
         STA  [Long_PC],Z
         INZ
         BNE  @loop
         JMP  UNTALK

; **********
Write_Sector
; **********

         JSR  Reset_BP          ; reset disk buffer pointer
         LDA  FA
         JSR  LISTEN
         LDA  #$69              ; SA = 9
         JSR  TKSA
         LDZ  #0
         STZ  STATUS
@loop    LDA  [Long_PC],Z
         JSR  CIOUT
         INZ
         BNE  @loop
         JSR  UNLSN
         RTS

; ****
Set_TS
; ****

; Input  A = track or sector
;        X = string index

@100      CMP  #100
          BCC  @10
          INC  Mon_Data,X
          SBC  #100
          BRA  @100
@10       CMP  #10
          BCC  @1
          INC  Mon_Data+1,X
          SBC  #10
          BRA  @10
@1        ORA  #'0'
          STA  Mon_Data+2,X
          RTS

; @[u],U1 mem track startsec [endsec] : read  disk sector(s)

; U1:CHANNEL DRIVE TRACK SECTOR

; ************
Build_U_String
; ************

         LDX  #14
@loop    LDA  U1,X
         STA  Mon_Data,X
         DEX
         CPX  #2
         BCS  @loop
         LDA  #'U'
         STA  Mon_Data
         LDA  Disk_Track
         LDX  #7
         JSR  Set_TS
         LDA  Disk_Sector
         LDX  #11
         JMP  Set_TS

; **************
Open_Disk_Buffer
; **************

         LDA  #0
         STA  STATUS
         LDA  FA
         JSR  LISTEN          ; open fa,9,"#"
         LDA  #$f9            ; sa = 9
         JSR  SECOND
         LDA  #'#'            ; open buffer
         JSR  CIOUT
         JSR  UNLSN
         LDA  STATUS
         LBNE Print_Disk_Status
         RTS

; ***************
Close_Disk_Buffer
; ***************

         LDA  #0
         STA  STATUS
         LDA  FA
         JSR  LISTEN          ; open fa,9,"#"
         LDA  #$e9            ; sa = 9
         JSR  SECOND
         JSR  UNLSN
         LDA  STATUS
         LBNE Print_Disk_Status
         RTS


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
               
!set ENC_A = %00010
!set ENC_B = %00011
!set ENC_C = %00100
!set ENC_D = %00101
!set ENC_E = %00110
!set ENC_F = %00111
!set ENC_G = %01000
!set ENC_H = %01001
!set ENC_I = %01010
!set ENC_J = %01011
!set ENC_K = %01100
!set ENC_L = %01101
!set ENC_M = %01110
!set ENC_N = %01111
!set ENC_O = %10000
!set ENC_P = %10001
!set ENC_Q = %10010
!set ENC_R = %10011
!set ENC_S = %11000
!set ENC_T = %11001
!set ENC_U = %11010
!set ENC_V = %11011
!set ENC_W = %11100
!set ENC_X = %11101
!set ENC_Y = %11110
!set ENC_Z = %11111

!set ENC_ADC = ENC_A * 64 * 64 + ENC_D * 64 + ENC_C
!set ENC_AND = ENC_A * 64 * 64 + ENC_N * 64 + ENC_D
!set ENC_ASL = ENC_A * 64 * 64 + ENC_S * 64 + ENC_L
!set ENC_ASR = ENC_A * 64 * 64 + ENC_S * 64 + ENC_R
!set ENC_ASW = ENC_A * 64 * 64 + ENC_S * 64 + ENC_W
!set ENC_BBR = ENC_B * 64 * 64 + ENC_B * 64 + ENC_R
!set ENC_BBS = ENC_B * 64 * 64 + ENC_B * 64 + ENC_S
!set ENC_BCC = ENC_B * 64 * 64 + ENC_C * 64 + ENC_C
!set ENC_BCS = ENC_B * 64 * 64 + ENC_C * 64 + ENC_S
!set ENC_BEQ = ENC_B * 64 * 64 + ENC_E * 64 + ENC_Q
!set ENC_BIT = ENC_B * 64 * 64 + ENC_I * 64 + ENC_T
!set ENC_BMI = ENC_B * 64 * 64 + ENC_M * 64 + ENC_I
!set ENC_BNE = ENC_B * 64 * 64 + ENC_N * 64 + ENC_E
!set ENC_BPL = ENC_B * 64 * 64 + ENC_P * 64 + ENC_L
!set ENC_BRA = ENC_B * 64 * 64 + ENC_R * 64 + ENC_A
!set ENC_BRK = ENC_B * 64 * 64 + ENC_R * 64 + ENC_K
!set ENC_BSR = ENC_B * 64 * 64 + ENC_S * 64 + ENC_R
!set ENC_BVC = ENC_B * 64 * 64 + ENC_V * 64 + ENC_C
!set ENC_BVS = ENC_B * 64 * 64 + ENC_V * 64 + ENC_S
!set ENC_CLC = ENC_C * 64 * 64 + ENC_L * 64 + ENC_C
!set ENC_CLD = ENC_C * 64 * 64 + ENC_L * 64 + ENC_D
!set ENC_CLE = ENC_C * 64 * 64 + ENC_L * 64 + ENC_E
!set ENC_CLI = ENC_C * 64 * 64 + ENC_L * 64 + ENC_I
!set ENC_CLV = ENC_C * 64 * 64 + ENC_L * 64 + ENC_V
!set ENC_CMP = ENC_C * 64 * 64 + ENC_M * 64 + ENC_P
!set ENC_CPX = ENC_C * 64 * 64 + ENC_P * 64 + ENC_X
!set ENC_CPY = ENC_C * 64 * 64 + ENC_P * 64 + ENC_Y
!set ENC_CPZ = ENC_C * 64 * 64 + ENC_P * 64 + ENC_Z
!set ENC_DEC = ENC_D * 64 * 64 + ENC_E * 64 + ENC_C
!set ENC_DEW = ENC_D * 64 * 64 + ENC_E * 64 + ENC_W
!set ENC_DEX = ENC_D * 64 * 64 + ENC_E * 64 + ENC_X
!set ENC_DEY = ENC_D * 64 * 64 + ENC_E * 64 + ENC_Y
!set ENC_DEZ = ENC_D * 64 * 64 + ENC_E * 64 + ENC_Z
!set ENC_EOR = ENC_E * 64 * 64 + ENC_O * 64 + ENC_R
!set ENC_INC = ENC_I * 64 * 64 + ENC_N * 64 + ENC_C
!set ENC_INW = ENC_I * 64 * 64 + ENC_N * 64 + ENC_W
!set ENC_INX = ENC_I * 64 * 64 + ENC_N * 64 + ENC_X
!set ENC_INY = ENC_I * 64 * 64 + ENC_N * 64 + ENC_Y
!set ENC_INZ = ENC_I * 64 * 64 + ENC_N * 64 + ENC_Z
!set ENC_JMP = ENC_J * 64 * 64 + ENC_M * 64 + ENC_P
!set ENC_JSR = ENC_J * 64 * 64 + ENC_S * 64 + ENC_R
!set ENC_LDA = ENC_L * 64 * 64 + ENC_D * 64 + ENC_A
!set ENC_LDX = ENC_L * 64 * 64 + ENC_D * 64 + ENC_X
!set ENC_LDY = ENC_L * 64 * 64 + ENC_D * 64 + ENC_Y
!set ENC_LDZ = ENC_L * 64 * 64 + ENC_D * 64 + ENC_Z
!set ENC_LSR = ENC_L * 64 * 64 + ENC_S * 64 + ENC_R
!set ENC_MAP = ENC_M * 64 * 64 + ENC_A * 64 + ENC_P
!set ENC_NEG = ENC_N * 64 * 64 + ENC_E * 64 + ENC_G
!set ENC_NOP = ENC_N * 64 * 64 + ENC_O * 64 + ENC_P
!set ENC_ORA = ENC_O * 64 * 64 + ENC_R * 64 + ENC_A
!set ENC_PHA = ENC_P * 64 * 64 + ENC_H * 64 + ENC_A
!set ENC_PHP = ENC_P * 64 * 64 + ENC_H * 64 + ENC_P
!set ENC_PHW = ENC_P * 64 * 64 + ENC_H * 64 + ENC_W
!set ENC_PHX = ENC_P * 64 * 64 + ENC_H * 64 + ENC_X
!set ENC_PHY = ENC_P * 64 * 64 + ENC_H * 64 + ENC_Y
!set ENC_PHZ = ENC_P * 64 * 64 + ENC_H * 64 + ENC_Z
!set ENC_PLA = ENC_P * 64 * 64 + ENC_L * 64 + ENC_A
!set ENC_PLP = ENC_P * 64 * 64 + ENC_L * 64 + ENC_P
!set ENC_PLX = ENC_P * 64 * 64 + ENC_L * 64 + ENC_X
!set ENC_PLY = ENC_P * 64 * 64 + ENC_L * 64 + ENC_Y
!set ENC_PLZ = ENC_P * 64 * 64 + ENC_L * 64 + ENC_Z
!set ENC_RMB = ENC_R * 64 * 64 + ENC_M * 64 + ENC_B
!set ENC_ROL = ENC_R * 64 * 64 + ENC_O * 64 + ENC_L
!set ENC_ROR = ENC_R * 64 * 64 + ENC_O * 64 + ENC_R
!set ENC_ROW = ENC_R * 64 * 64 + ENC_O * 64 + ENC_W
!set ENC_RTI = ENC_R * 64 * 64 + ENC_T * 64 + ENC_I
!set ENC_RTS = ENC_R * 64 * 64 + ENC_T * 64 + ENC_S
!set ENC_SBC = ENC_S * 64 * 64 + ENC_B * 64 + ENC_C
!set ENC_SEC = ENC_S * 64 * 64 + ENC_E * 64 + ENC_C
!set ENC_SED = ENC_S * 64 * 64 + ENC_E * 64 + ENC_D
!set ENC_SEE = ENC_S * 64 * 64 + ENC_E * 64 + ENC_E
!set ENC_SEI = ENC_S * 64 * 64 + ENC_E * 64 + ENC_I
!set ENC_SMB = ENC_S * 64 * 64 + ENC_M * 64 + ENC_B
!set ENC_STA = ENC_S * 64 * 64 + ENC_T * 64 + ENC_A
!set ENC_STX = ENC_S * 64 * 64 + ENC_T * 64 + ENC_X
!set ENC_STY = ENC_S * 64 * 64 + ENC_T * 64 + ENC_Y
!set ENC_STZ = ENC_S * 64 * 64 + ENC_T * 64 + ENC_Z
!set ENC_TAB = ENC_T * 64 * 64 + ENC_A * 64 + ENC_B
!set ENC_TAX = ENC_T * 64 * 64 + ENC_A * 64 + ENC_X
!set ENC_TAY = ENC_T * 64 * 64 + ENC_A * 64 + ENC_Y
!set ENC_TAZ = ENC_T * 64 * 64 + ENC_A * 64 + ENC_Z
!set ENC_TBA = ENC_T * 64 * 64 + ENC_B * 64 + ENC_A
!set ENC_TRB = ENC_T * 64 * 64 + ENC_R * 64 + ENC_B
!set ENC_TSB = ENC_T * 64 * 64 + ENC_S * 64 + ENC_B
!set ENC_TSX = ENC_T * 64 * 64 + ENC_S * 64 + ENC_X
!set ENC_TSY = ENC_T * 64 * 64 + ENC_S * 64 + ENC_Y
!set ENC_TXA = ENC_T * 64 * 64 + ENC_X * 64 + ENC_A
!set ENC_TXS = ENC_T * 64 * 64 + ENC_X * 64 + ENC_S
!set ENC_TYA = ENC_T * 64 * 64 + ENC_Y * 64 + ENC_A
!set ENC_TYS = ENC_T * 64 * 64 + ENC_Y * 64 + ENC_S
!set ENC_TZA = ENC_T * 64 * 64 + ENC_Z * 64 + ENC_A
		 

; ***
MNE_L
; ***

         .BYTE >"ADC"
         .BYTE >"AND"
         .BYTE >"ASL"
         .BYTE >"ASR"
         .BYTE >"ASW"
         .BYTE >"BBR"
         .BYTE >"BBS"
         .BYTE >"BCC"
         .BYTE >"BCS"
         .BYTE >"BEQ"
         .BYTE >"BIT"
         .BYTE >"BMI"
         .BYTE >"BNE"
         .BYTE >"BPL"
         .BYTE >"BRA"
         .BYTE >"BRK"
         .BYTE >"BSR"
         .BYTE >"BVC"
         .BYTE >"BVS" 
         .BYTE >"CLC"
         .BYTE >"CLD"
         .BYTE >"CLE"
         .BYTE >"CLI"
         .BYTE >"CLV"
         .BYTE >"CMP"
         .BYTE >"CPX"
         .BYTE >"CPY"
         .BYTE >"CPZ"
         .BYTE >"DEC"
         .BYTE >"DEW"
         .BYTE >"DEX"
         .BYTE >"DEY"
         .BYTE >"DEZ"
         .BYTE >"EOR"
         .BYTE >"INC"
         .BYTE >"INW"
         .BYTE >"INX"
         .BYTE >"INY"
         .BYTE >"INZ"
         .BYTE >"JMP"
         .BYTE >"JSR"
         .BYTE >"LDA"
         .BYTE >"LDX"
         .BYTE >"LDY"
         .BYTE >"LDZ"
         .BYTE >"LSR"
         .BYTE >"MAP"
         .BYTE >"NEG"
         .BYTE >"NOP"
         .BYTE >"ORA"
         .BYTE >"PHA"
         .BYTE >"PHP"
         .BYTE >"PHW"
         .BYTE >"PHX"
         .BYTE >"PHY"
         .BYTE >"PHZ"
         .BYTE >"PLA"
         .BYTE >"PLP"
         .BYTE >"PLX"
         .BYTE >"PLY"
         .BYTE >"PLZ"
         .BYTE >"RMB"
         .BYTE >"ROL"
         .BYTE >"ROR"
         .BYTE >"ROW"
         .BYTE >"RTI"
         .BYTE >"RTS"
         .BYTE >"SBC"
         .BYTE >"SEC"
         .BYTE >"SED"
         .BYTE >"SEE"
         .BYTE >"SEI"
         .BYTE >"SMB"
         .BYTE >"STA"
         .BYTE >"STX"
         .BYTE >"STY"
         .BYTE >"STZ"
         .BYTE >"TAB"
         .BYTE >"TAX"
         .BYTE >"TAY"
         .BYTE >"TAZ"
         .BYTE >"TBA"
         .BYTE >"TRB"
         .BYTE >"TSB"
         .BYTE >"TSX"
         .BYTE >"TSY"
         .BYTE >"TXA"
         .BYTE >"TXS"
         .BYTE >"TYA"
         .BYTE >"TYS"
         .BYTE >"TZA"

; ***
MNE_R
; ***

         .BYTE <"ADC" ; 00
         .BYTE <"AND" ; 01
         .BYTE <"ASL" ; 02
         .BYTE <"ASR" ; 03
         .BYTE <"ASW" ; 04
         .BYTE <"BBR" ; 05
         .BYTE <"BBS" ; 06
         .BYTE <"BCC" ; 07
         .BYTE <"BCS" ; 08
         .BYTE <"BEQ" ; 09
         .BYTE <"BIT" ; 0a
         .BYTE <"BMI" ; 0b
         .BYTE <"BNE" ; 0c
         .BYTE <"BPL" ; 0d
         .BYTE <"BRA" ; 0e
         .BYTE <"BRK" ; 0f
         .BYTE <"BSR" ; 10
         .BYTE <"BVC" ; 11
         .BYTE <"BVS" ; 12
         .BYTE <"CLC" ; 13
         .BYTE <"CLD" ; 14
         .BYTE <"CLE" ; 15
         .BYTE <"CLI" ; 16
         .BYTE <"CLV" ; 17
         .BYTE <"CMP" ; 18
         .BYTE <"CPX" ; 19
         .BYTE <"CPY" ; 1a
         .BYTE <"CPZ" ; 1b
         .BYTE <"DEC" ; 1c
         .BYTE <"DEW" ; 1d
         .BYTE <"DEX" ; 1e
         .BYTE <"DEY" ; 1f
         .BYTE <"DEZ"
         .BYTE <"EOR"
         .BYTE <"INC"
         .BYTE <"INW"
         .BYTE <"INX"
         .BYTE <"INY"
         .BYTE <"INZ"
         .BYTE <"JMP"
         .BYTE <"JSR"
         .BYTE <"LDA"
         .BYTE <"LDX"
         .BYTE <"LDY"
         .BYTE <"LDZ"
         .BYTE <"LSR"
         .BYTE <"MAP"
         .BYTE <"NEG"
         .BYTE <"NOP"
         .BYTE <"ORA"
         .BYTE <"PHA"
         .BYTE <"PHP"
         .BYTE <"PHW"
         .BYTE <"PHX"
         .BYTE <"PHY"
         .BYTE <"PHZ"
         .BYTE <"PLA"
         .BYTE <"PLP"
         .BYTE <"PLX"
         .BYTE <"PLY"
         .BYTE <"PLZ"
         .BYTE <"RMB"
         .BYTE <"ROL"
         .BYTE <"ROR"
         .BYTE <"ROW"
         .BYTE <"RTI"
         .BYTE <"RTS"
         .BYTE <"SBC"
         .BYTE <"SEC"
         .BYTE <"SED"
         .BYTE <"SEE"
         .BYTE <"SEI"
         .BYTE <"SMB"
         .BYTE <"STA"
         .BYTE <"STX"
         .BYTE <"STY"
         .BYTE <"STZ"
         .BYTE <"TAB"
         .BYTE <"TAX"
         .BYTE <"TAY"
         .BYTE <"TAZ"
         .BYTE <"TBA"
         .BYTE <"TRB"
         .BYTE <"TSB"
         .BYTE <"TSX"
         .BYTE <"TSY"
         .BYTE <"TXA"
         .BYTE <"TXS"
         .BYTE <"TYA"
         .BYTE <"TYS"
         .BYTE <"TZA"

; *******
MNE_Index
; *******

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

; ***
BRAIN
; ***

;              index values for branch mnemonics

;              BCC BCS BEQ BMI BNE BPL BRA BSR BVC BVS
         !byte $07,$08,$09,$0b,$0c,$0d,$0e,$10,$11,$12

; *****
LEN_ADM
; *****

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

 ( %11...... BBR BBS)

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

; ****
ADMODE
; ****

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

;              ASL INC ROL DEC LSR ROR NEG ASR
ACCUMODE !byte $0a,$1a,$2a,$3a,$4a,$6a,$42,$43

Num_Base !byte 16,10, 8, 2 ; hex, dec, oct, bin
Num_Bits !byte  4, 3, 3, 1 ; hex, dec, oct, bin

Index_Char .BYTE "XYZ"

;                0123456789abcd
U1        .BYTE "U1:9 0 000 000",0 ; channel 9, drive, track, sector
BP_ZERO   .BYTE "B-P 9 0",0        ; set buffer pointer to 0

; ******
Reg_Text
; ******
         JSR  PRIMM
         .BYTE "\r    PC   SR AC XR YR ZR BP  SP  NVEBDIZC\r; \eQ",0
         RTS

; ******
Mon_Help
; ******
   JSR PRIMM

   .BYTE LRED,"A",WHITE,"SSEMBLE     - A ADDRESS MNEMONIC OPERAND",CR
   .BYTE LRED,"B",WHITE,"ITMAPS      - B [FROM [TO]]",CR
   .BYTE LRED,"C",WHITE,"OMPARE      - C FROM TO WITH",CR
   .BYTE LRED,"D",WHITE,"ISASSEMBLE  - D [FROM [TO]]",CR
   .BYTE LRED,"F",WHITE,"ILL         - F FROM TO FILLBYTE",CR
   .BYTE LRED,"G",WHITE,"O           - G [ADDRESS]",CR
   .BYTE LRED,"H",WHITE,"UNT         - H FROM TO (STRING OR BYTES)",CR
   .BYTE LRED,"J",WHITE,"SR          - J ADDRESS",CR
   .BYTE LRED,"L",WHITE,"OAD         - L FILENAME [UNIT [ADDRESS]]",CR
   .BYTE LRED,"M",WHITE,"EMORY       - M [FROM [TO]]",CR
   .BYTE LRED,"R",WHITE,"EGISTERS    - R",CR
   .BYTE LRED,"S",WHITE,"AVE         - S FILENAME UNIT FROM TO",CR
   .BYTE LRED,"T",WHITE,"RANSFER     - T FROM TO TARGET",CR
   .BYTE LRED,"V",WHITE,"ERIFY       - V FILENAME [UNIT [ADDRESS]]",CR
   .BYTE "E",LRED,"X",WHITE,"IT         - X",CR
   .BYTE LRED,".",WHITE,"<DOT>       - . ADDRESS MNEMONIC OPERAND",CR
   .BYTE LRED,">",WHITE,"<GREATER>   - > ADDRESS BYTE SEQUENCE",CR
   .BYTE LRED,";",WHITE,"<SEMICOLON> - ; REGISTER CONTENTS",CR
   .BYTE LRED,"@",WHITE,"DOS         - @ [DOS COMMAND]",CR
   .BYTE LRED,"?",WHITE,"HELP        - ?",CR
   .BYTE 0
   JMP Main

}
