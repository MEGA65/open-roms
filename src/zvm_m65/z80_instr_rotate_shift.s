
;
; Z80 rotate/shift instructions
;


Z80_instr_07:      ; RLCA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF)
	sta REG_F

	asl REG_A
	+bcc ZVM_next
	inc REG_A
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_17:      ; RLA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF)
	sta REG_F

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol REG_A
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_0F:      ; RRCA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF)
	sta REG_F

	clc
	ror REG_A
	+bcc ZVM_next
	smb7 REG_A
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_1F:      ; RRA

	lda REG_F
	and #($FF - Z80_HF - Z80_NF - Z80_CF)
	sta REG_F

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror REG_A
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next

