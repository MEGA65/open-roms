
;
; Z80 rotate/shift instructions
;

; XXX for RRD/RLD generate tables in extended RAM


Z80_instr_ED_67:   ; RRD

	jsr (VEC_fetch_via_HL)
	sta REG_TMP1
	
	lda REG_A
	tax
	and #$F0
	sta REG_A
	txa
	
	ror
	ror  REG_TMP1
	ror
	ror  REG_TMP1
	ror
	ror  REG_TMP1
	ror
	ror  REG_TMP1
	ror
	
	clc
	ror
	asr
	asr
	asr
	
	ora REG_A
	sta REG_A
	
	tax
	lda REG_F
	and #Z80_CF
	ora z80_ftable_RRD_RLD,x
	sta REG_F
	
	lda REG_TMP1
	jmp ZVM_store_next

Z80_instr_ED_6F:   ; RLD

	jsr (VEC_fetch_via_HL)
	sta REG_TMP1
	
	lda REG_A
	tax
	and #$F0
	sta REG_A
	txa
	
	asl
	asl
	asl
	asl
	
	asl
	rol REG_TMP1
	rol
	rol REG_TMP1
	rol	
	rol REG_TMP1
	rol
	rol REG_TMP1
	rol

	ora REG_A
	sta REG_A
	
	tax
	lda REG_F
	and #Z80_CF
	ora z80_ftable_RRD_RLD,x
	sta REG_F
	
	lda REG_TMP1
	jmp ZVM_store_next

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

