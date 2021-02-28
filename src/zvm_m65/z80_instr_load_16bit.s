
;
; Z80 data load instructions, 16 bit
;


!macro Z80_LD_REGnn_nn .REGnn {
	+Z80_FETCH_VIA_PC_INC
	sta .REGnn+0
	+Z80_FETCH_VIA_PC_INC
	sta .REGnn+1
	jmp ZVM_next
}

Z80_instr_01:      +Z80_LD_REGnn_nn REG_BC                                     ; LD BC,nn
Z80_instr_11:      +Z80_LD_REGnn_nn REG_DE                                     ; LD DE,nn
Z80_instr_21:      +Z80_LD_REGnn_nn REG_HL                                     ; LD HL,nn
Z80_instr_31:      +Z80_LD_REGnn_nn REG_SP                                     ; LD SP,nn
Z80_instr_DD_21:   +Z80_LD_REGnn_nn REG_IX                                     ; LD IX,nn
Z80_instr_FD_21:   +Z80_LD_REGnn_nn REG_IY                                     ; LD IY,nn

!macro Z80_LD_REGnn_REGnn .REGnn1, .REGnn2 {
	lda .REGnn2+0
	sta .REGnn1+0
	lda .REGnn2+1
	sta .REGnn1+1
	jmp ZVM_next
}

Z80_instr_F9:      +Z80_LD_REGnn_REGnn REG_SP, REG_HL                          ; LD SP,HL
Z80_instr_DD_F9:   +Z80_LD_REGnn_REGnn REG_SP, REG_IX                          ; LD SP,IX
Z80_instr_FD_F9:   +Z80_LD_REGnn_REGnn REG_SP, REG_IY                          ; LD SP,IY

!macro Z80_LD_VIA_nn_REGnn .REGnn {
	ldx .REGnn+0
	+Z80_STORE_VIA_nn
	lda .REGnn+1
	+Z80_STORE_VIA_plus1
	jmp ZVM_next	
}

Z80_illeg_ED_63:                                                               ; LD (nn),HL
Z80_instr_22:      +Z80_LD_VIA_nn_REGnn REG_HL                                 ; LD (nn),HL
Z80_instr_ED_43:   +Z80_LD_VIA_nn_REGnn REG_BC                                 ; LD (nn),BC
Z80_instr_ED_53:   +Z80_LD_VIA_nn_REGnn REG_DE                                 ; LD (nn),DE
Z80_instr_DD_22:   +Z80_LD_VIA_nn_REGnn REG_IX                                 ; LD (nn),IX
Z80_instr_FD_22:   +Z80_LD_VIA_nn_REGnn REG_IY                                 ; LD (nn),IY
Z80_instr_ED_73:   +Z80_LD_VIA_nn_REGnn REG_SP                                 ; LD (nn),SP

!macro Z80_LD_REGnn_VIA_nn .REGnn {
	+Z80_FETCH_VIA_nn
	sta .REGnn+0
	+Z80_FETCH_VIA_plus1
	sta .REGnn+1
	jmp ZVM_next	
}

Z80_illeg_ED_6B:                                                               ; LD HL,(nn)
Z80_instr_2A:      +Z80_LD_REGnn_VIA_nn REG_HL                                 ; LD HL,(nn)
Z80_instr_ED_4B:   +Z80_LD_REGnn_VIA_nn REG_BC                                 ; LD BC,(nn)
Z80_instr_ED_5B:   +Z80_LD_REGnn_VIA_nn REG_DE                                 ; LD DE,(nn)
Z80_instr_DD_2A:   +Z80_LD_REGnn_VIA_nn REG_IX                                 ; LD IX,(nn)
Z80_instr_FD_2A:   +Z80_LD_REGnn_VIA_nn REG_IY                                 ; LD IY,(nn)
Z80_instr_ED_7B:   +Z80_LD_REGnn_VIA_nn REG_SP                                 ; LD SP,(nn)

!macro Z80_PUSH_REGnn .REGnn {
	lda .REGnn+1
	+Z80_STORE_STACK
	lda .REGnn+0
	+Z80_STORE_STACK
	jmp ZVM_next	
}

Z80_instr_C5:      +Z80_PUSH_REGnn REG_BC                                      ; PUSH BC
Z80_instr_D5:      +Z80_PUSH_REGnn REG_DE                                      ; PUSH DE
Z80_instr_E5:      +Z80_PUSH_REGnn REG_HL                                      ; PUSH HL
Z80_instr_F5:      +Z80_PUSH_REGnn REG_AF                                      ; PUSH AF
Z80_instr_DD_E5:   +Z80_PUSH_REGnn REG_IX                                      ; PUSH IX
Z80_instr_FD_E5:   +Z80_PUSH_REGnn REG_IY                                      ; PUSH IY

!macro Z80_POP_REGnn .REGnn {
	+Z80_FETCH_STACK
	sta .REGnn+0
	+Z80_FETCH_STACK
	lda .REGnn+1
	jmp ZVM_next
}

Z80_instr_C1:      +Z80_POP_REGnn REG_BC                                       ; POP BC
Z80_instr_D1:      +Z80_POP_REGnn REG_DE                                       ; POP DE
Z80_instr_E1:      +Z80_POP_REGnn REG_HL                                       ; POP HL
Z80_instr_F1:      +Z80_POP_REGnn REG_AF                                       ; POP AF
Z80_instr_DD_E1:   +Z80_POP_REGnn REG_IX                                       ; POP IX
Z80_instr_FD_E1:   +Z80_POP_REGnn REG_IY                                       ; POP IY
