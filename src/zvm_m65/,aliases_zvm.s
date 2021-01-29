
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
!addr REG_BC_EXT             = $06               ; 2 bytes - helper for faster access via BC in bank 1

!addr REG_DE                 = $08               ; 2 bytes - combined register
!addr REG_E                  = REG_DE+0
!addr REG_D                  = REG_DE+1
!addr REG_DE_EXT             = $0A               ; 2 bytes - helper for faster access via DE in bank 1

!addr REG_HL                 = $0C               ; 2 bytes - combined register
!addr REG_L                  = REG_HL+0
!addr REG_H                  = REG_HL+1
!addr REG_HL_EXT             = $0E               ; 2 bytes - helper for faster access via HL in bank 1

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
!addr REG_SP_EXT             = $1A               ; 2 bytes - helper for faster access via SP in bank 1
!addr REG_PC                 = $1C               ; 2 bytes - sprogram counter
!addr REG_PC_EXT             = $1E               ; 2 bytes - helper for faster access via PC in bank 1

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

!addr BANK_ID                = $29               ; 1 byte  - currently selected memory bank

!addr z80_cpustate__end      = $29

;
; Z80 emulation temporary area
;

!addr PTR_IXY_d              = $2A               ; 4 bytes - calculated address IX+d / IY+d
!addr PTR_DATA               = $2E               ; 4 bytes - calculated data source address
!addr ADDR_IO                = $32               ; 2 bytes - address for fetching/storing the IO

!addr REG_TMP1               = $34               ; 1 byte  - emulation-specific temporary storage
!addr REG_TMP2               = $35               ; 1 byte  - emulation-specific temporary storage
 
;                              $36               ; for now free till $3F (inclusive)

;
; BIOS data
;

; Reuse data for loading

!addr BIOS_IOBUFERPTR        = $40               ; 4 bytes - pointer to hardware I/O buffer
!addr BIOS_LOADPTR           = $44               ; 4 bytes - pointer for loading data
!addr BIOS_LOADCOUNT         = $48               ; 2 bytes - counter used for loading data

; XXX are the values below needed?

!addr VEC_MOVE_fetch         = $4A               ; 2 bytes - vector to byte fetch routine, for BIOS routine MOVE
!addr VEC_MOVE_store         = $4C               ; 2 bytes - vector to byte store routine, for BIOS routine MOVE
!addr VEC_DISKIO_store       = $4E               ; 2 bytes - vector to byte store routine, for BIOS disk I/O operations


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
; Macros to abstract memory access
;

!macro Z80_FETCH_VIA_PC_INC {                    ; fetch to .A from (PC), increment PC afterwards

	lda [REG_PC], z
	inw REG_PC
}

!macro Z80_FETCH_STACK {                         ; fetch to .A - stack POP operation

	lda [REG_SP], z
	inw REG_SP
}

!macro Z80_STORE_STACK {                         ; store .A - stack PUSH operation

	dew REG_SP
	sta [REG_SP], z
}

!macro Z80_FETCH_VIA_BC {                        ; fetch to .A from (BC)

	lda [REG_BC], z	
}

!macro Z80_STORE_VIA_BC {                        ; store .A to (BC)

	sta [REG_BC], z	
} 

!macro Z80_FETCH_VIA_DE {                        ; fetch to .A from (DE)

	lda [REG_DE], z	
}

!macro Z80_STORE_VIA_DE {                        ; store .A to (DE)

	sta [REG_DE], z	
} 

!macro Z80_FETCH_VIA_HL {                        ; fetch to .A from (HL)

	lda [REG_HL], z
}

!macro Z80_STORE_VIA_HL {                        ; store .A to (HL)

	sta [REG_HL], z
}

!macro Z80_STORE_BACK_VIA_HL {                   ; store .A to (HL) when instruction already used Z80_FETCH_VIA_HL

	sta [REG_HL], z
}

!macro Z80_FETCH_VIA_nn {                        ; fetch to .A from ((PC))

	lda [REG_PC], z
	sta PTR_DATA+0
	inw REG_PC
	lda [REG_PC], z
	sta PTR_DATA+1
	inw REG_PC

	lda [PTR_DATA], z
}

!macro Z80_STORE_VIA_nn {                        ; store .X to ((PC))

	lda [REG_PC], z
	sta PTR_DATA+0
	inw REG_PC
	lda [REG_PC], z
	sta PTR_DATA+1
	inw REG_PC

	txa
	lda [PTR_DATA], z
}

!macro Z80_FETCH_VIA_plus1 {                     ; fetch to .A from [PTR_DATA+1]

	inw PTR_DATA
	lda [PTR_DATA], z
}

!macro Z80_STORE_VIA_plus1 {                     ; store .A to [PTR_DATA+1]

	inw PTR_DATA
	sta [PTR_DATA], z
}

!macro Z80_XCHG_VIA_SP_lo {                      ; for exchange via stack only

	lda [REG_SP], z
	tay
	txa
	sta [REG_SP], z 
}

!macro Z80_XCHG_VIA_SP_hi {                      ; for exchange via stack only

	inz
	lda [REG_SP], z
	tay
	txa
	sta [REG_SP], z
	dez
}

!macro Z80_FETCH_VIA_IX_d {                      ; fetch to .A using IX and displacement

	jsr Z80_common_fetch_via_IX_d
}

!macro Z80_FETCH_VIA_IY_d {                      ; fetch to .A using IY and displacement

	jsr Z80_common_fetch_via_IY_d
}

!macro Z80_STORE_VIA_IX_d {                      ; store .X using IX and displacement

	jsr Z80_common_store_via_IX_d
}

!macro Z80_STORE_VIA_IY_d {                      ; store .X using IY and displacement

	jsr Z80_common_store_via_IY_d
}