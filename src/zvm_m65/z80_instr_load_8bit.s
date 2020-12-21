
;
; Z80 data load instructions, 8 bit
;


!macro Z80_LD_REGn_REGn .REGn1, .REGn2 {
	lda .REGn2
	sta .REGn1
	jmp ZVM_next
}

Z80_instr_41:      +Z80_LD_REGn_REGn REG_B, REG_C                              ; LD B,C
Z80_instr_42:      +Z80_LD_REGn_REGn REG_B, REG_D                              ; LD B,D
Z80_instr_43:      +Z80_LD_REGn_REGn REG_B, REG_E                              ; LD B,E
Z80_instr_44:      +Z80_LD_REGn_REGn REG_B, REG_H                              ; LD B,H
Z80_instr_45:      +Z80_LD_REGn_REGn REG_B, REG_L                              ; LD B,L
Z80_instr_47:      +Z80_LD_REGn_REGn REG_B, REG_A                              ; LD B,A

Z80_instr_48:      +Z80_LD_REGn_REGn REG_C, REG_B                              ; LD C,B
Z80_instr_4A:      +Z80_LD_REGn_REGn REG_C, REG_D                              ; LD C,D
Z80_instr_4B:      +Z80_LD_REGn_REGn REG_C, REG_E                              ; LD C,E
Z80_instr_4C:      +Z80_LD_REGn_REGn REG_C, REG_H                              ; LD C,H
Z80_instr_4D:      +Z80_LD_REGn_REGn REG_C, REG_L                              ; LD C,L
Z80_instr_4F:      +Z80_LD_REGn_REGn REG_C, REG_A                              ; LD C,A

Z80_instr_50:      +Z80_LD_REGn_REGn REG_D, REG_B                              ; LD D,B
Z80_instr_51:      +Z80_LD_REGn_REGn REG_D, REG_C                              ; LD D,C
Z80_instr_53:      +Z80_LD_REGn_REGn REG_D, REG_E                              ; LD D,E
Z80_instr_54:      +Z80_LD_REGn_REGn REG_D, REG_H                              ; LD D,H
Z80_instr_55:      +Z80_LD_REGn_REGn REG_D, REG_L                              ; LD D,L
Z80_instr_57:      +Z80_LD_REGn_REGn REG_D, REG_A                              ; LD D,A

Z80_instr_58:      +Z80_LD_REGn_REGn REG_E, REG_B                              ; LD E,B
Z80_instr_59:      +Z80_LD_REGn_REGn REG_E, REG_C                              ; LD E,C
Z80_instr_5A:      +Z80_LD_REGn_REGn REG_E, REG_D                              ; LD E,D
Z80_instr_5C:      +Z80_LD_REGn_REGn REG_E, REG_H                              ; LD E,H
Z80_instr_5D:      +Z80_LD_REGn_REGn REG_E, REG_L                              ; LD E,L
Z80_instr_5F:      +Z80_LD_REGn_REGn REG_E, REG_A                              ; LD E,A

Z80_instr_60:      +Z80_LD_REGn_REGn REG_H, REG_B                              ; LD H,B
Z80_instr_61:      +Z80_LD_REGn_REGn REG_H, REG_C                              ; LD H,C
Z80_instr_62:      +Z80_LD_REGn_REGn REG_H, REG_D                              ; LD H,D
Z80_instr_63:      +Z80_LD_REGn_REGn REG_H, REG_E                              ; LD H,E
Z80_instr_65:      +Z80_LD_REGn_REGn REG_H, REG_L                              ; LD H,L
Z80_instr_67:      +Z80_LD_REGn_REGn REG_H, REG_A                              ; LD H,A

Z80_instr_68:      +Z80_LD_REGn_REGn REG_L, REG_B                              ; LD L,B
Z80_instr_69:      +Z80_LD_REGn_REGn REG_L, REG_C                              ; LD L,C
Z80_instr_6A:      +Z80_LD_REGn_REGn REG_L, REG_D                              ; LD L,D
Z80_instr_6B:      +Z80_LD_REGn_REGn REG_L, REG_E                              ; LD L,E
Z80_instr_6C:      +Z80_LD_REGn_REGn REG_L, REG_H                              ; LD L,H
Z80_instr_6F:      +Z80_LD_REGn_REGn REG_L, REG_A                              ; LD L,A

Z80_instr_78:      +Z80_LD_REGn_REGn REG_A, REG_B                              ; LD A,B
Z80_instr_79:      +Z80_LD_REGn_REGn REG_A, REG_C                              ; LD A,C
Z80_instr_7A:      +Z80_LD_REGn_REGn REG_A, REG_D                              ; LD A,D
Z80_instr_7B:      +Z80_LD_REGn_REGn REG_A, REG_E                              ; LD A,E
Z80_instr_7C:      +Z80_LD_REGn_REGn REG_A, REG_H                              ; LD A,H
Z80_instr_7D:      +Z80_LD_REGn_REGn REG_A, REG_L                              ; LD A,L

