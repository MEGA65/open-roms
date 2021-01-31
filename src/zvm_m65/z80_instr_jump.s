
;
; Z80 jump instructions
;


Z80_instr_C3:      ; JP nn

	+Z80_FETCH_VIA_PC_INC
	tax
	+Z80_FETCH_VIA_PC_INC
	stx REG_PC+0
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

Z80_instr_E9:      ; JP (HL)

	lda REG_L+0
	sta REG_PC+0
	lda REG_L+1
	sta REG_PC+1
	jmp ZVM_next	

Z80_instr_DD_E9:   ; JP (IX)

	lda REG_IX+0
	sta REG_PC+0
	lda REG_IX+1
	sta REG_PC+1
	jmp ZVM_next	

Z80_instr_FD_E9:   ; JP (IY)

	lda REG_IY+0
	sta REG_PC+0
	lda REG_IY+1
	sta REG_PC+1
	jmp ZVM_next

Z80_instr_18:      ; JR e

	bit REG_PC+0
	bmi @1
	dec REG_PC+1
	smb7 REG_PC+0
	bra @2
@1:
	rmb7 REG_PC+0
@2:
	+Z80_FETCH_VIA_PC_INC
	tax
	lda z80_otable_displacement,x
	clc
	adc REG_PC+0
	sta REG_PC+0
	+bcc ZVM_next
	inc REG_PC+1
	jmp ZVM_next

Z80_instr_20:      ; JR NZ,e

	bbr6 REG_F,Z80_instr_18
	inw REG_PC
	jmp ZVM_next

Z80_instr_28:      ; JR Z,e

	bbs6 REG_F,Z80_instr_18
	inw REG_PC
	jmp ZVM_next

Z80_instr_30:      ; JR NC,e

	bbr0 REG_F,Z80_instr_18
	inw REG_PC
	jmp ZVM_next

Z80_instr_38:      ; JR C,e

	bbs0 REG_F,Z80_instr_18
	inw REG_PC
	jmp ZVM_next

Z80_instr_10:      ; DJNZ e

	dec REG_B
	bne Z80_instr_18
	inw REG_PC
	jmp ZVM_next
