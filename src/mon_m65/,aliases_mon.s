
!macro NOP { eom }             ; ACME does not allow NOP for MEGA65 CPU


; Due to shadowing mechanism, we are free to use zeropage addresses $02-$8F
; for any purpose - they won't conflict with BASIC interpreter varaibles


; ********************
; * Register storage *
; ********************

!addr Bank        =  2 ; XXX remove this        
!addr Adr_Mode    =  2 ; $00 = C64 address, $80 = M65 flat address ; XXX adapt the implementation
!addr PCH         =  3
!addr PCL         =  4
!addr SR          =  5
!addr AC          =  6
!addr XR          =  7
!addr YR          =  8
!addr ZR          =  9
!addr BP          = 10
!addr SPH         = 11
!addr SPL         = 12


; *******************
; * Other variables *
; *******************


; A set of 32 bit variables also used as 32 bit pointer

!addr Long_AC     = $10        ; 32 bit accumulator
!addr Long_CT     = $14        ; 32 bit counter
!addr Long_PC     = $18        ; 32 bit program counter
!addr Long_DA     = $1C        ; 32 bit data pointer

; Flags are used in BBR BBS instructions

!addr Adr_Flags   = $20
!addr Mode_Flags  = $21
!addr Op_Code     = $22
!addr Op_Flag     = $23        ; 7: two operands
                               ; 6: long branch
                               ; 5: 32 bit address
                               ; 4: Q register
!addr Op_Size     = $24
!addr Dig_Cnt     = $25
!addr Buf_Index   = $26

!addr MODE_80     = $27        ; 80 column / 40 volumn flag ; XXX add routine to detect this
!addr SP_Storage  = $28        ; location to preserve stack pointer

!addr X_Vector    = $29        ; monitor exit vector
!addr Ix_Mne      = $2B        ; index to mnemonics table
!addr Op_Mne      = $2C        ; 3 bytes for mnemonic
!addr Op_Ix       = $2F        ; type of constant
!addr Op_Len      = $30        ; length of operand
!addr Disk_Track  = $31        ; logical track  1 -> 255
!addr Disk_Sector = $32        ; logical sector 0 -> 255
!addr Disk_Status = $33        ; BCD value of status

                               ; $34-$3B - free space, unused for now

!addr Long_TMP    = $3C        ; temporary pointer, for fetching/storing memory content

!addr Disk_Msg    = $40        ; 40 bytes, disk status as text message ; XXX rework code to make it not needed
!addr Mon_Data    = $68        ; 40 bytes, buffer for hunt and filename
