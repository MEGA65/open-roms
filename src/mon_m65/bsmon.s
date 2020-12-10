; *******************************
; * BSM = Bit Shifter's Monitor *
; * for The MEGA65  10-Dec_2020 *
; *******************************

!ifdef CONFIG_DEV_BSMON {


; *************
; * Constants *
; *************

WHITE  = $05
YELLOW = $9e
LRED   = $96

CR     = $0d
REV    = $12
CRIGHT = $1d
QUOTE  = $22
APOSTR = $27

; ************************************************
; * Register storage for JMPFAR and JSRFAR calls *
; ************************************************

Bank       =  2
PCH        =  3
PCL        =  4
SR         =  5
AC         =  6
XR         =  7
YR         =  8
ZR         =  9

; *************************************
; * Used direct (zero) page addresses *
; *************************************

BP         = 10
SPH        = 11
SPL        = 12

; following variables overlap with the BASIC floating point area

; $59 - $5d : temporary floating point accumulator
; $5e - $62 : temporary floating point accumulator
; $63 - $69 : primary   floating point accumulator
; $6a - $6f : secondary floating point accumulator

; A set of 32 bit variables also used as 32 bit pointer

& = $59

Long_AC    .BSS 4  ; 32 bit accumulator
Long_CT    .BSS 4  ; 32 bit counter
Long_PC    .BSS 4  ; 32 bit program counter
Long_DA    .BSS 4  ; 32 bit data pointer

; Flags are used in BBR BBS instructions

Adr_Flags  .BSS 1
Mode_Flags .BSS 1
Op_Code    .BSS 1
Op_Flag    .BSS 1  ; 7: two operands
                   ; 6: long branch
                   ; 5: 32 bit address
                   ; 4: Q register
Op_Size    .BSS 1
Dig_Cnt    .BSS 1
Buf_Index  .BSS 1

; operating system variables


STATUS     = $90
VERCK      = $93
FNLEN      = $b7
SA         = $b9
FA         = $ba
FNADR      = $bb
BA         = $bd
FNBANK     = $be

NDX        = $d0        ; length of keyboard buffer
MODE_80    = $d7        ; 80 column / 40 volumn flag

B_Margin   = $e4        ; SCBOT  default = 24
T_Margin   = $e5        ; SCTOP  default =  0
L_Margin   = $e6        ; SCLF   default =  0
R_Margin   = $e7        ; SCRT   default = 39 or 79

QTSW       = $f4        ; Quote switch

Buffer     = $0200      ; input buffer

IIRQ       = $0314
IBRK       = $0316
EXMON      = $032e

& = $400                ; bottom of BASIC runtime stack
                        ; should be a safe space
X_Vector    .BSS  2     ; exit vector (ROM version dependent)
Ix_Mne      .BSS  1     ; index to mnemonics table
Op_Mne      .BSS  3     ; 3 bytes for mnemonic
Op_Ix       .BSS  1     ; type of constant
Op_Len      .BSS  1     ; length of operand
Disk_Unit   .BSS  1     ; unit = device
Disk_Track  .BSS  1     ; logical track  1 -> 255
Disk_Sector .BSS  1     ; logical sector 0 -> 255
Disk_Status .BSS  1     ; BCD value of status

Mon_Data    .BSS 40     ; buffer for hunt and filename
Disk_Msg    .BSS 40     ; disk status as text message

EXIT_OLD   = $cf2e      ; exit address for ROM 910110
EXIT       = $cfa4      ; exit address for ROM 911001

PRIMM      = $ff7d
CINT       = $ff81
IOINIT     = $ff84
SETMSG     = $ff90
SECOND     = $ff93
TKSA       = $ff96
KEY        = $ff9f
SETTMO     = $ffa2
ACPTR      = $ffa5
CIOUT      = $ffa8
UNTALK     = $ffab
UNLSN      = $ffae
LISTEN     = $ffb1
TALK       = $ffb4
READSS     = $ffb7
SETLFS     = $ffba
SETNAM     = $ffbd
OPEN       = $ffc0
CLOSE      = $ffc3
CHKIN      = $ffc6
CHKOUT     = $ffc9
CLRCHN     = $ffcc
CHRIN      = $ffcf
CHROUT     = $ffd2
LOAD       = $ffd5
SAVE       = $ffd8
STOP       = $ffe1

; **********
Monitor_Call ; $6000
; **********

         JMP  Mon_Call

; ***********
Monitor_Break ; $6003
; ***********

         JMP  Mon_Break

; ************
Monitor_Switch ; $6009
; ************

         JMP  Mon_Switch

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
         BPL  _loop
         DEX
_loop    PLA
         STA  PCH,X
         DEX
         BPL  _loop

; decrement PC to point after BRK

         LDA  PCL
         BNE  _nopage
         DEC  PCH
_nopage  DEC  PCL

         LDA  $011d
         BBR7 Bank,_bank
         LDA  $011f
_bank    AND  #15
         STA  Bank
         BRA  Mon_Start

; ******
Mon_Call
; ******

         JSR  Print_Commands

;        clear register for monitor call

         LDA  #0
         LDX  #6
_loop    STA  AC,X
         DEX
         BPL  _loop

;        set default PC to "exit to BASIC"

         LDA  #<EXIT     ; ROM 911110
         LDX  #>EXIT
         BIT  EXIT       ; $20 (JSR) or $ff ?
         BPL  _store
         LDA  #<EXIT_OLD ; ROM 910111
         LDX  #>EXIT_OLD
_store   STA  PCL
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
_loopa   LDA  Bank,Y
         JSR  Print_Hex
         INY
         CPY  #2
         BCC  _loopa

; print SR,PCL,A,X,Y,Z,BP

_loopb   LDA  Bank,Y
         JSR  Print_Hex_Blank
         INY
         CPY  #9
         BCC  _loopb

; print 16 bit stack pointer

         LDA  SPH
         JSR  Print_Hex
         LDA  SPL
         JSR  Print_Hex_Blank

; print flags

         LDY  #8
         LDA  SR
_loopc   ASL  A
         PHA
         LDA  #'-'
         BCC  _flag
         LDA  #'1'
_flag    JSR  CHROUT
         PLA
         DEY
         BNE  _loopc

; **
Main
; **

         JSR  Print_CR
         LDX  #0

; read one line into buffer

; ****
Main_A
; ****

_loop    JSR  CHRIN
         STA  Buffer,X
         INX
         CPX  #80
         BCS  Mon_Error         ; input too long
         CMP  #CR
         BNE  _loop

         LDA  #0
         STA  Buf_Index
         STA  Buffer-1,X        ; terminate buffer
_getcomm JSR  Get_Char
         BEQ  Main
         CMP  #' '
         BEQ  _getcomm

; ********
Mon_Switch
; ********

         LDX  #24
_loop    CMP  Command_Char,X
         BEQ  Mon_Select
         DEX
         BPL  _loop

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

         .WORD Mon_Assemble     ; A
         .WORD Mon_Bits         ; B
         .WORD Mon_Compare      ; C
         .WORD Mon_Disassemble  ; D
         .WORD Mon_Fill         ; F
         .WORD Mon_Go           ; G
         .WORD Mon_Hunt         ; H
         .WORD Mon_JSR          ; J
         .WORD Mon_Memory       ; M
         .WORD Mon_Register     ; R
         .WORD Mon_Transfer     ; T
         .WORD Mon_Exit         ; X
         .WORD Mon_DOS          ; @
         .WORD Mon_Assemble     ; .
         .WORD Mon_Set_Memory   ; >
         .WORD Mon_Set_Register ; ;
         .WORD Mon_Help         ; ?
         .WORD Converter        ; $
         .WORD Converter        ; +
         .WORD Converter        ; &
         .WORD Converter        ; %


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

         BCS  _error
         LDA  Long_AC
         STA  Bank+2
         LDA  Long_AC+1
         STA  Bank+1
         LDA  Long_AC+2
         STA  Bank
_error   RTS

; ********
LAC_To_LPC
; ********

         PHX
         LDX  #3
_loop    LDA  Long_AC,X
         STA  Long_PC,X
         DEX
         BPL  _loop
         PLX
         RTS

; ********
LAC_To_LCT
; ********

         PHX
         LDX  #3
_loop    LDA  Long_AC,X
         STA  Long_CT,X
         DEX
         BPL  _loop
         PLX
         RTS

; ********
LAC_To_LDA
; ********

         PHX
         LDX  #3
_loop    LDA  Long_AC,X
         STA  Long_DA,X
         DEX
         BPL  _loop
         PLX
         RTS

; **********
LAC_Plus_LCT
; **********

         PHX
         LDX  #252              ; use ZP wrap around
         CLC
_loop    LDA  Long_AC+4,X
         ADC  Long_CT+4,X
         STA  Long_AC+4,X
         INX
         BNE  _loop
         PLX
         RTS

; ***********
LAC_Minus_LPC
; ***********

         PHX
         LDX  #252              ; use ZP wrap around
         SEC
_loop    LDA  Long_AC+4,X
         SBC  Long_PC+4,X
         STA  Long_CT+4,X
         INX
         BNE  _loop
         PLX
         RTS

; *************
LAC_Compare_LPC
; *************

         PHX
         LDX  #252              ; use ZP wrap around
         SEC
_loop    LDA  Long_AC+4,X
         SBC  Long_PC+4,X
         INX
         BNE  _loop
         PLX
         RTS

; *****
Inc_LAC
; *****

         INW  Long_AC
         BNE  _return
         INW  Long_AC+2
_return  RTS

; *****
Dec_LAC
; *****

         LDA  Long_AC
         ORA  Long_AC+1
         BNE  _skip
         DEW  Long_AC+2
_skip    DEW  Long_AC
         RTS

; *****
Inc_LPC
; *****

         INW  Long_PC
         BNE  _return
         INW  Long_PC+2
_return  RTS

; *****
Dec_LDA
; *****

         LDA  Long_DA
         ORA  Long_DA+1
         BNE  _skip
         DEW  Long_DA+2
_skip    DEW  Long_DA
         RTS

; ***
Fetch
; ***

         PHZ
         TYA
         TAZ
         BBS7 Long_PC+3,_banked ; trigger banked access
         NOP                    ; use LDA  [Long_PC],Z
_banked  LDA  (Long_PC),Z
         PLZ
         AND  #$ff
         RTS

; ********
Mon_Memory
; ********

         JSR  Get_LAC           ; get 1st. parameter
         LDZ  #16               ; default row count
         BCS  _row              ; no address
         JSR  LAC_To_LPC        ; Long_PC = start address
         JSR  Get_LAC           ; Long_AC = end address
         BCS  _row              ; not given

         JSR  LAC_Minus_LPC     ; Long_CT = range
         LBCC Mon_Error         ; negative range -> error
         LDX  #4                ; 16 bytes / line
         BBR7 MODE_80,_shift
         DEX                    ;  8 bytes / line
_shift   LSR  Long_CT+1
         ROR  Long_CT
         DEX
         BNE  _shift
         LDZ  Long_CT           ; row count
         INZ

_row     JSR  STOP
         BEQ  _exit
         JSR  Dump_Row
         DEZ
         BNE  _row
_exit    JMP  Main

; ********
Print_Bits
; ********

         PHZ
         STA  Long_DA
         LDY  #8
_loop    LDA  #'*'
         BBS7 Long_DA,_set
         LDA  #'.'
_set     JSR  CHROUT
         ASL  Long_DA
         DEY
         BNE  _loop
         PLZ
         RTS

; ******
Mon_Bits
; ******

         JSR  Get_LAC           ; get 1st. parameter
         BCS  _lab
         JSR  LAC_To_LPC        ; Long_PC = start address
_lab     JSR  Print_CR
         LDA  #WHITE
         STA  Long_DA+1

         LDX  #8
_row     PHX
         JSR  Hex_LPC
         LDZ  #0
_col     SEC
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
         BCC  _col
         JSR  Print_CR
         JSR  Inc_LPC
         PLX
         DEX
         BNE  _row
         JMP  Main

; **************
Mon_Set_Register
; **************

         JSR  Get_LAC           ; get 1st. parameter
         JSR  LAC_To_PC
         LDY  #3
_loop    JSR  Get_LAC
         BCS  _exit
         LDA  Long_AC
         STA  Bank,Y
         INY
         CPY  #9
         BCC  _loop
_exit    JMP  Main

; ************
Mon_Set_Memory
; ************

         JSR  Get_LAC           ; get 1st. parameter
         BCS  _exit
         JSR  LAC_To_LPC        ; Long_PC = row address
         LDZ  #0
_loop    JSR  Get_LAC
         BCS  _exit
         LDA  Long_AC
         BBS7 Long_PC+3,_banked ; trigger banked access
         NOP                    ; use STA  [Long_PC],Z
_banked  STA  (Long_PC),Z
         INZ
         CPZ  #16
         BBR7 MODE_80,_next
         CPZ  #8
_next    BCC  _loop

_exit    JSR  PRIMM
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
_loop    BBS7 Long_PC+3,_banked ; trigger banked access
         NOP                    ; use LDA  [Long_PC],Z
_banked  LDA  (Long_PC),Z
         JSR  Print_Hex_Blank
         INZ
         TZA
         AND  #3
         BNE  _loop
         RTS

; **********
Dump_4_Chars
; **********

         LDY  #0
         STY  QTSW              ; disable quote mode
         JSR  CHROUT            ; colour
_loop    BBS7 Long_PC+3,_banked ; trigger banked access
         NOP                    ; use LDA  [Long_PC],Z
_banked  LDA  (Long_PC),Z
         TAY
         AND  #%0110 0000
         BNE  _laba
         LDY  #'.'
_laba    TYA
         JSR  CHROUT
         INZ
         TZA
         AND  #3
         BNE  _loop
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
         BBR7 MODE_80,_loop
         DEX                    ; 1 block  in 40 columns
_loop    LDA  #LRED
         JSR  Dump_4_Bytes
         LDA  #WHITE
         JSR  Dump_4_Bytes
         DEX
         BNE  _loop

         JSR  PRIMM
         .BYTE $3a,$12,$00      ; : reverse on

         LDZ  #0
         LDX  #2                ; 4 blocks in 80 columns
         BBR7 MODE_80,_lchr
         DEX                    ; 2 blocks in 40 columns
_lchr    LDA  #LRED
         JSR  Dump_4_Chars
         LDA  #WHITE
         JSR  Dump_4_Chars
         DEX
         BNE  _lchr
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
         BCC  _forward

;        source < target: backward transfer

         JSR  LAC_Plus_LCT      ; Long_AC = end of target

_lpback  LDA  [Long_DA],Z       ; backward copy
         STA  [Long_AC],Z
         JSR  Dec_LDA
         JSR  Dec_LAC
         JSR  Dec_LCT
         BPL  _lpback
         JMP  Main

_forward LDA  [Long_PC],Z       ; forward copy
         STA  [Long_AC],Z
         JSR  Inc_LPC
         JSR  Inc_LAC
         JSR  Dec_LCT
         BPL  _forward
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
_loop    LDA  [Long_PC],Z
         CMP  [Long_AC],Z
         BEQ  _laba
         JSR  Hex_LPC
_laba    JSR  Inc_LAC
         JSR  Inc_LPC
         JSR  Dec_LCT
         BPL  _loop
         JMP  Main

; ******
Mon_Hunt
; ******

         JSR  Param_Range       ; Long_PC = start
         LBCS Mon_Error         ; Long_CT = count
         LDY  #0
         JSR  Get_Char
         CMP  #APOSTR
         BNE  _bin
         JSR  Get_Char          ; string hunt
         CMP  #0
         LBEQ Mon_Error         ; null string

_lpstr   STA  Mon_Data,Y
         INY
         JSR  Get_Char
         BEQ  _hunt
         CPY  #32               ;max. string length
         BNE  _lpstr
         BRA  _hunt

_bin     JSR  Got_LAC
_lpbin   LDA  Long_AC
         STA  Mon_Data,Y
         INY
         JSR  Get_LAC
         BCS  _hunt
         CPY  #32               ;max. data length
         BNE  _lpbin

_hunt    STY  Long_DA           ; hunt length
         JSR  Print_CR

_lpstart LDY  #0
_lpins   JSR  Fetch
         CMP  Mon_Data,Y
         BNE  _next
         INY
         CPY  Long_DA
         BNE  _lpins
         JSR  Hex_LPC           ; match
_next    JSR  STOP
         LBEQ Main
         JSR  Inc_LPC
         JSR  Dec_LCT
         BPL  _lpstart
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
_skip    JSR  Get_Char          ; skip blanks
         LBEQ Mon_Error
         CMP  #' '
         BEQ  _skip
         CMP  #QUOTE            ; must be quote
         LBNE Mon_Error

         LDX  Buf_Index
_copyfn  LDA  Buffer,X          ; copy filename
         BEQ  _do               ; no more input
         INX
         CMP  #QUOTE
         BEQ  _unit             ; end of filename
         STA  (FNADR),Y         ; store to filename
         INC  FNLEN
         INY
         CPY  #19               ; max = 16 plus prefix "@0:"
         BCC  _copyfn
         JMP  Mon_Error         ; filename too long

_unit    STX  Buf_Index         ; update read position
         JSR  Get_Char
         BEQ  _do               ; no more parameter
         JSR  Get_LAC
         BCS  _do
         LDA  Long_AC           ; unit #
         STA  FA
         JSR  Get_LAC
         BCS  _do
         JSR  LAC_To_LPC        ; Long_PC = start address
         STA  BA                ; Bank
         JSR  Get_LAC           ; Long_AC = end address + 1
         BCS  _load             ; no end address -> load/verify
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
_exit    JMP  Main

_do      LDA  VERCK
         CMP  #'V'              ; Verify
         BEQ  _exec
         CMP  #'L'              ; Load
         LBNE Mon_Error
         LDA  #0                ; 0 = LOAD
_exec    JSR  LOAD              ; A == 0 : LOAD else VERIFY
         BBR4 STATUS,_exit
         LDA  VERCK
         LBEQ Mon_Error
         LBCS Main
         JSR  PRIMM
         .BYTE " ERROR",0
         JMP  Main

_load    LDX  Long_PC
         LDY  Long_PC+1
         LDA  #0                ; 0 = use X/Y as load address
         STA  SA                ; and ignore load address from file
         BRA  _do

; ******
Mon_Fill
; ******

         JSR  Param_Range       ; Long_PC = target
         LBCS Mon_Error         ; Long_CT = count
         JSR  Get_LAC           ; Long_AC = fill byte
         LBCS Mon_Error
         JSR  Print_CR
         LDZ  #0
_loop    LDA  Long_AC
         STA  [Long_PC],Z
         JSR  Inc_LPC
         JSR  Dec_LCT
         BPL  _loop
         JMP  Main

; **********
Mon_Assemble
; **********

         JSR  Get_LAC           ; get 1st. parameter
         LBCS Mon_Error
         JSR  LAC_To_LPC        ; Long_PC = PC

_start   LDX  #0                ; mne letter counter
         STX  Long_DA+1         ; clear encoded MNE
         STX  Op_Flag           ; 6:long branch 5:32 bit
         STX  Op_Ix             ; operand byte index
         STX  Op_Len            ; operand length
_getin   JSR  Get_Char
         BNE  _laba
         CPX  #0
         LBEQ Main

_laba    CMP  #' '
         BEQ  _start            ; restart after blank

;        check for long branches

         CPX  #1
         BNE  _labb             ; -> not 2nd. char
         CMP  #'B'
         BNE  _labb             ; 2nd. char != 'B'
         LDZ  Op_Mne
         CPZ  #'L'
         BNE  _labb             ; 1st. Char != 'L'
         SMB6 Op_Flag           ; flag long branch
         DEX                    ; skip 'L'

_labb    STA  Op_Mne,X          ; next mne character
         INX
         CPX  #3
         BNE  _getin

;        encode 3 letter mnemonic

_lpenc   LDA  Op_Mne-1,X
         SEC
         SBC  #$3f              ; offset
         LDY  #5                ; 5 bit code
_lpbit   LSR  A
         ROR  Long_DA
         ROR  Long_DA+1
         DEY
         BNE  _lpbit
         DEX
         BNE  _lpenc

;        find packed MNE code in table

         LDX  #90               ; # of mnemonics
         LDA  Long_DA
_lpfind  CMP  MNE_L,X           ; compare left MNE
         BNE  _nxfind
         LDY  MNE_R,X
         CPY  Long_DA+1         ; compare right MNE
         BEQ  _found
_nxfind  DEX
         BPL  _lpfind
         JMP  Mon_Error

_found   STX  Ix_Mne

;        find 1st. opcode for this mnemonic

         TXA
         LDX  #0
_lpopc   CMP  MNE_Index,X
         BEQ  _exopc
         INX
         BNE  _lpopc
_exopc   STX  Op_Code

;        check for BBR BBS RMB SMB

         TXA
         AND  #7
         CMP  #7
         BNE  _labc

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

_labc    LDA  #0
_labd    STA  Mode_Flags
         JSR  Read_Number
         LBCS Mon_Error
         BEQ  _labg             ; no operand
         LDA  Long_AC+2
         LBNE Mon_Error         ; -> overflow
         LDY  #2                ; Y=2 word operand
         LDA  Long_AC+1
         BNE  _labf             ; high byte not zero
         DEY                    ; Y=1 byte operand
_labf    LDX  Op_Ix             ; X = operand value #
         TYA                    ; A = 1:byte or 2:word
         STA  Op_Len,X          ; store operand length
         INC  Op_Ix             ; ++index to operand value
         TXA                    ; A = current index
         BNE  _labg             ; -> at 2nd. byte
         JSR  LAC_To_LCT        ; Long_CT = 1st. operand
_labg    DEC  Buf_Index         ; back to delimiter

_lpnop   JSR  Get_Char          ; get delimiter
         LBEQ _adjust           ; end of operand
         CMP  #' '
         BEQ  _lpnop

;        immediate

         CMP  #'#'
         BNE  _lbra
         LDA  Mode_Flags
         BNE  _error
         LDA  #$80              ; immediate mode
         BRA  _labd

;        left bracket

_lbra    CMP  #'['
         BNE  _indir
         LDA  Mode_Flags
         BNE  _error
         SMB5 Op_Flag           ; 32 bit mode
         LDA  #$40              ; ( flag
         BRA  _labd

;        left parenthesis

_indir   CMP  #'('
         BNE  _comma
         LDA  Mode_Flags
         BNE  _error
         LDA  #$40              ; ( flag
         BRA  _labd

;        comma

_comma   CMP  #','
         BNE  _stack
         LDA  Op_Ix             ; operand value #
         BEQ  _error
         LDX  #4                ; outside comma
         LDA  Mode_Flags
         BEQ  _comma1           ; no flags yet
         CMP  #$78              ; ($nn,SP)
         BEQ  _comma1
         CMP  #$48              ; ($nn)
         BEQ  _comma1
         LDX  #$20              ; , inside comma
         CMP  #$40              ; (
         BNE  _error
_comma1  TXA
         ORA  Mode_Flags
         JMP  _labd

;        stack relative

_stack   CMP  #'S'
         BNE  _rbra
         JSR  Get_Char
         CMP  #'P'
         BNE  _error
         LDA  Mode_Flags
         CMP  #$60              ; ($nn,
         BNE  _error
         ORA  #%0001 0000       ; SP flag
         JMP  _labd

;        right bracket

_rbra    CMP  #']'
         BNE  _right
         BBR5 Op_Flag,_error
         LDA  Op_Ix
         LBEQ Mon_Error         ; no value
         LDA  Mode_Flags
         CMP  #$40              ; (
         LBNE Mon_Error
         ORA  #%0000 1000       ; )
         JMP  _labd

_error   JMP  Mon_Error

;        right parenthesis

_right   CMP  #')'
         BNE  _X
         LDA  Op_Ix
         LBEQ Mon_Error         ; no value
         LDA  Mode_Flags
         CMP  #$40              ; (
         BEQ  _right1
         CMP  #$61              ; ($nn,X
         BEQ  _right1
         CMP  #$70              ; ($nn,SP
         LBNE Mon_Error
_right1  ORA  #%0000 1000       ; )
         JMP  _labd

_X       CMP  #'X'
         BNE  _Y
         LDA  Op_Ix
         LBEQ Mon_Error
         LDA  Mode_Flags
         CMP  #$60
         BEQ  _X1
         CMP  #4
         LBNE Mon_Error
_X1      ORA  #%0000 0001
         JMP  _labd

;        Y

_Y       CMP  #'Y'
         BNE  _Z
         LDA  Op_Ix
         LBEQ Mon_Error
         LDA  Mode_Flags
         CMP  #$4c             ; ($nn),
         BEQ  _Y1
         CMP  #4               ; $nn,
         BEQ  _Y1
         CMP  #$7c             ; ($nn,SP),
         LBNE Mon_Error
_Y1      ORA  #%0000 0010      ; Y
         JMP  _labd

;        Z

_Z       CMP  #'Z'
         LBNE Mon_Error
         LDA  Op_Ix
         LBEQ Mon_Error
         LDA  Mode_Flags
         CMP  #$4c              ; $nn,
         LBNE Mon_Error
         ORA  #%0000 0011       ; Z
         JMP  _labd

;        BBR BBS RMB SMB  two operands

_adjust  LDA  Ix_Mne
         LDX  Op_Ix             ; # if values
         BEQ  _match            ; -> no operand
         DEX
         BEQ  _one             ; ->  one operand
         DEX
         LBNE Mon_Error         ; -> error if more than 2
         CMP  #5                ; BBR
         BEQ  _BB
         CMP  #6                ; BBS
         LBNE Mon_Error
_BB      LDA  Long_CT+1
         LBNE Mon_Error
         LDA  #3                ; offset
         JSR  Branch_Target
         LDA  Op_Code
         LDY  Long_AC
         LDX  Long_CT
         STX  Long_AC
         STY  Long_AC+1
         LDY  #2
         BRA  _store

;        one operand in Long_CT

_one     LDX  Long_CT
         LDY  Long_CT+1
         STX  Long_AC
         STY  Long_AC+1            ; Aval = operand
         LDX  #10
_lpbrain CMP  BRAIN-1,X
         BEQ  _branch
         DEX
         BNE  _lpbrain
         BRA  _match

;        branch instruction

_branch  LDA  Mode_Flags
         LBNE Mon_Error         ; only value
         LDA  #2                ; branch offset
         JSR  Branch_Target
         LDA  Op_Code
         LDY  #1                ; short branch
         BBR6 Op_Flag,_bran1
         INY                    ; long branch
         ORA  #3
_bran1   BRA  _store

;        find opcode matching mnemonic and address mode

_match   JSR  Mode_Index
_lpmatch JSR  Match_Mode
         BEQ  _okmat
         LDA  Op_Len
         LBEQ Mon_Error
         LDA  Mode_Flags
         LBMI Mon_Error
         AND  #%0011 1111
         STA  Mode_Flags
         INC  Op_Len
         JSR  Size_To_Mode
         BRA  _lpmatch
_okmat   LDY  Op_Len
         TXA

;        store instruction bytes
;        -----------------------
;        A    = opcode
;        Y    = operand length
;        Long_AC = operand value

_store   STA  Op_Code
         STY  Op_Size
         INC  Op_Size
         BBR5 Op_Flag,_storen
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
         BRA  _print

_storen  PHY
         PLZ                    ; Z = Y
         BEQ  _store1

_lpsto   LDA  Long_AC-1,Y
         STA  [Long_PC],Z
         DEZ
         DEY
         BNE  _lpsto

_store1  LDA  Op_Code
         STA  [Long_PC],Z

_print   JSR  PRIMM
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
         BNE  _auto
         DEX                    ; 4 digits
_auto    PHX
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
         BPL  _auto

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
_loop    CMP  LEN_ADM,X
         BEQ  _return           ; success  ZF=1

;        search for next opcode with same mnemonic

_next    INX                    ; next opcode
         BEQ _error
         LDY  MNE_Index,X
         CPY  Ix_Mne            ; same mnemonic ?
         BEQ  _loop             ; -> compare again
         BRA  _next

_error   DEX                    ; X = $ff ZF=0
_return  RTS

; ********
Mode_Index
; ********

         LDA  Mode_Flags
         LDX  #0
_loop    CMP  ADMODE,X
         BEQ  _found
         INX
         CPX  #16
         BCC  _loop
         TXA
         RTS
_found   STX  Mode_Flags

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
         BCS  _nopar
         JSR  LAC_To_LPC        ; Long_PC = start address
         JSR  Get_LAC           ; Long_AC = end address
         BCC  range
_nopar   LDA  #32               ; disassemble 32 bytes
         STA  Long_CT
         BRA  _loop
range    JSR  LAC_Minus_LPC     ; Long_CT = range
         LBCC Mon_Error         ; -> negative

_loop    JSR  CR_Erase          ; prepare empty line
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
         BCS  _loop
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
         BNE  _nop
         INY                    ; Y = 1
         JSR  Fetch
         CMP  #$42              ; NEG
         BNE  _nop
         SMB4 Op_Flag           ; Q flag
         LDA  #2
         JSR  Add_LPC           ; skip NEG NEG

;        check for 32 bit address mode

_nop     LDY  #0
         JSR  Fetch
         STA  Op_Code
         TAX
         CMP  #$ea              ; prefix ?
         BNE  _normal
         INY
         JSR  Fetch             ; opcode after prefix
         AND  #%0001 1111       ; identify ($nn),Z codes
         CMP  #%0001 0010
         BNE  _normal
         SMB5 Op_Flag           ; set extended flag
         JSR  Fetch
         STA  Op_Code           ; code after prefix
         TAX

_normal  LDY  LEN_ADM,X         ; Y = length and address mode
         TYA                    ; A = length and address mode
         AND  #15               ; A = address mode
         TAX                    ; X = address mode
         LDA  ADMODE,X          ; A = mode flags
         STA  Adr_Flags         ; store
         TYA                    ; A = length and address mode
         AND  #%1100 0000       ; mask instruction length
         ASL  A                 ; rotate into lower two bits
         ROL  A
         ROL  A
         STA  Op_Size           ; store
         BBR5 Op_Flag,_norm1
         INC  Op_Size
_norm1

;        print instruction and operand bytes

         LDY  #0
         LDA  #' '
         BBR4 Op_Flag,_blpr
         LDA  #'*'              ; print * for NEG NEG
_blpr    JSR  CHROUT
_lphex   JSR  Fetch
         JSR  Print_Hex_Blank
         CPY  #2
         BEQ  _long             ; stop after 3 bytes
         CPY  Op_Size
         INY
         BCC  _lphex

;        fill up with blanks

_lpfill  CPY  #3
         BCS  _long
         JSR  PRIMM
         .BYTE "   ",0
         INY
         BRA  _lpfill

;        detect long branches

_long    LDA  #YELLOW
         JSR  CHROUT
         LDX  Op_Code
         LDA  LEN_ADM,X
         CMP  #%1010 0000        ; long branch mode
         BNE  _locate
         SMB6 Op_Flag            ; set long branch flag
         LDA  #'L'
         JSR  CHROUT

;        locate mnemonic text

_locate  LDX  Op_Code           ; X = opcode
         LDY  MNE_Index,X       ; Y = index to mnemonic text
         LDA  MNE_L,Y           ; A = packed left part
         STA  Long_AC+1
         LDA  MNE_R,Y           ; A = packed right part
         STA  Long_AC

;        unpack and print mnemonic text

         LDX  #3                ; 3 letters
_lpmne   LDA  #0
         LDY  #5                ; 5 bits per letter
_lplet   ASL  Long_AC
         ROL  Long_AC+1
         ROL  A                 ; rotate letter into A
         DEY
         BNE  _lplet            ; next bit
         ADC  #$3f              ; add offset (C = 0)
         DEX
         BEQ  _lastc            ; 3rd. character
         TAZ                    ; remember
         JSR  CHROUT            ; and print it
         BRA  _lpmne            ; next letter

_lastc   BBR4 Op_Flag,_lbra     ; -> no Q
         CMP  #'A'              ; LDA, STA, ORA
         BEQ  _Q3
         CMP  #'C'              ; DEC, INC
         BNE  _Q4
         CPZ  #'E'              ; DEC
         BEQ  _Q3
         CPZ  #'N'              ; INC
         BNE  _Q4
_Q3      LDA  #'Q'              ; LDQ, STQ, ORQ, INQ, DEQ
         JSR  CHROUT
         BRA  _mne4
_Q4      JSR  CHROUT
         LDA  #'Q'              ; add Q as 4th. char
         JSR  CHROUT
         BRA  _mne5

_lbra    JSR  CHROUT            ; 3rd. character
         BBS6 Op_Flag,_mne5     ; long branch

;        check for 4-letter bit instructions

         LDA  Op_Code
         AND  #15
         CMP  #7                ; RMB & SMB
         BEQ  _biti
         CMP  #15               ; BBR & BBS
         BNE  _mne4
         SMB7 Op_Flag           ; flag two operands
_biti    LDA  Op_Code
         AND  #%0111 0000
         ASL  A
         ROL  A
         ROL  A
         ROL  A
         ROL  A
         ORA  #'0'
         JSR  CHROUT
         BRA  _mne5

_mne4    JSR  Print_Blank
_mne5    JSR  Print_Blank
         LDA  #WHITE
         JSR  CHROUT

;        check for accumulator operand

         LDA  Op_Code
         LDX  #8
_lpaccu  DEX
         BMI  _oper
         CMP  ACCUMODE,X
         BNE  _lpaccu

         LDA  #'A'
         BBR4 Op_Flag,_accu
         LDA  #'Q'
_accu    JSR  CHROUT
         JMP  _return

;        fetch and decode operand

_oper    LDX  Op_Size
         LBEQ _return           ; -> no operand

         BBR7 Adr_Flags,_laba   ; bit 7: immediate
         LDA  #'#'
         BRA  _labb
_laba    BBR6 Adr_Flags,_labc   ; bit 6: left (
         LDA  #'('
         BBR5 Op_Flag,_labb
         LDA  #'['
_labb    JSR  CHROUT
_labc    LDA  #'$'
         JSR  CHROUT

;        fetch operand to Long_AC

         LDY  #0
         STY  Long_AC+1
_lpfop   INY
         JSR  Fetch
         STA  Long_AC-1,Y
         CPY  Op_Size
         BCC  _lpfop

;        interpret address modes

         LDX  Op_Code
         LDA  LEN_ADM,X
         AND  #%0010 0000       ; branches
         LBNE _rel

;        print 16 bit operand hi/lo or 8 bit operand

         BBR5 Op_Flag,_proper
         LDA  Long_AC+1
         JSR  Print_Hex         ; [$nn],Z
         LDA  #']'
         JSR  CHROUT
         BRA  _labf

_proper  LDY  Op_Size
         BBR7 Op_Flag,_lpoper
         LDY  #1
_lpoper  LDA  Long_AC-1,Y
         JSR  Print_Hex
         DEY
         BNE  _lpoper

         BBR5 Adr_Flags,_labe   ; comma flag
         LDA  #','
         JSR  CHROUT

         BBR4 Adr_Flags,_labd   ; SP flag
         LDA  #'S'
         JSR  CHROUT
         LDA  #'P'
         JSR  CHROUT

_labd    BBR0 Adr_Flags,_labe   ; X flag
         LDA  #'X'
         JSR  CHROUT

_labe    BBR3 Adr_Flags,_labf   ; ) flag
         LDA  #')'
         JSR  CHROUT

_labf    BBR4 Op_Flag,_comch    ; not a Q instruction
         LDA  Adr_Flags
         AND  #3
         CMP  #1
         BNE  _return           ; Q only with ,X

_comch   BBR2 Adr_Flags,_labg   ; , flag
         LDA  #','
         JSR  CHROUT

         LDA  Adr_Flags
         AND  #%0000 0011 ; $03
         BEQ  _labg
         TAY
         LDA  Index_Char-1,Y
         JSR  CHROUT

;        fetch 2nd. operand for BBR and BBS

_labg    BBR7 Op_Flag,_return
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
         BRA  _rela

_rel     LDA  #2                ; offset for relative address
_rela    PHA
         LDA  Op_Size           ; 1:short   2:long
         LSR  A
         ROR  A
         AND  Long_AC
         BPL  _labh
         LDA  #$ff              ; backward branch
         STA  Long_AC+1

_labh    PLX                    ; offset 2 or 3
_lpinw   INW  Long_AC
         DEX
         BNE  _lpinw

         CLC
         LDA  Long_AC
         ADC  Long_PC
         PHA
         LDA  Long_AC+1
         ADC  Long_PC+1
         TAX
         PLA
         JSR  Print_XA_Hex
         BBR7 Op_Flag,_return
         INC  Op_Size
_return  RTS

; *****
Got_LAC
; *****

         DEC  Buf_Index

; *****
Get_LAC
; *****

         JSR  Read_Number
         BCS  _error            ; illegal character
         BEQ  _noval            ; no value
         JSR  Got_Char          ; delimiter ?
         BEQ  _end              ; end of input
         CMP  #' '
         BEQ  _ok
         CMP  #','
         BEQ  _ok
_error   JMP  Mon_Error         ; stack is reset in Mon_Error

_noval   SEC
         RTS

_end     DEC  Buf_Index
_ok      CLC
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
         BEQ  _exit
         CMP  #APOSTR           ; character entry 'C
         BNE  _numeric
         JSR  Get_Char          ; character after '
         STA  Long_AC
         INC  Dig_Cnt
         BRA  _exit

_numeric LDY  #3                ; $ + % %
_prefix  CMP  Cons_Prefix,Y     ; Y = base index
         BEQ  _digit            ; -> valid prefix
         DEY
         BPL  _prefix
         INY                    ; Y = 0
         DEC  Buf_Index         ; character is digit

_digit   JSR  Get_Char          ; hex -> BCD
         BEQ  _exit             ; ? : ; and zero terminate
         CMP  #'0'
         BCC  _exit
         CMP  #':'
         BCC  _valid            ; 0-9
         CMP  #'A'
         BCC  _exit
         CMP  #'G'
         BCS  _exit
         SBC  #7                ; hex conversion
_valid   SBC  #'0'-1
         CMP  Num_Base,Y
         BCS  _error
         PHA                    ; push digit
         INC  Dig_Cnt

         CPY  #1                ; decimal
         BNE  _laba
         LDX  #3                ; push Long_AC * 2
         CLC
_push    LDA  Long_AC,X
         ROL  A
         PHA
         DEX
         BPL  _push

_laba    LDX  Num_Bits,Y
_shift   ASL  Long_AC
         ROL  Long_AC+1
         ROW  Long_AC+2
         BCS  _error            ; overflow
         DEX
         BNE  _shift

         CPY  #1                ; decimal adjustment
         BNE  _labc
         LDX  #0
         LDZ  #3
         CLC
_pull    PLA
         ADC  Long_AC,X
         STA  Long_AC,X
         INX
         DEZ
         BPL  _pull

_labc    PLA                    ; pull digit
         CLC
         ADC  Long_AC
         STA  Long_AC
         BCC  _digit
         INC  Long_AC+1
         BNE  _digit
         INW  Long_AC+2
         BNE  _digit

_error   SEC
         BRA  _return
_exit    CLC
_return  PLZ
         PLY
         PLX
         LDA  Dig_Cnt           ; digits read
         RTS

; *****
Hex_LPC
; *****

         LDX  Long_PC+3
         BEQ  _laba
         LDA  #YELLOW
         JSR  CHROUT
         TXA
         JSR  Print_Hex
         LDA  Long_PC+2
         JSR  Print_Hex
         LDA  #WHITE
         JSR  CHROUT
         BRA  _labb
_laba    LDA  Long_PC+2
         BEQ  _labb
         JSR  Print_Hex
_labb    LDX  Long_PC+1
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
         JSR  _nibble
         TAX
         PLA
         LSR  A
         LSR  A
         LSR  A
         LSR  A

_nibble  AND  #15
         CMP  #10
         BCC  _lab
         ADC  #6
_lab     ADC  #'0'
         RTS

; *******
Get_Glyph
; *******
         PHX
         LDA  #' '
_loop    LDX  Buf_Index
         INC  Buf_Index
         CMP  Buffer,X
         BEQ  _loop
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
         BCC  _regc
         CMP  #';'            ; register
         BEQ  _return
         CMP  #'?'            ; help
         BEQ  _return
_regc    CMP  #0
         BEQ  _return
         CMP  #':'
_return  RTS


; *****
Dec_LCT
; *****

         LDA  Long_CT
         ORA  Long_CT+1
         BNE  _skip
         DEW  Long_CT+2
_skip    DEW  Long_CT
         LDA  Long_CT+3         ; set N flag
         RTS

; *****
Add_LPC
; *****

         CLC
         ADC  Long_PC
         STA  Long_PC
         BCC  _return

; **********
Inc_LPC_Page
; **********

         INC  Long_PC+1
         BNE  _return
         INW  Long_PC+2
_return  RTS

; *********
Param_Range
; *********

; read two (address) parameters

; Long_CT = difference (2nd. minus 1st.)
; Long_PC = 1st. parameter
; Long_DA = 2nd. parameter

; carry on exit flags error

         JSR  Get_LAC           ; get 1st. parameter
         BCS  _error
         JSR  LAC_To_LPC        ; Long_PC = 1st. address
         JSR  Get_LAC
         BCS  _error
         JSR  LAC_To_LDA        ; Long_DA = 2nd. address
         JSR  LAC_Minus_LPC     ; Long_CT = range
         BCC  _error
         CLC
         RTS
_error   SEC
         RTS

; *******
Converter
; *******

         LDX  #0
         STX  Buf_Index
         JSR  Get_LAC
         LBCS Mon_Error
         LDX  #0
_loop    PHX
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
         BCC  _loop
         JMP  Main

Conv_Tab .WORD Print_Hexval
         .WORD Print_Decimal
         .WORD Print_Octal
         .WORD Print_Dual

; ********
Print_Dual
; ********

         LDX  #24               ; digits
         LDY  #1                ; bits per digit
         BRA  _entry

; *********
Print_Octal
; *********

         LDX  #8                ; digits
         LDY  #3                ; bits per digit

_entry   JSR  LAC_To_LCT
         LDZ  #0
         STZ  Long_PC
         LDZ  #'0'
         PHY                    ; save start value
_loopa   PLY                    ; reinitialise
         PHY
         LDA  #0
_loopb   ASL  Long_CT
         ROW  Long_CT+1
         ROL  A
         DEY
         BNE  _loopb
         CPX  #1                ; print last character
         BEQ  _skip
         ORA  Long_PC
         BEQ  _next
_skip    ORA  #'0'
         STZ  Long_PC
         JSR  CHROUT
_next    DEX
         BNE  _loopa
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
_clear   STA  Long_PC,X
         DEX
         BPL  _clear

         LDX  #32               ; source bits
         SED
_loop    ASL  Long_CT
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
         BNE  _loop
         CLD

; *******
Print_BCD
; *******

         LDA  #0
         STA  Long_CT
         LDZ  #'0'
         LDY  #8                ; max. digits
_loopa   LDX  #3                ; 4 bytes
         LDA  #0
_loopb   ASL  Long_PC
         ROL  Long_PC+1
         ROW  Long_PC+2
         ROL  A
         DEX
         BPL  _loopb

         CPY  #1                ; print last character
         BEQ  _skip
         ORA  Long_CT
         BEQ  _next
_skip    ORA  #'0'
         STZ  Long_CT
         CMP  #$3a
         BCC  _print
         ADC  #6                ; + carry
_print   JSR  CHROUT
_next    DEY
         BNE  _loopa
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
         BNE  _lab
         LDY  #$f0              ; SA =  0
_lab     LDA  FA
         JSR  LISTEN
         TYA                    ; SA
         JSR  SECOND
_loop    LDA  Buffer,X
         BEQ  _close
         JSR  CIOUT
         INX
         BRA  _loop
_close   JSR  UNLSN
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
_loop    INY
         JSR  ACPTR
         STA  Disk_Msg,Y
         CMP  #' '
         BCS  _loop
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
_loop    LDA  Disk_Msg,Y
         BEQ  _exit
         JSR  CHROUT
         INY
         BRA  _loop
_exit    JMP  Print_CR

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
         BCC  _unit
         CMP  #':'
         BCS  _unit
         DEC  Buf_Index
         JSR  Read_Number
         BCS  _unit
         LDX  Long_AC           ; unit
         CPX  #4
         LBCC Mon_Error
         CPX  #31
         LBCS Mon_Error
_unit    STX  FA
         DEC  Buf_Index
_next    JSR  Get_Char
         BEQ  _status           ; only @u
         CMP  #' '
         BEQ  _next
         CMP  #','
         BEQ  _next
         CMP  #'U'              ; sector read/write
         BEQ  DOS_U
_status  JSR  Mon_Disk
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
_loopb   TAX                    ; X = previous byte
         JSR  ACPTR             ; A = current  byte
         LDY  STATUS
         BNE  _exit
         DEZ
         BNE  _loopb            ; X/A = last read word

         STX  Long_AC
         STA  Long_AC+1
         STZ  Long_AC+2
         STZ  Long_AC+3
         JSR  Print_Decimal     ; file size
         JSR  Print_Blank

_loopc   JSR  ACPTR             ; print file entry
         BEQ  _cr
         LDY  STATUS
         BNE  _exit
         JSR  CHROUT
         BCC  _loopc

_cr      JSR  Print_CR
         JSR  STOP
         BEQ  _exit
         LDZ  #4
         BRA  _loopb            ; next file
_exit    JMP  UNTALK

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

_loop    LDA  Mon_Data+1
         LSR  A
         BEQ  _write
         JSR  Find_Next_Sector
         BNE  _error
         JSR  Read_Sector
         BRA  _next

_write   JSR  Write_Sector
         JSR  Find_Next_Sector
         BNE  _error

_next    JSR  Inc_LPC_Page
         INC  Disk_Sector
         DEW  Long_CT
         BPL  _loop

_error   JSR  Print_Disk_Msg
         JSR  Close_Disk_Buffer
         JMP  Main

; **************
Find_Next_Sector
; **************

         JSR  Build_U_String
         JSR  Send_Disk_Command
         JSR  Get_Disk_Status
         BEQ  _return           ; OK
         CMP  #$66              ; illegal track or sector
         BNE  _error            ; error
         LDA  #0
         STA  Disk_Sector
         INC  Disk_Track        ; try next track
         JSR  Build_U_String
         JSR  Send_Disk_Command
         JSR  Get_Disk_Status
         BEQ  _return
_error   JSR  Print_Disk_Msg
         LDA  Disk_Status
_return  RTS

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
_loop    LDA  BP_ZERO,Y
         BEQ  _end
         JSR  CIOUT
         INY
         BRA  _loop
_end     JMP  UNLSN

; ***************
Send_Disk_Command
; ***************

         JSR  Open_Command_Channel
_loop    LDA  Mon_Data,Y
         BEQ  _end
         JSR  CIOUT
         INY
         BRA  _loop
_end     JMP  UNLSN

; *********
Read_Sector
; *********

         LDA  FA
         JSR  TALK
         LDA  #$69              ; SA = 9
         JSR  TKSA
         LDZ  #0
         STZ  STATUS
_loop    JSR  ACPTR
         STA  [Long_PC],Z
         INZ
         BNE  _loop
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
_loop    LDA  [Long_PC],Z
         JSR  CIOUT
         INZ
         BNE  _loop
         JSR  UNLSN
         RTS

; ****
Set_TS
; ****

; Input  A = track or sector
;        X = string index

_100      CMP  #100
          BCC  _10
          INC  Mon_Data,X
          SBC  #100
          BRA  _100
_10       CMP  #10
          BCC  _1
          INC  Mon_Data+1,X
          SBC  #10
          BRA  _10
_1        ORA  #'0'
          STA  Mon_Data+2,X
          RTS

; @[u],U1 mem track startsec [endsec] : read  disk sector(s)

; U1:CHANNEL DRIVE TRACK SECTOR

; ************
Build_U_String
; ************

         LDX  #14
_loop    LDA  U1,X
         STA  Mon_Data,X
         DEX
         CPX  #2
         BCS  _loop
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
; The operator >" stores the left (high) byte of the packed value
; The operator <" stores the right (low) byte of the packed value

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

         .BYTE $0f,$31,$15,$46,$53,$31,$02,$3d
         .BYTE $33,$31,$02,$55,$53,$31,$02,$05
         .BYTE $0d,$31,$31,$0d,$52,$31,$02,$3d
         .BYTE $13,$31,$22,$26,$52,$31,$02,$05
         .BYTE $28,$01,$28,$28,$0a,$01,$3e,$3d
         .BYTE $39,$01,$3e,$59,$0a,$01,$3e,$05
         .BYTE $0b,$01,$01,$0b,$0a,$01,$3e,$3d
         .BYTE $44,$01,$1c,$20,$0a,$01,$3e,$05
         .BYTE $41,$21,$2f,$03,$03,$21,$2d,$3d
         .BYTE $32,$21,$2d,$50,$27,$21,$2d,$05
         .BYTE $11,$21,$21,$11,$03,$21,$2d,$3d
         .BYTE $16,$21,$36,$4d,$2e,$21,$2d,$05
         .BYTE $42,$00,$42,$10,$4c,$00,$3f,$3d
         .BYTE $38,$00,$3f,$5a,$27,$00,$3f,$05
         .BYTE $12,$00,$00,$12,$4c,$00,$3f,$3d
         .BYTE $47,$00,$3b,$51,$27,$00,$3f,$05
         .BYTE $0e,$49,$49,$0e,$4b,$49,$4a,$48
         .BYTE $1f,$0a,$56,$4b,$4b,$49,$4a,$06
         .BYTE $07,$49,$49,$07,$4b,$49,$4a,$48
         .BYTE $58,$49,$57,$4a,$4c,$49,$4c,$06
         .BYTE $2b,$29,$2a,$2c,$2b,$29,$2a,$48
         .BYTE $4f,$29,$4e,$2c,$2b,$29,$2a,$06
         .BYTE $08,$29,$29,$08,$2b,$29,$2a,$48
         .BYTE $17,$29,$54,$2c,$2b,$29,$2a,$06
         .BYTE $1a,$18,$1b,$1d,$1a,$18,$1c,$48
         .BYTE $25,$18,$1e,$04,$1a,$18,$1c,$06
         .BYTE $0c,$18,$18,$0c,$1b,$18,$1c,$48
         .BYTE $14,$18,$35,$37,$1b,$18,$1c,$06
         .BYTE $19,$43,$29,$23,$19,$43,$22,$48
         .BYTE $24,$43,$30,$40,$19,$43,$22,$06
         .BYTE $09,$43,$43,$09,$34,$43,$22,$48
         .BYTE $45,$43,$3a,$3c,$34,$43,$22,$06

; ***
BRAIN
; ***

;              index values for branch mnemonics

;              BCC BCS BEQ BMI BNE BPL BRA BSR BVC BVS
         .BYTE $07,$08,$09,$0b,$0c,$0d,$0e,$10,$11,$12

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

         .BYTE $00,$44,$00,$00,$40,$40,$40,$40 ; $00
         .BYTE $00,$41,$00,$00,$80,$80,$80,$c0 ; $08
         .BYTE $60,$45,$46,$a0,$40,$47,$47,$40 ; $10
         .BYTE $00,$88,$00,$00,$80,$87,$87,$c0 ; $18
         .BYTE $80,$44,$8b,$84,$40,$40,$40,$40 ; $20
         .BYTE $00,$41,$00,$00,$80,$80,$80,$c0 ; $28
         .BYTE $60,$45,$46,$a0,$47,$47,$47,$40 ; $30
         .BYTE $00,$88,$00,$00,$87,$87,$87,$c0 ; $38
         .BYTE $00,$44,$00,$00,$40,$40,$40,$40 ; $40
         .BYTE $00,$41,$00,$00,$80,$80,$80,$c0 ; $48
         .BYTE $60,$45,$46,$a0,$47,$47,$47,$40 ; $50
         .BYTE $00,$88,$00,$00,$00,$87,$87,$c0 ; $58
         .BYTE $00,$44,$41,$a0,$40,$40,$40,$40 ; $60
         .BYTE $00,$41,$00,$00,$8b,$80,$80,$c0 ; $68
         .BYTE $60,$45,$46,$a0,$47,$47,$47,$40 ; $70
         .BYTE $00,$88,$00,$00,$84,$87,$87,$c0 ; $78
         .BYTE $60,$44,$4d,$a0,$40,$40,$40,$40 ; $80
         .BYTE $00,$41,$00,$87,$80,$80,$80,$c0 ; $88
         .BYTE $60,$45,$46,$a0,$47,$47,$48,$40 ; $90
         .BYTE $00,$88,$00,$88,$80,$87,$87,$c0 ; $98
         .BYTE $41,$44,$41,$41,$40,$40,$40,$40 ; $a0
         .BYTE $00,$41,$00,$80,$80,$80,$80,$c0 ; $a8
         .BYTE $60,$45,$46,$a0,$47,$47,$48,$40 ; $b0
         .BYTE $00,$88,$00,$87,$87,$87,$88,$c0 ; $b8
         .BYTE $41,$44,$41,$40,$40,$40,$40,$40 ; $c0
         .BYTE $00,$41,$00,$80,$80,$80,$80,$c0 ; $c8
         .BYTE $60,$45,$46,$a0,$40,$47,$47,$40 ; $d0
         .BYTE $00,$88,$00,$00,$80,$87,$87,$c0 ; $d8
         .BYTE $41,$44,$4d,$40,$40,$40,$40,$40 ; $e0
         .BYTE $00,$41,$00,$80,$80,$80,$80,$c0 ; $e8
         .BYTE $60,$45,$46,$a0,$81,$47,$47,$40 ; $f0
         .BYTE $00,$88,$00,$00,$80,$87,$87,$c0 ; $f8

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

         .BYTE %00000000 ; 0             implicit/direct
         .BYTE %10000000 ; 1 #$nn        immediate
         .BYTE %00000000 ; 2             ----------
         .BYTE %00000000 ; 3             ----------
         .BYTE %01101001 ; 4 ($nn,X)     indirect X
         .BYTE %01001110 ; 5 ($nn),Y     indirect Y
         .BYTE %01001111 ; 6 ($nn),Z     indirect Z
         .BYTE %00000101 ; 7 $nn,X       indexed  X
         .BYTE %00000110 ; 8 $nn,Y       indexed  Y
         .BYTE %00000101 ; 9 $nn,X       indexed  X
         .BYTE %00000110 ; a $nn,Y       ----------
         .BYTE %01001000 ; b ($nnnn,X)   JMP & JSR
         .BYTE %01101001 ; c ($nn,X)     ----------
         .BYTE %01111110 ; d ($nn,SP),Y  LDA & STA
         .BYTE %00000000 ; e
         .BYTE %00000100 ; f

;              ASL INC ROL DEC LSR ROR NEG ASR
ACCUMODE .BYTE $0a,$1a,$2a,$3a,$4a,$6a,$42,$43

Num_Base .BYTE 16,10, 8, 2 ; hex, dec, oct, bin
Num_Bits .BYTE  4, 3, 3, 1 ; hex, dec, oct, bin

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