;
; load register with immediate value
;

Z80_instr_06:      ; LD B,n

	jsr (VEC_fetch_value)
	sta REG_B
	jmp ZVM_next

Z80_instr_0E:      ; LD C,n

	jsr (VEC_fetch_value)
	sta REG_C
	jmp ZVM_next

Z80_instr_16:      ; LD D,n

	jsr (VEC_fetch_value)
	sta REG_D
	jmp ZVM_next

Z80_instr_1E:      ; LD E,n

	jsr (VEC_fetch_value)
	sta REG_E
	jmp ZVM_next

Z80_instr_26:      ; LD H,n

	jsr (VEC_fetch_value)
	sta REG_H
	jmp ZVM_next

Z80_instr_2E:      ; LD L,n

	jsr (VEC_fetch_value)
	sta REG_L
	jmp ZVM_next

Z80_instr_3E:      ; LD A,n

	jsr (VEC_fetch_value)
	sta REG_A
	jmp ZVM_next

;
; load register with memory content (via HL)
;

Z80_instr_46:      ; LD B,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_B
	jmp ZVM_next

Z80_instr_4E:      ; LD C,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_C
	jmp ZVM_next

Z80_instr_56:      ; LD D,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_D
	jmp ZVM_next

Z80_instr_5E:      ; LD E,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_E
	jmp ZVM_next

Z80_instr_66:      ; LD H,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_H
	jmp ZVM_next

Z80_instr_6E:      ; LD L,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_L
	jmp ZVM_next

Z80_instr_7E:      ; LD A,(HL)

	jsr (VEC_fetch_via_HL)
	sta REG_A
	jmp ZVM_next

; XXX put here LD r,(IX+d) family
; XXX put here LD r,(IY+d) family

;
; load memory content (via HL) with register
;

Z80_instr_70:      ; LD (HL),B

	lda REG_B
	jsr (VEC_store_via_HL)
	jmp ZVM_next

Z80_instr_71:      ; LD (HL),C

	lda REG_C
	jsr (VEC_store_via_HL)
	jmp ZVM_next

Z80_instr_72:      ; LD (HL),D

	lda REG_D
	jsr (VEC_store_via_HL)
	jmp ZVM_next

Z80_instr_73:      ; LD (HL),E

	lda REG_E
	jsr (VEC_store_via_HL)
	jmp ZVM_next

Z80_instr_74:      ; LD (HL),H

	lda REG_H
	jsr (VEC_store_via_HL)
	jmp ZVM_next

Z80_instr_75:      ; LD (HL),L

	lda REG_L
	jsr (VEC_store_via_HL)
	jmp ZVM_next

Z80_instr_77:      ; LD (HL),A

	lda REG_A
	jsr (VEC_store_via_HL)
	jmp ZVM_next

; XXX put here LD (IX+d),r family
; XXX put here LD (IY+d),r family

;
; load memory content (via HL) with immediate value
;

Z80_instr_36:      ; LD (HL),n

	jsr (VEC_fetch_value)
	jsr (VEC_store_via_HL)
	jmp ZVM_next

; XXX put here LD (IX+d),n family
; XXX put here LD (IY+d),n family
; XXX put here LD A,(BC) / LD A,(DE) / LD A,(nn) / LD (BC), A / LD (DE),A / LD (nn),A

Z80_instr_ED_57:   ; LD A,I

	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_PF - Z80_NF)
	ora REG_IFF2
	sta REG_F

	lda REG_I
	sta REG_A
	bpl @1
	+Z80_PUT_1_SF
@1:
	+bne ZVM_next
	+Z80_PUT_1_ZF
	jmp ZVM_next

Z80_instr_ED_5F:   ; LD A,R

	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_PF - Z80_NF)
	ora REG_IFF2
	sta REG_F

	lda REG_R06              ; register R only simulates random numbers
	eor VIC_RASTER
	adc TIME+2
	eor VIC_XPOS
	sta REG_R06

	and #%01111111
	eor REG_R7               ; not 'ora', we want to reuse the 'garbage'
	sta REG_A
	bpl @1
	+Z80_PUT_1_SF
@1:
	+bne ZVM_next
	+Z80_PUT_1_ZF
	jmp ZVM_next

Z80_instr_ED_47:   ; LD I,A

	lda REG_A
	sta REG_I
	jmp ZVM_next

Z80_instr_ED_4F:   ; LD R,A

	lda REG_A
	; Do not do 'sta REG_R06', it will generate a random number
	; Do not do 'and #%01111111', let it have some garbage
	sta REG_R7
	jmp ZVM_next
