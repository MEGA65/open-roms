
;
; Z80 CPU state/emulation data
;

!addr z80_cpustate__start    = $02

!addr REG_AF                 = $02               ; 2 bytes - combined register
!addr REG_F                  = REG_AF+0          ;         - flag register
!addr REG_A                  = REG_AF+1          ;         - accumulator

!addr REG_BC                 = $04               ; 2 bytes - combined register
!addr REG_C                  = REG_BC+0
!addr REG_B                  = REG_BC+1
!addr REG_BC_EXT1            = $06               ; 2 bytes - helper for faster access via BC in bank 1

!addr REG_DE                 = $08               ; 2 bytes - combined register
!addr REG_E                  = REG_DE+0
!addr REG_D                  = REG_DE+1
!addr REG_DE_EXT1            = $0A               ; 2 bytes - helper for faster access via DE in bank 1

!addr REG_HL                 = $0C               ; 2 bytes - combined register
!addr REG_L                  = REG_HL+0
!addr REG_H                  = REG_HL+1
!addr REG_HL_EXT1            = $0E               ; 2 bytes - helper for faster access via HL in bank 1

!addr REG_SHADOW             = $10               ; 8 bytes - shadow registers
!addr REG_F_SH               = REG_SHADOW+0
!addr REG_A_SH               = REG_SHADOW+1
!addr REG_C_SH               = REG_SHADOW+2
!addr REG_B_SH               = REG_SHADOW+3
!addr REG_E_SH               = REG_SHADOW+4
!addr REG_D_SH               = REG_SHADOW+5
!addr REG_L_SH               = REG_SHADOW+6
!addr REG_H_SH               = REG_SHADOW+7

!addr REG_SP                 = $18               ; 2 bytes - stack pointer
!addr REG_SP_EXT1            = $1A               ; 2 bytes - helper for faster access via SP in bank 1
!addr REG_PC                 = $1C               ; 2 bytes - sprogram counter
!addr REG_PC_EXT1            = $1E               ; 2 bytes - helper for faster access via PC in bank 1

!addr REG_IX                 = $20               ; 2 bytes - index register
!addr REG_IXL                = REG_IX+0
!addr REG_IXH                = REG_IX+1
!addr REG_IY                 = $22               ; 2 bytes - index register
!addr REG_IYL                = REG_IY+0
!addr REG_IYH                = REG_IY+1

!addr REG_IFF1               = $24               ; 1 byte  - interrupt flip-flop flag 1
!addr REG_IFF2               = $25               ; 1 byte  - interrupt flip-flop flag 2
!addr REG_R06                = $26               ; 1 byte  - refresh counter, bits 0-6 (bit 7 is garbage)
!addr REG_R7                 = $27               ; 1 byte  - refresh counter, bit 7 (bits 0-6 are garbage)
!addr REG_I                  = $28               ; 1 byte  - interrupt vector base

!addr z80_cpustate__end      = $28

!addr BANK_ID                = $29               ; 1 byte - currently selected bank

;
; BIOS vectors
;

!addr VEC_MOVE_fetch         = $2A               ; 2 bytes - vector to byte fetch routine, for BIOS routine MOVE
!addr VEC_MOVE_store         = $2C               ; 2 bytes - vector to byte store routine, for BIOS routine MOVE
!addr VEC_DISKIO_store       = $2E               ; 2 bytes - vector to byte store routine, for BIOS disk I/O operations

;
; Z80 emulation temporary area
;

!addr PTR_IXY_d              = $30               ; 4 bytes - calculated address IX+d / IY+d       XXX - review usage !!!
!addr PTR_IXY_d_EXT1         = PTR_IXY_d+2
!addr PTR_DATA               = $34               ; 4 bytes - calculated data source address       XXX - review usage !!! also check functions using ZVM_store_next
!addr PTR_DATA_EXT1          = PTR_DATA+2
!addr ADDR_IO                = $38               ; 4 bytes - address for fetching/storing the IO

!addr REG_TMP1               = $3C               ; 1 byte  - emulation-specific temporary storage
!addr REG_TMP2               = $3D               ; 1 byte  - emulation-specific temporary storage
 
;                              $3E               ; 2 bytes - reserved

;
; Memory banking vectors
;

!addr zvm_bankvectors__start = $40

!addr VEC_fetch_via_PC_inc   = $40               ; fetch to .A from (PC), increment PC afterwards      XXX consider providing dual-byte retrieval

; XXX implement routines for vectors below

!addr VEC_fetch_stack        = $42
!addr VEC_store_stack        = $44
!addr VEC_fetch_via_BC       = $46 
!addr VEC_store_via_BC       = $48
!addr VEC_fetch_via_DE       = $4A
!addr VEC_store_via_DE       = $4C
!addr VEC_fetch_via_HL       = $4E
!addr VEC_fetch_via_HL_back  = $50  ; forces PTR_DATA update
!addr VEC_store_via_HL       = $52
!addr VEC_fetch_via_IX_d     = $54
!addr VEC_fetch_via_IY_d     = $56
!addr VEC_store_via_IX_d     = $58
!addr VEC_store_via_IY_d     = $5A
!addr VEC_fetch_via_nn       = $5C
!addr VEC_store_via_nn       = $5E
!addr VEC_fetch_via_plus1    = $60
!addr VEC_store_via_plus1    = $62  ; XXX jump to next directly?
!addr VEC_xchng_stack_lo     = $64
!addr VEC_xchng_stack_hi     = $68

;
; Constant/macros definitions
;

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

;
; Helper tables for CPU emulation, downwards from $2000
;

!addr z80_atable_mi_bank0         = $1FF0        ; table for bank 0 memory address conversion
!addr z80_atable_hi_bank0         = $1FE0        ; table for bank 0 memory address conversion
