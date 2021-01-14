
!macro NOP { eom }             ; ACME does not allow NOP for MEGA65 CPU


; Due to shadowing mechanism, we are free to use zeropage addresses $02-$8F
; for any purpose - they won't conflict with BASIC interpreter varaibles


; ********************
; * Register storage *
; ********************
    
!addr Addr_Mode     =  2       ; $00 = 64K address, $80 = M65 flat address
!addr PCH           =  3
!addr PCL           =  4
!addr SR            =  5
!addr AC            =  6
!addr XR            =  7
!addr YR            =  8
!addr ZR            =  9
!addr BP            = 10
!addr SPH           = 11
!addr SPL           = 12

; *******************
; * Other variables *
; *******************

!addr Src_Addr_Mode = 13       ; Addr_Mode for 1st address
!addr Dst_Addr_Mode = 14       ; Addr_Mode for 2nd address

!addr MODE_80       = 15       ; 80 column / 40 volumn flag

; A set of 32 bit variables also used as 32 bit pointer

!addr Long_AC       = $10      ; 32 bit accumulator
!addr Long_CT       = $14      ; 32 bit counter
!addr Long_PC       = $18      ; 32 bit program counter
!addr Long_DA       = $1C      ; 32 bit data pointer

; Flags are used in BBR BBS instructions

!addr Adr_Flags     = $20
!addr Mode_Flags    = $21
!addr Op_Code       = $22
!addr Op_Flag       = $23      ; 7: two operands
                               ; 6: long branch
                               ; 5: 32 bit address
                               ; 4: Q register
!addr Op_Size       = $24
!addr Dig_Cnt       = $25
!addr Buf_Index     = $26

!addr SP_Storage    = $27      ; location to preserve stack pointer

!addr X_Vector      = $28      ; monitor exit vector
!addr Ix_Mne        = $2A      ; index to mnemonics table
!addr Op_Mne        = $2B      ; 3 bytes for mnemonic
!addr Op_Ix         = $2E      ; type of constant
!addr Op_Len        = $2F      ; length of operand

                               ; $30-$63 - free space, unused for now

!addr Long_TMP      = $64      ; temporary pointer, for fetching/storing memory content; has to be the same as Long__TMP in Kernal
!addr Mon_Data      = $68      ; 40 bytes, buffer for hunt
