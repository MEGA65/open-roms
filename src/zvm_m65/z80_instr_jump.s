
;
; Z80 jump instructions
;


Z80_instr_C3:      ; JP nn

	jsr (VEC_fetch_value)
	sta REG_PC+0
	jsr (VEC_fetch_value)
	sta REG_PC+1
	jmp ZVM_next

Z80_instr_C2:      ; JP NZ,nn

	bbr6 REG_F,Z80_instr_C3
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_CA:      ; JP Z,nn

	bbs6 REG_F,Z80_instr_C3
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_D2:      ; JP NC,nn

	bbr0 REG_F,Z80_instr_C3
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_DA:      ; JP C,nn

	bbs0 REG_F,Z80_instr_C3
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_E2:      ; JP PO,nn

	bbr2 REG_F,Z80_instr_C3
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_EA:      ; JP PE,nn

	bbs2 REG_F,Z80_instr_C3
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_F2:      ; JP P,nn

	bbr7 REG_F,Z80_instr_C3
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_FA:      ; JP M,nn

	bbs7 REG_F,Z80_instr_C3
	inw REG_PC
	inw REG_PC
	jmp ZVM_next