!macro Z80_RLC_VIA_HL {

	jsr (VEC_fetch_via_HL)

	tax
	rol
	txa
	
	rol
	sta [PTR_DATA],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_RLC_VIA_IXY_d {

	lda [PTR_IXY_d] ,z

	tax
	rol
	txa
	
	rol
	sta [PTR_IXY_d],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_RLC_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z

	tax
	rol
	txa
	
	rol
	sta [PTR_IXY_d],z
	sta .REGn
	
	tax
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
Z80_instr_CB_06:   +Z80_RLC_VIA_HL                                             ; RLC (HL)
Z80_instr_xDCB_06: +Z80_RLC_VIA_IXY_d                                          ; RLC (IXY+d)

Z80_illeg_xDCB_00: +Z80_RLC_VIA_IXY_d_REGn REG_B                               ; RLC (IXY+d),B
Z80_illeg_xDCB_01: +Z80_RLC_VIA_IXY_d_REGn REG_C                               ; RLC (IXY+d),C
Z80_illeg_xDCB_02: +Z80_RLC_VIA_IXY_d_REGn REG_D                               ; RLC (IXY+d),D
Z80_illeg_xDCB_03: +Z80_RLC_VIA_IXY_d_REGn REG_E                               ; RLC (IXY+d),E
Z80_illeg_xDCB_04: +Z80_RLC_VIA_IXY_d_REGn REG_H                               ; RLC (IXY+d),H
Z80_illeg_xDCB_05: +Z80_RLC_VIA_IXY_d_REGn REG_L                               ; RLC (IXY+d),L
Z80_illeg_xDCB_07: +Z80_RLC_VIA_IXY_d_REGn REG_A                               ; RLC (IXY+d),A

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

!macro Z80_RRC_VIA_HL {

	jsr (VEC_fetch_via_HL)

	tax
	ror
	txa

	ror
	sta [PTR_DATA],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_RRC_VIA_IXY_d {

	lda [PTR_IXY_d] ,z

	tax
	ror
	txa

	ror
	sta [PTR_IXY_d],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_RRC_VIA_IXY_d_REGn .REGn  {

	lda [PTR_IXY_d] ,z

	tax
	ror
	txa

	ror
	sta [PTR_IXY_d],z
	sta .REGn
	
	tax
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
Z80_instr_CB_0E:   +Z80_RRC_VIA_HL                                             ; RRC (HL)
Z80_instr_xDCB_0E: +Z80_RRC_VIA_IXY_d                                          ; RRC (IXY+d)

Z80_illeg_xDCB_08: +Z80_RRC_VIA_IXY_d_REGn REG_B                               ; RRC (IXY+d),B
Z80_illeg_xDCB_09: +Z80_RRC_VIA_IXY_d_REGn REG_C                               ; RRC (IXY+d),C
Z80_illeg_xDCB_0A: +Z80_RRC_VIA_IXY_d_REGn REG_D                               ; RRC (IXY+d),D
Z80_illeg_xDCB_0B: +Z80_RRC_VIA_IXY_d_REGn REG_E                               ; RRC (IXY+d),E
Z80_illeg_xDCB_0C: +Z80_RRC_VIA_IXY_d_REGn REG_H                               ; RRC (IXY+d),H
Z80_illeg_xDCB_0D: +Z80_RRC_VIA_IXY_d_REGn REG_L                               ; RRC (IXY+d),L
Z80_illeg_xDCB_0F: +Z80_RRC_VIA_IXY_d_REGn REG_A                               ; RRC (IXY+d),A

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

!macro Z80_RL_VIA_HL {

	jsr (VEC_fetch_via_HL)

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol
	sta [PTR_DATA],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_RL_VIA_IXY_d {

	lda [PTR_IXY_d] ,z

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol
	sta [PTR_IXY_d],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_RL_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z

	clc
	bbr0 REG_F, @1
	sec
@1:
	rol
	sta [PTR_IXY_d],z
	sta .REGn
	
	tax
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
Z80_instr_CB_16:   +Z80_RL_VIA_HL                                              ; RL (HL)
Z80_instr_xDCB_16: +Z80_RL_VIA_IXY_d                                           ; RL (IXY+d)

Z80_illeg_xDCB_10: +Z80_RL_VIA_IXY_d_REGn REG_B                                ; RL (IXY+d),B
Z80_illeg_xDCB_11: +Z80_RL_VIA_IXY_d_REGn REG_C                                ; RL (IXY+d),C
Z80_illeg_xDCB_12: +Z80_RL_VIA_IXY_d_REGn REG_D                                ; RL (IXY+d),D
Z80_illeg_xDCB_13: +Z80_RL_VIA_IXY_d_REGn REG_E                                ; RL (IXY+d),E
Z80_illeg_xDCB_14: +Z80_RL_VIA_IXY_d_REGn REG_H                                ; RL (IXY+d),H
Z80_illeg_xDCB_15: +Z80_RL_VIA_IXY_d_REGn REG_L                                ; RL (IXY+d),L
Z80_illeg_xDCB_17: +Z80_RL_VIA_IXY_d_REGn REG_A                                ; RL (IXY+d),A

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

!macro Z80_RR_VIA_HL {

	jsr (VEC_fetch_via_HL)

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror
	sta [PTR_DATA],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_RR_VIA_IXY_d {

	lda [PTR_IXY_d] ,z

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror
	sta [PTR_IXY_d],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_RR_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z

	clc
	bbr0 REG_F, @1
	sec
@1:
	ror
	sta [PTR_IXY_d],z
	sta .REGn
	
	tax
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
Z80_instr_CB_1E:   +Z80_RR_VIA_HL                                              ; RR (HL)
Z80_instr_xDCB_1E: +Z80_RR_VIA_IXY_d                                           ; RR (IXY+d)

Z80_illeg_xDCB_18: +Z80_RR_VIA_IXY_d_REGn REG_B                                ; RR (IXY+d),B
Z80_illeg_xDCB_19: +Z80_RR_VIA_IXY_d_REGn REG_C                                ; RR (IXY+d),C
Z80_illeg_xDCB_1A: +Z80_RR_VIA_IXY_d_REGn REG_D                                ; RR (IXY+d),D
Z80_illeg_xDCB_1B: +Z80_RR_VIA_IXY_d_REGn REG_E                                ; RR (IXY+d),E
Z80_illeg_xDCB_1C: +Z80_RR_VIA_IXY_d_REGn REG_H                                ; RR (IXY+d),H
Z80_illeg_xDCB_1D: +Z80_RR_VIA_IXY_d_REGn REG_L                                ; RR (IXY+d),L
Z80_illeg_xDCB_1F: +Z80_RR_VIA_IXY_d_REGn REG_A                                ; RR (IXY+d),A

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

!macro Z80_SLA_VIA_HL {

	jsr (VEC_fetch_via_HL)
	asl
	sta [PTR_DATA],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_SLA_VIA_IXY_d {

	lda [PTR_IXY_d] ,z
	asl
	sta [PTR_IXY_d],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_SLA_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z
	asl
	sta [PTR_IXY_d],z
	sta .REGn
	
	tax
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
Z80_instr_CB_26:   +Z80_SLA_VIA_HL                                             ; SLA (HL)
Z80_instr_xDCB_26: +Z80_SLA_VIA_IXY_d                                          ; SLA (IXY+d)

Z80_illeg_xDCB_20: +Z80_SLA_VIA_IXY_d_REGn REG_B                               ; SLA (IXY+d),B
Z80_illeg_xDCB_21: +Z80_SLA_VIA_IXY_d_REGn REG_C                               ; SLA (IXY+d),C
Z80_illeg_xDCB_22: +Z80_SLA_VIA_IXY_d_REGn REG_D                               ; SLA (IXY+d),D
Z80_illeg_xDCB_23: +Z80_SLA_VIA_IXY_d_REGn REG_E                               ; SLA (IXY+d),E
Z80_illeg_xDCB_24: +Z80_SLA_VIA_IXY_d_REGn REG_H                               ; SLA (IXY+d),H
Z80_illeg_xDCB_25: +Z80_SLA_VIA_IXY_d_REGn REG_L                               ; SLA (IXY+d),L
Z80_illeg_xDCB_27: +Z80_SLA_VIA_IXY_d_REGn REG_A                               ; SLA (IXY+d),A

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

!macro Z80_SLL_VIA_HL {

	jsr (VEC_fetch_via_HL)
	sec
	rol
	sta [PTR_DATA],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_SLL_VIA_IXY_d {

	lda [PTR_IXY_d] ,z
	sec
	rol
	sta [PTR_IXY_d],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_SLL_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z
	sec
	rol
	sta [PTR_IXY_d],z
	sta .REGn
	
	tax
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
Z80_illeg_CB_36:   +Z80_SLL_VIA_HL                                             ; SLL (HL)
Z80_illeg_xDCB_36: +Z80_SLL_VIA_IXY_d                                          ; SLL (IXY+d)

Z80_illeg_xDCB_30: +Z80_SLL_VIA_IXY_d_REGn REG_B                               ; SLL (IXY+d),B
Z80_illeg_xDCB_31: +Z80_SLL_VIA_IXY_d_REGn REG_C                               ; SLL (IXY+d),C
Z80_illeg_xDCB_32: +Z80_SLL_VIA_IXY_d_REGn REG_D                               ; SLL (IXY+d),D
Z80_illeg_xDCB_33: +Z80_SLL_VIA_IXY_d_REGn REG_E                               ; SLL (IXY+d),E
Z80_illeg_xDCB_34: +Z80_SLL_VIA_IXY_d_REGn REG_H                               ; SLL (IXY+d),H
Z80_illeg_xDCB_35: +Z80_SLL_VIA_IXY_d_REGn REG_L                               ; SLL (IXY+d),L
Z80_illeg_xDCB_37: +Z80_SLL_VIA_IXY_d_REGn REG_A                               ; SLL (IXY+d),A

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

!macro Z80_SRL_VIA_HL {

	jsr (VEC_fetch_via_HL)
	clc
	ror
	sta [PTR_DATA],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_SRL_VIA_IXY_d {

	lda [PTR_IXY_d] ,z
	clc
	ror
	sta [PTR_IXY_d],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_SRL_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z
	clc
	ror
	sta [PTR_IXY_d],z
	sta .REGn
	
	tax
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
Z80_instr_CB_3E:   +Z80_SRL_VIA_HL                                             ; SRL (HL)
Z80_instr_xDCB_3E: +Z80_SRL_VIA_IXY_d                                          ; SRL (IXY+d)

Z80_illeg_xDCB_38: +Z80_SRL_VIA_IXY_d_REGn REG_B                               ; SLR (IXY+d),B
Z80_illeg_xDCB_39: +Z80_SRL_VIA_IXY_d_REGn REG_C                               ; SLR (IXY+d),C
Z80_illeg_xDCB_3A: +Z80_SRL_VIA_IXY_d_REGn REG_D                               ; SLR (IXY+d),D
Z80_illeg_xDCB_3B: +Z80_SRL_VIA_IXY_d_REGn REG_E                               ; SLR (IXY+d),E
Z80_illeg_xDCB_3C: +Z80_SRL_VIA_IXY_d_REGn REG_H                               ; SLR (IXY+d),H
Z80_illeg_xDCB_3D: +Z80_SRL_VIA_IXY_d_REGn REG_L                               ; SLR (IXY+d),L
Z80_illeg_xDCB_3F: +Z80_SRL_VIA_IXY_d_REGn REG_A                               ; SLR (IXY+d),A

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

!macro Z80_SRA_VIA_HL {

	jsr (VEC_fetch_via_HL)
	
	tax
	ror
	txa
	
	ror
	sta [PTR_DATA],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_SRA_VIA_IXY_d {

	lda [PTR_IXY_d] ,z
	
	tax
	ror
	txa
	
	ror
	sta [PTR_IXY_d],z
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

!macro Z80_SRA_VIA_IXY_d_REGn .REGn {

	lda [PTR_IXY_d] ,z
	
	tax
	ror
	txa
	
	ror
	sta [PTR_IXY_d],z
	sta .REGn
	
	tax
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	+bcc ZVM_next
	+Z80_PUT_1_CF
	jmp ZVM_next
}

Z80_instr_CB_28:   +Z80_SRA_REGn REG_B                                         ; SRA B
Z80_instr_CB_29:   +Z80_SRA_REGn REG_C                                         ; SRA C
Z80_instr_CB_2A:   +Z80_SRA_REGn REG_D                                         ; SRA D
Z80_instr_CB_2B:   +Z80_SRA_REGn REG_E                                         ; SRA E
Z80_instr_CB_2C:   +Z80_SRA_REGn REG_H                                         ; SRA H
Z80_instr_CB_2D:   +Z80_SRA_REGn REG_L                                         ; SRA L
Z80_instr_CB_2F:   +Z80_SRA_REGn REG_A                                         ; SRA A
Z80_instr_CB_2E:   +Z80_SRA_VIA_HL                                             ; SRA (HL)
Z80_instr_xDCB_2E: +Z80_SRA_VIA_IXY_d                                          ; SRA (IXY+d)

Z80_illeg_xDCB_28: +Z80_SRA_VIA_IXY_d_REGn REG_B                               ; SRA (IXY+d),B
Z80_illeg_xDCB_29: +Z80_SRA_VIA_IXY_d_REGn REG_C                               ; SRA (IXY+d),C
Z80_illeg_xDCB_2A: +Z80_SRA_VIA_IXY_d_REGn REG_D                               ; SRA (IXY+d),D
Z80_illeg_xDCB_2B: +Z80_SRA_VIA_IXY_d_REGn REG_E                               ; SRA (IXY+d),E
Z80_illeg_xDCB_2C: +Z80_SRA_VIA_IXY_d_REGn REG_H                               ; SRA (IXY+d),H
Z80_illeg_xDCB_2D: +Z80_SRA_VIA_IXY_d_REGn REG_L                               ; SRA (IXY+d),L
Z80_illeg_xDCB_2F: +Z80_SRA_VIA_IXY_d_REGn REG_A                               ; SRA (IXY+d),A
