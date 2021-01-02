
;
; Z80 call/return instructions
;


Z80_instr_CD:      ; CALL nn

	+Z80_FETCH_VIA_PC_INC
	tax
	+Z80_FETCH_VIA_PC_INC
	tay

	lda REG_PC+1
	+Z80_STORE_STACK
	lda REG_PC+0
	+Z80_STORE_STACK

	tya
	sta REG_PC+1
	txa
	sta REG_PC+0
	jmp ZVM_next	
	
Z80_instr_C4:      ; CALL NZ,nn

	bbr6 REG_F,Z80_instr_CD
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_CC:      ; CALL Z,nn

	bbs6 REG_F,Z80_instr_CD
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_D4:      ; CALL NC,nn

	bbr0 REG_F,Z80_instr_CD
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_DC:      ; CALL C,nn

	bbs0 REG_F,Z80_instr_CD
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_E4:      ; CALL PO,nn

	bbr2 REG_F,Z80_instr_CD
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_EC:      ; CALL PE,nn

	bbs2 REG_F,Z80_instr_CD
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_F4:      ; CALL P,nn

	bbr7 REG_F,Z80_instr_CD
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_FC:      ; CALL M,nn

	bbs7 REG_F,Z80_instr_CD
	inw REG_PC
	inw REG_PC
	jmp ZVM_next

Z80_instr_ED_45:   ; RETN
Z80_illeg_ED_55:   ; RETN
Z80_illeg_ED_5D:   ; RETN
Z80_illeg_ED_65:   ; RETN
Z80_illeg_ED_6D:   ; RETN
Z80_illeg_ED_75:   ; RETN
Z80_illeg_ED_7D:   ; RETN

	lda REG_IFF2
	sta REG_IFF1

Z80_instr_ED_4D:   ; RETTI
Z80_instr_C9:      ; RET

	+Z80_FETCH_STACK
	sta REG_PC+0
	+Z80_FETCH_STACK
	sta REG_PC+1
	jmp ZVM_next

Z80_instr_C0:      ; RET NZ

	bbr6 REG_F,Z80_instr_C9
	jmp ZVM_next

Z80_instr_C8:      ; RET Z

	bbs6 REG_F,Z80_instr_C9
	jmp ZVM_next

Z80_instr_D0:      ; RET NC

	bbr0 REG_F,Z80_instr_C9
	jmp ZVM_next

Z80_instr_D8:      ; RET C

	bbs0 REG_F,Z80_instr_C9
	jmp ZVM_next

Z80_instr_E0:      ; RET PO

	bbr2 REG_F,Z80_instr_C9
	jmp ZVM_next

Z80_instr_E8:      ; RET PE

	bbs2 REG_F,Z80_instr_C9
	jmp ZVM_next

Z80_instr_F0:      ; RET P

	bbr7 REG_F,Z80_instr_C9
	jmp ZVM_next

Z80_instr_F8:      ; RET M

	bbs7 REG_F,Z80_instr_C9
	jmp ZVM_next


!macro Z80_RST .P {

	lda REG_PC+1
	+Z80_STORE_STACK
	lda REG_PC+0
	+Z80_STORE_STACK
	lda #$00
	sta REG_PC+1
	lda #.P
	sta REG_PC+0
    jmp ZVM_next	
} 

Z80_instr_C7:      +Z80_RST $00                                                ; RST 00H
Z80_instr_CF:      +Z80_RST $08                                                ; RST 08H
Z80_instr_D7:      +Z80_RST $10                                                ; RST 10H
Z80_instr_DF:      +Z80_RST $18                                                ; RST 18H
Z80_instr_E7:      +Z80_RST $20                                                ; RST 20H
Z80_instr_EF:      +Z80_RST $28                                                ; RST 28H
Z80_instr_F7:      +Z80_RST $30                                                ; RST 30H
Z80_instr_FF:      +Z80_RST $38                                                ; RST 38H
