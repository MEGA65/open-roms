
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
!addr REG_C_SH           = $0C
!addr REG_B_SH           = $0D
!addr REG_E_SH           = $0E
!addr REG_D_SH           = $0F
!addr REG_L_SH           = $10
!addr REG_H_SH           = $11

!addr REG_IX             = $12    ; 16-bit index register
!addr REG_IY             = $14    ; 16-bit index register
!addr REG_SP             = $16    ; 16-bit stack pointer
!addr REG_PC             = $18    ; 16-bit program counter

!addr REG_I              = $1A    ; 8-bit interrupt vector base
!addr REG_R06            = $1B    ; refresh counter, bits 0-6 (bit 7 is garbage)
!addr REG_R7             = $1C    ; refresh counter, bit 7 (bits 0-6 are 0's)

!addr PTR_IXY_d          = $1D    ; 16-bit calculated address IX+d / IY+d  XXX - important!!!
!addr PTR_DATA           = $1F    ; data source address                    XXX - important!!!


!addr REG_IFF1           = $23    ; interrupt flip-flop flag 1
!addr REG_IFF2           = $24    ; interrupt flip-flop flag 2

!addr VEC_fetch_value    = $60
!addr VEC_fetch_stack    = $62
!addr VEC_store_stack    = $64
!addr VEC_fetch_via_HL   = $66
!addr VEC_store_via_HL   = $68
!addr VEC_fetch_via_IX_d = $6A
!addr VEC_fetch_via_IY_d = $6C
!addr VEC_store_via_IX_d = $6E
!addr VEC_store_via_IY_d = $70
!addr VEC_fetch_via_nn   = $72
!addr VEC_store_via_nn   = $74

; Masks for Z80 flag (F) register

!set Z80_SF = %10000000 ; sign 
!set Z80_ZF = %01000000 ; zero
!set Z80_YF = %00100000 ; bit 5 result
!set Z80_HF = %00010000 ; half carry
!set Z80_XF = %00001000 ; bit 3 result
!set Z80_PF = %00000100 ; parity
!set Z80_VF = %00000100 ; overflow
!set Z80_NF = %00000010 ; subtract
!set Z80_CF = %00000001 ; carry

; Macros to set/reset flags - to avoid mistakes

!macro Z80_PUT_1_SF { smb7 REG_F }
!macro Z80_PUT_0_SF { rmb7 REG_F }
!macro Z80_PUT_1_ZF { smb6 REG_F }
!macro Z80_PUT_0_ZF { rmb6 REG_F }
!macro Z80_PUT_1_YF { smb5 REG_F }
!macro Z80_PUT_0_YF { rmb5 REG_F }
!macro Z80_PUT_1_HF { smb4 REG_F }
!macro Z80_PUT_0_HF { rmb4 REG_F }
!macro Z80_PUT_1_XF { smb3 REG_F }
!macro Z80_PUT_0_XF { rmb3 REG_F }
!macro Z80_PUT_1_PF { smb2 REG_F }
!macro Z80_PUT_0_PF { rmb2 REG_F }
!macro Z80_PUT_1_VF { smb2 REG_F }
!macro Z80_PUT_0_VF { rmb2 REG_F }
!macro Z80_PUT_1_NF { smb1 REG_F }
!macro Z80_PUT_0_NF { rmb1 REG_F }
!macro Z80_PUT_1_CF { smb0 REG_F }
!macro Z80_PUT_0_CF { rmb0 REG_F }
