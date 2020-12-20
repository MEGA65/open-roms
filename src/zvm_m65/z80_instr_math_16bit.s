
;
; Z80 arithmetic instructions, 16 bit
;


Z80_instr_03:      ; INC BC

	inw REG_BC
	jmp ZVM_next

Z80_instr_13:      ; INC DE

	inw REG_DE
	jmp ZVM_next

Z80_instr_23:      ; INC HL

	inw REG_HL
	jmp ZVM_next

Z80_instr_33:      ; INC SP

	inw REG_SP
	jmp ZVM_next

Z80_instr_DD_23:   ; INC IX

	inw REG_IX
	jmp ZVM_next

Z80_instr_FD_23:   ; INC IY

	inw REG_IY
	jmp ZVM_next

Z80_instr_0B:      ; DEC BC

	dew REG_BC
	jmp ZVM_next

Z80_instr_1B:      ; DEC DE

	dew REG_DE
	jmp ZVM_next

Z80_instr_2B:      ; DEC HL

	dew REG_HL
	jmp ZVM_next

Z80_instr_3B:      ; DEC SP

	dew REG_SP
	jmp ZVM_next

Z80_instr_DD_2B:   ; DEC IX

	dew REG_IX
	jmp ZVM_next

Z80_instr_FD_2B:   ; DEC IY

	dew REG_IY
	jmp ZVM_next
