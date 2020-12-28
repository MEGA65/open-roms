
;
; Z80 rotate/shift instructions
;


Z80_instr_07:      ; RLCA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF - Z80_XF - Z80_YF)
	sta REG_F

	asl REG_A
	lda REG_A
	and #%00101000
	ora REG_F
	sta REG_F
	+bcc ZVM_next
	inc REG_A
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_17:      ; RLA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF - Z80_XF - Z80_YF)
	sta REG_F

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol REG_A
	lda REG_A
	and #%00101000
	ora REG_F
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_0F:      ; RRCA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF - Z80_XF - Z80_YF)
	sta REG_F

	clc
	ror REG_A
	lda REG_A
	and #%00101000
	ora REG_F
	sta REG_F
	+bcc ZVM_next
	smb7 REG_A
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_1F:      ; RRA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF - Z80_XF - Z80_YF)
	sta REG_F

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror REG_A
	lda REG_A
	and #%00101000
	ora REG_F
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next


!macro Z80_RLC_REGn .REGn {

	clc
	bbr7 .REGn, @1
	sec
@1:
	rol .REGn
	
	ldx .REGn
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_instr_CB_00:   +Z80_RLC_REGn REG_B                                         ; RLC B
Z80_instr_CB_01:   +Z80_RLC_REGn REG_C                                         ; RLC C
Z80_instr_CB_02:   +Z80_RLC_REGn REG_D                                         ; RLC D
Z80_instr_CB_03:   +Z80_RLC_REGn REG_E                                         ; RLC E
Z80_instr_CB_04:   +Z80_RLC_REGn REG_H                                         ; RLC H
Z80_instr_CB_05:   +Z80_RLC_REGn REG_L                                         ; RLC L
Z80_instr_CB_07:   +Z80_RLC_REGn REG_A                                         ; RLC A

!macro Z80_RRC_REGn .REGn {

	clc
	bbr0 .REGn, @1
	sec
@1:
	ror .REGn
	
	ldx .REGn
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_instr_CB_08:   +Z80_RRC_REGn REG_B                                         ; RRC B
Z80_instr_CB_09:   +Z80_RRC_REGn REG_C                                         ; RRC C
Z80_instr_CB_0A:   +Z80_RRC_REGn REG_D                                         ; RRC D
Z80_instr_CB_0B:   +Z80_RRC_REGn REG_E                                         ; RRC E
Z80_instr_CB_0C:   +Z80_RRC_REGn REG_H                                         ; RRC H
Z80_instr_CB_0D:   +Z80_RRC_REGn REG_L                                         ; RRC L
Z80_instr_CB_0F:   +Z80_RRC_REGn REG_A                                         ; RRC A

!macro Z80_RL_REGn .REGn {

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol .REGn
	
	ldx .REGn
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_instr_CB_10:   +Z80_RL_REGn REG_B                                          ; RL B
Z80_instr_CB_11:   +Z80_RL_REGn REG_C                                          ; RL C 
Z80_instr_CB_12:   +Z80_RL_REGn REG_D                                          ; RL D
Z80_instr_CB_13:   +Z80_RL_REGn REG_E                                          ; RL E
Z80_instr_CB_14:   +Z80_RL_REGn REG_H                                          ; RL H
Z80_instr_CB_15:   +Z80_RL_REGn REG_L                                          ; RL L
Z80_instr_CB_17:   +Z80_RL_REGn REG_A                                          ; RL A

!macro Z80_RR_REGn .REGn {

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror .REGn
	
	ldx .REGn
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_instr_CB_18:   +Z80_RR_REGn REG_B                                          ; RR B
Z80_instr_CB_19:   +Z80_RR_REGn REG_C                                          ; RR C
Z80_instr_CB_1A:   +Z80_RR_REGn REG_D                                          ; RR D
Z80_instr_CB_1B:   +Z80_RR_REGn REG_E                                          ; RR E
Z80_instr_CB_1C:   +Z80_RR_REGn REG_H                                          ; RR H
Z80_instr_CB_1D:   +Z80_RR_REGn REG_L                                          ; RR L
Z80_instr_CB_1F:   +Z80_RR_REGn REG_A                                          ; RR A

; XXX SLA/SLL (and possibly rotations) can be made slightly faster with dedicated tables (omit carry flag calculation)

!macro Z80_SLA_REGn .REGn {

	asl .REGn
	
	ldx .REGn
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_instr_CB_20:   +Z80_SLA_REGn REG_B                                         ; SLA B
Z80_instr_CB_21:   +Z80_SLA_REGn REG_C                                         ; SLA C
Z80_instr_CB_22:   +Z80_SLA_REGn REG_D                                         ; SLA D
Z80_instr_CB_23:   +Z80_SLA_REGn REG_E                                         ; SLA E
Z80_instr_CB_24:   +Z80_SLA_REGn REG_H                                         ; SLA H
Z80_instr_CB_25:   +Z80_SLA_REGn REG_L                                         ; SLA L
Z80_instr_CB_27:   +Z80_SLA_REGn REG_A                                         ; SLA A

!macro Z80_SLL_REGn .REGn {

	sec
	rol .REGn
	
	ldx .REGn
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_illeg_CB_30:   +Z80_SLL_REGn REG_B                                         ; SLL B
Z80_illeg_CB_31:   +Z80_SLL_REGn REG_C                                         ; SLL C
Z80_illeg_CB_32:   +Z80_SLL_REGn REG_D                                         ; SLL D
Z80_illeg_CB_33:   +Z80_SLL_REGn REG_E                                         ; SLL E
Z80_illeg_CB_34:   +Z80_SLL_REGn REG_H                                         ; SLL H
Z80_illeg_CB_35:   +Z80_SLL_REGn REG_L                                         ; SLL L
Z80_illeg_CB_37:   +Z80_SLL_REGn REG_A                                         ; SLL A

!macro Z80_SRL_REGn .REGn {

	clc
	ror .REGn
	
	ldx .REGn
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_instr_CB_38:   +Z80_SRL_REGn REG_B                                         ; SRL B
Z80_instr_CB_39:   +Z80_SRL_REGn REG_C                                         ; SRL C
Z80_instr_CB_3A:   +Z80_SRL_REGn REG_D                                         ; SRL D
Z80_instr_CB_3B:   +Z80_SRL_REGn REG_E                                         ; SRL E
Z80_instr_CB_3C:   +Z80_SRL_REGn REG_H                                         ; SRL H
Z80_instr_CB_3D:   +Z80_SRL_REGn REG_L                                         ; SRL L
Z80_instr_CB_3F:   +Z80_SRL_REGn REG_A                                         ; SRL A

!macro Z80_SRA_REGn .REGn {

	clc
	bbr7 .REGn, @1
	sec
@1:
	ror .REGn
	
	ldx .REGn
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_instr_CB_28:   +Z80_SRA_REGn REG_B; SRA B
Z80_instr_CB_29:   +Z80_SRA_REGn REG_C; SRA C
Z80_instr_CB_2A:   +Z80_SRA_REGn REG_D; SRA D
Z80_instr_CB_2B:   +Z80_SRA_REGn REG_E; SRA E
Z80_instr_CB_2C:   +Z80_SRA_REGn REG_H; SRA H
Z80_instr_CB_2D:   +Z80_SRA_REGn REG_L; SRA L
Z80_instr_CB_2F:   +Z80_SRA_REGn REG_A; SRA A


