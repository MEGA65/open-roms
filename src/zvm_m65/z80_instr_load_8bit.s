
;
; Z80 data load instructions, 8 bit
;


;
; load register with other register
;

Z80_instr_41:      ; LD B,C

	lda REG_C
	sta REG_B
	jmp ZVM_next

Z80_instr_42:      ; LD B,D

	lda REG_D
	sta REG_B
	jmp ZVM_next

Z80_instr_43:      ; LD B,E

	lda REG_E
	sta REG_B
	jmp ZVM_next

Z80_instr_44:      ; LD B,H

	lda REG_H
	sta REG_B
	jmp ZVM_next

Z80_instr_45:      ; LD B,L

	lda REG_L
	sta REG_B
	jmp ZVM_next

Z80_instr_47:      ; LD B,A

	lda REG_A
	sta REG_B
	jmp ZVM_next

Z80_instr_48:      ; LD C,B

	lda REG_B
	sta REG_C
	jmp ZVM_next

Z80_instr_4A:      ; LD C,D

	lda REG_D
	sta REG_C
	jmp ZVM_next

Z80_instr_4B:      ; LD C,E

	lda REG_E
	sta REG_C
	jmp ZVM_next

Z80_instr_4C:      ; LD C,H

	lda REG_H
	sta REG_C
	jmp ZVM_next

Z80_instr_4D:      ; LD C,L

	lda REG_L
	sta REG_C
	jmp ZVM_next

Z80_instr_4F:      ; LD C,A

	lda REG_A
	sta REG_C
	jmp ZVM_next

Z80_instr_50:      ; LD D,B

	lda REG_B
	sta REG_D
	jmp ZVM_next

Z80_instr_51:      ; LD D,C

	lda REG_C
	sta REG_D
	jmp ZVM_next

Z80_instr_53:      ; LD D,E

	lda REG_E
	sta REG_D
	jmp ZVM_next

Z80_instr_54:      ; LD D,H

	lda REG_H
	sta REG_D
	jmp ZVM_next

Z80_instr_55:      ; LD D,L

	lda REG_L
	sta REG_D
	jmp ZVM_next

Z80_instr_57:      ; LD D,A

	lda REG_A
	sta REG_D
	jmp ZVM_next

Z80_instr_58:      ; LD E,B

	lda REG_B
	sta REG_E
	jmp ZVM_next

Z80_instr_59:      ; LD E,C

	lda REG_C
	sta REG_E
	jmp ZVM_next

Z80_instr_5A:      ; LD E,D

	lda REG_D
	sta REG_E
	jmp ZVM_next

Z80_instr_5C:      ; LD E,H

	lda REG_H
	sta REG_E
	jmp ZVM_next

Z80_instr_5D:      ; LD E,L

	lda REG_L
	sta REG_E
	jmp ZVM_next

Z80_instr_5F:      ; LD E,A

	lda REG_A
	sta REG_E
	jmp ZVM_next

Z80_instr_60:      ; LD H,B

	lda REG_B
	sta REG_H
	jmp ZVM_next

Z80_instr_61:      ; LD H,C

	lda REG_C
	sta REG_H
	jmp ZVM_next

Z80_instr_62:      ; LD H,D

	lda REG_D
	sta REG_H
	jmp ZVM_next

Z80_instr_63:      ; LD H,E

	lda REG_E
	sta REG_H
	jmp ZVM_next

Z80_instr_65:      ; LD H,L

	lda REG_L
	sta REG_H
	jmp ZVM_next

Z80_instr_67:      ; LD H,A

	lda REG_A
	sta REG_H
	rts

Z80_instr_68:      ; LD L,B

	lda REG_B
	sta REG_L
	jmp ZVM_next

Z80_instr_69:      ; LD L,C

	lda REG_C
	sta REG_L
	jmp ZVM_next

Z80_instr_6A:      ; LD L,D

	lda REG_D
	sta REG_L
	jmp ZVM_next

Z80_instr_6B:      ; LD L,E

	lda REG_E
	sta REG_L
	jmp ZVM_next

Z80_instr_6C:      ; LD L,H

	lda REG_H
	sta REG_L
	jmp ZVM_next

Z80_instr_6F:      ; LD L,A

	lda REG_A
	sta REG_L
	jmp ZVM_next

Z80_instr_78:      ; LD A,B

	lda REG_B
	sta REG_A
	jmp ZVM_next

Z80_instr_79:      ; LD A,C

	lda REG_C
	sta REG_A
	jmp ZVM_next

Z80_instr_7A:      ; LD A,D

	lda REG_D
	sta REG_A
	jmp ZVM_next

Z80_instr_7B:      ; LD A,E

	lda REG_E
	sta REG_A
	jmp ZVM_next

Z80_instr_7C:      ; LD A,H

	lda REG_H
	sta REG_A
	jmp ZVM_next

Z80_instr_7D:      ; LD A,L

	lda REG_L
	sta REG_A
	jmp ZVM_next

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

; XXX put here LD (IX+d),r family
; XXX put here LD (IY+d),r family

;
; load memory content (via HL) with immediate value
;

Z80_instr_36:      ; LD (HL),n

	jsr (VEC_fetch_value)
	jmp (VEC_store_via_HL)

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

	lda REG_R06
	and #%01111111
	ora REG_R7
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
	sta REG_R06
	and #%01111111
	sta REG_R7
	jmp ZVM_next
