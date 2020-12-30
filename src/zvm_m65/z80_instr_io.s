
;
; Z80 input/output instructions
;


Z80_instr_DB:                                                                  ; IN A,(n)

	jsr (VEC_fetch_via_PC_inc)
	sta ADDR_IO+0
	lda REG_A
	sta ADDR_IO+1
	jsr ZVM_fetch_IO
	sta REG_A
	jmp ZVM_next

!macro Z80_IN_REGn .REGn {
	lda REG_C
	sta ADDR_IO+0
	lda REG_B
	sta ADDR_IO+1
	jsr ZVM_fetch_IO
	sta .REGn
	tax
	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_PF - Z80_NF - Z80_XF - Z80_YF)
	ora z80_ftable_IN_OR_XOR, x
	sta REG_F
	jmp ZVM_next
}

Z80_instr_ED_40:   +Z80_IN_REGn REG_B                                          ; IN B,(C)
Z80_instr_ED_48:   +Z80_IN_REGn REG_C                                          ; IN C,(C)
Z80_instr_ED_50:   +Z80_IN_REGn REG_D                                          ; IN D,(C)
Z80_instr_ED_58:   +Z80_IN_REGn REG_E                                          ; IN E,(C)
Z80_instr_ED_60:   +Z80_IN_REGn REG_H                                          ; IN H,(C)
Z80_instr_ED_68:   +Z80_IN_REGn REG_L                                          ; IN L,(C)
Z80_instr_ED_78:   +Z80_IN_REGn REG_A                                          ; IN A,(C)

Z80_instr_D3:                                                                  ; OUT (n),A

	jsr (VEC_fetch_via_PC_inc)
	sta ADDR_IO+0
	lda REG_A
	sta ADDR_IO+1
	jsr ZVM_store_IO
	jmp ZVM_next

Z80_instr_ED_41:                                                               ; OUT (C),B

	lda REG_C
	sta ADDR_IO+0
	lda REG_B
	sta ADDR_IO+1
	jsr ZVM_store_IO
	jmp ZVM_next

Z80_instr_ED_49:                                                               ; OUT (C),C

	lda REG_B
	sta ADDR_IO+1
	lda REG_C
	sta ADDR_IO+0
	jsr ZVM_store_IO
	jmp ZVM_next

!macro Z80_OUT_REGn .REGn {
	lda REG_C
	sta ADDR_IO+0
	lda REG_B
	sta ADDR_IO+1
	lda .REGn 
	jsr ZVM_store_IO
	jmp ZVM_next
}

Z80_instr_ED_51:   +Z80_OUT_REGn REG_D                                         ; OUT (C),D
Z80_instr_ED_59:   +Z80_OUT_REGn REG_E                                         ; OUT (C),E
Z80_instr_ED_61:   +Z80_OUT_REGn REG_H                                         ; OUT (C),H
Z80_instr_ED_69:   +Z80_OUT_REGn REG_L                                         ; OUT (C),L
Z80_instr_ED_79:   +Z80_OUT_REGn REG_A                                         ; OUT (C),A
