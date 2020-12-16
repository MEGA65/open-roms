
!addr REG_A              = $02    ; 8-bit accumulator
!addr REG_F              = $03    ; 8-bit flag register
!addr REG_B              = $04    ; general purpose 8-bit registers
!addr REG_C              = $05
!addr REG_D              = $06
!addr REG_E              = $07
!addr REG_H              = $08
!addr REG_L              = $09

!addr REG_A_SH           = $0A    ; shadow registers
!addr REG_F_SH           = $0B
!addr REG_B_SH           = $0C
!addr REG_C_SH           = $0D
!addr REG_D_SH           = $0E
!addr REG_E_SH           = $0F
!addr REG_H_SH           = $10
!addr REG_L_SH           = $11

!addr REG_IX             = $12    ; 16-bit index register
!addr REG_IY             = $14    ; 16-bit index register
!addr REG_SP             = $16    ; 16-bit stack pointer
!addr REG_PC             = $18    ; 16-bit program counter

!addr REG_I              = $1A    ; 8-bit interrupt vector base
!addr REG_R06            = $1B    ; refresh counter, bits 0-6 (bit 7 is garbage)
!addr REG_R7             = $1C    ; refresh counter, bit 7 (bits 0-6 are 0's)

!addr VEC_fetch_opcode   = $60
!addr VEC_fetch_value    = $62
!addr VEC_fetch_stack    = $64
!addr VEC_store_stack    = $66
!addr VEC_fetch_via_HL   = $68
!addr VEC_store_via_HL   = $6A
!addr VEC_fetch_via_IX_d = $6C
!addr VEC_fetch_via_IY_d = $6E
!addr VEC_store_via_IX_d = $70
!addr VEC_store_via_IY_d = $72
!addr VEC_fetch_via_nn   = $74
!addr VEC_store_via_nn   = $76
