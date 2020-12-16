
;
; Z80 data load instructions, 8 bit
;


Z80_instr_41:      ; LD B,C

	lda REG_C
	sta REG_B
	rts

Z80_instr_42:      ; LD B,D

	lda REG_D
	sta REG_B
	rts

Z80_instr_43:      ; LD B,E

	lda REG_E
	sta REG_B
	rts

Z80_instr_44:      ; LD B,H

	lda REG_H
	sta REG_B
	rts

Z80_instr_45:      ; LD B,L

	lda REG_L
	sta REG_B
	rts

Z80_instr_46:      ; LD B,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_B
	rts

Z80_instr_47:      ; LD B,A

	lda REG_A
	sta REG_B
	rts

Z80_instr_48:      ; LD C,B

	lda REG_B
	sta REG_C
	rts

Z80_instr_4A:      ; LD C,D

	lda REG_D
	sta REG_C
	rts

Z80_instr_4B:      ; LD C,E

	lda REG_E
	sta REG_C
	rts

Z80_instr_4C:      ; LD C,H

	lda REG_H
	sta REG_C
	rts

Z80_instr_4D:      ; LD C,L

	lda REG_L
	sta REG_C
	rts

Z80_instr_4E:      ; LD C,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_C
	rts

Z80_instr_4F:      ; LD C,A

	lda REG_Z
	sta REG_C
	rts

Z80_instr_50:      ; LD D,B

	lda REG_B
	sta REG_D
	rts

Z80_instr_51:      ; LD D,C

	lda REG_C
	sta REG_D
	rts

Z80_instr_53:      ; LD D,E

	lda REG_E
	sta REG_D
	rts

Z80_instr_54:      ; LD D,H

	lda REG_H
	sta REG_D
	rts

Z80_instr_55:      ; LD D,L

	lda REG_L
	sta REG_D
	rts

Z80_instr_56:      ; LD D,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_D
	rts

Z80_instr_57:      ; LD D,A

	lda REG_A
	sta REG_D
	rts

Z80_instr_58:      ; LD E,B

	lda REG_B
	sta REG_E
	rts

Z80_instr_59:      ; LD E,C

	lda REG_C
	sta REG_E
	rts

Z80_instr_5A:      ; LD E,D

	lda REG_D
	sta REG_E
	rts

Z80_instr_5C:      ; LD E,H

	lda REG_H
	sta REG_E
	rts

Z80_instr_5D:      ; LD E,L

	lda REG_L
	sta REG_E
	rts

Z80_instr_5E:      ; LD E,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_E
	rts

Z80_instr_5F:      ; LD E,A

	lda REG_A
	sta REG_E
	rts

Z80_instr_60:      ; LD H,B

	lda REG_B
	sta REG_H
	rts

Z80_instr_61:      ; LD H,C

	lda REG_C
	sta REG_H
	rts

Z80_instr_62:      ; LD H,D

	lda REG_D
	sta REG_H
	rts

Z80_instr_63:      ; LD H,E

	lda REG_E
	sta REG_H
	rts

Z80_instr_65:      ; LD H,L

	lda REG_L
	sta REG_H
	rts

Z80_instr_66:      ; LD H,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_H
	rts

Z80_instr_67:      ; LD H,A

	lda REG_A
	sta REG_H
	rts

Z80_instr_68:      ; LD L,B

	lda REG_B
	sta REG_L
	rts

Z80_instr_69:      ; LD L,C

	lda REG_C
	sta REG_L
	rts

Z80_instr_6A:      ; LD L,D

	lda REG_D
	sta REG_L
	rts

Z80_instr_6B:      ; LD L,E

	lda REG_E
	sta REG_L
	rts

Z80_instr_6C:      ; LD L,H

	lda REG_H
	sta REG_L
	rts

Z80_instr_6E:      ; LD L,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_L
	rts

Z80_instr_6F:      ; LD L,A

	lda REG_A
	sta REG_L
	rts

Z80_instr_70:      ; LD (HL),B

	lda REG_B
	jmp (VEC_store_via_HL)

Z80_instr_71:      ; LD (HL),C

	lda REG_C
	jmp (VEC_store_via_HL)

Z80_instr_72:      ; LD (HL),D

	lda REG_D
	jmp (VEC_store_via_HL)

Z80_instr_73:      ; LD (HL),E

	lda REG_E
	jmp (VEC_store_via_HL)

Z80_instr_74:      ; LD (HL),H

	lda REG_H
	jmp (VEC_store_via_HL)

Z80_instr_75:      ; LD (HL),L

	lda REG_L
	jmp (VEC_store_via_HL)

Z80_instr_77:      ; LD (HL),A

	lda REG_A
	jmp (VEC_store_via_HL)

Z80_instr_78:      ; LD A,B

	lda REG_B
	sta REG_A
	rts

Z80_instr_79:      ; LD A,C

	lda REG_C
	sta REG_A
	rts

Z80_instr_7A:      ; LD A,D

	lda REG_D
	sta REG_A
	rts

Z80_instr_7B:      ; LD A,E

	lda REG_E
	sta REG_A
	rts

Z80_instr_7C:      ; LD A,H

	lda REG_H
	sta REG_A
	rts

Z80_instr_7D:      ; LD A,L

	lda REG_L
	sta REG_A
	rts

Z80_instr_7E:      ; LD A,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_A
	rts
