
;
; Z80 data load instructions, 16 bit
;


!macro Z80_PUSH_REGnn .REGnn {
	lda .REGnn+1
	jsr (VEC_store_stack)
	lda .REGnn+0
	jsr (VEC_store_stack)
	jmp ZVM_next	
}

Z80_instr_C5:      +Z80_PUSH_REGnn REG_BC                                      ; PUSH BC
Z80_instr_D5:      +Z80_PUSH_REGnn REG_DE                                      ; PUSH DE
Z80_instr_E5:      +Z80_PUSH_REGnn REG_HL                                      ; PUSH HL
Z80_instr_F5:      +Z80_PUSH_REGnn REG_AF                                      ; PUSH AF
Z80_instr_DD_E5:   +Z80_PUSH_REGnn REG_IX                                      ; PUSH IX
Z80_instr_FD_E5:   +Z80_PUSH_REGnn REG_IY                                      ; PUSH IY

!macro Z80_POP_REGnn .REGnn {
	jsr (VEC_fetch_stack)
	sta .REGnn+0
	jsr (VEC_fetch_stack)
	lda .REGnn+1
	jmp ZVM_next
}

Z80_instr_C1:      +Z80_POP_REGnn REG_BC                                       ; POP BC
Z80_instr_D1:      +Z80_POP_REGnn REG_DE                                       ; POP DE
Z80_instr_E1:      +Z80_POP_REGnn REG_HL                                       ; POP HL
Z80_instr_F1:      +Z80_POP_REGnn REG_AF                                       ; POP AF
Z80_instr_DD_E1:   +Z80_POP_REGnn REG_IX                                       ; POP IX
Z80_instr_FD_E1:   +Z80_POP_REGnn REG_IY                                       ; POP IY