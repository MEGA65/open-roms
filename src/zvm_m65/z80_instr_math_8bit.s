
;
; Z80 arithmetic instructions, 8 bit
;

; XXX possible optimizations in this fie: special version for ADD/SUB/CP with self, falltrough optimizations in SUB, ADD, CP



!macro Z80_ADD_n {
	jsr (VEC_fetch_via_PC_inc)
	bra Z80_common_add
}

!macro Z80_ADC_n {
	jsr (VEC_fetch_via_PC_inc)
	bbs0 REG_F,Z80_common_adc
	jmp Z80_common_add
}

!macro Z80_ADD_REGn .REGn {
	lda .REGn
	bra Z80_common_add
}

!macro Z80_ADC_REGn .REGn {
	lda .REGn
	bbs0 REG_F,Z80_common_adc
	jmp Z80_common_add
}

!macro Z80_ADD_VIA_HL {
	jsr (VEC_fetch_via_HL)
	bra Z80_common_add
}

!macro Z80_ADC_VIA_HL {
	jsr (VEC_fetch_via_HL)
	bbs0 REG_F,Z80_common_adc
	jmp Z80_common_add
}

!macro Z80_ADD_VIA_IX_d {
	jsr (VEC_fetch_via_IX_d)
	bra Z80_common_add
}

!macro Z80_ADC_VIA_IX_d {
	jsr (VEC_fetch_via_IX_d)
	bbs0 REG_F,Z80_common_adc
	jmp Z80_common_add
}

!macro Z80_ADD_VIA_IY_d {
	jsr (VEC_fetch_via_IY_d)
	bra Z80_common_add
}

!macro Z80_ADC_VIA_IY_d {
	jsr (VEC_fetch_via_IY_d)
	bbs0 REG_F,Z80_common_adc
	jmp Z80_common_add
}

Z80_instr_C6:      +Z80_ADD_n                                                  ; ADD A,n
Z80_instr_80:      +Z80_ADD_REGn REG_B                                         ; ADD A,B
Z80_instr_81:      +Z80_ADD_REGn REG_C                                         ; ADD A,C
Z80_instr_82:      +Z80_ADD_REGn REG_D                                         ; ADD A,D
Z80_instr_83:      +Z80_ADD_REGn REG_E                                         ; ADD A,E
Z80_instr_84:      +Z80_ADD_REGn REG_H                                         ; ADD A,H
Z80_instr_85:      +Z80_ADD_REGn REG_L                                         ; ADD A,L
Z80_instr_87:      +Z80_ADD_REGn REG_A                                         ; ADD A,A
Z80_illeg_DD_84:   +Z80_ADD_REGn REG_IXH                                       ; ADD A,IXH
Z80_illeg_DD_85:   +Z80_ADD_REGn REG_IXL                                       ; ADD A,IXL
Z80_illeg_FD_84:   +Z80_ADD_REGn REG_IYH                                       ; ADD A,IYH
Z80_illeg_FD_85:   +Z80_ADD_REGn REG_IYL                                       ; ADD A,IYL
Z80_instr_86:      +Z80_ADD_VIA_HL                                             ; ADD A,(HL)
Z80_instr_DD_86:   +Z80_ADD_VIA_IX_d                                           ; ADD A,(IX+d)
Z80_instr_FD_86:   +Z80_ADD_VIA_IY_d                                           ; ADD A,(IY+d)

Z80_common_add:

	sta REG_TMP1
	and #$0F                 ; calculate half-carry flag
	sta REG_TMP2
	lda REG_A
	and #$0F
	clc
	adc REG_TMP2
	and #$F0
	beq @1
    lda #Z80_HF
@1:	
	sta REG_F                ; now REG_F has HF set properly, everything else cleared
	lda REG_TMP1
	clc
	adc REG_A
	sta REG_A
	tax
	lda REG_F
	ora z80_ftable_ADD_ADC, x
	sta REG_F
	bvs @V1:
@V0:
	bcs @VxC1
@V0C0:
	jmp ZVM_next
@VxC1:
	+Z80_PUT_1_CF
	jmp ZVM_next
@V1:
	+Z80_PUT_1_VF
	bcs @VxC1
@V1C0:
	jmp ZVM_next

Z80_instr_CE:      +Z80_ADC_n                                                  ; ADC A,n
Z80_instr_88:      +Z80_ADC_REGn REG_B                                         ; ADC A,B
Z80_instr_89:      +Z80_ADC_REGn REG_C                                         ; ADC A,C
Z80_instr_8A:      +Z80_ADC_REGn REG_D                                         ; ADC A,D
Z80_instr_8B:      +Z80_ADC_REGn REG_E                                         ; ADC A,E
Z80_instr_8C:      +Z80_ADC_REGn REG_H                                         ; ADC A,H
Z80_instr_8D:      +Z80_ADC_REGn REG_L                                         ; ADC A,L
Z80_instr_8F:      +Z80_ADC_REGn REG_A                                         ; ADC A,A
Z80_illeg_DD_8C:   +Z80_ADC_REGn REG_IXH                                       ; ADC A,IXH
Z80_illeg_DD_8D:   +Z80_ADC_REGn REG_IXL                                       ; ADC A,IXL
Z80_illeg_FD_8C:   +Z80_ADC_REGn REG_IYH                                       ; ADC A,IYH
Z80_illeg_FD_8D:   +Z80_ADC_REGn REG_IYL                                       ; ADC A,IYL
Z80_instr_8E:      +Z80_ADC_VIA_HL                                             ; ADC A,(HL)
Z80_instr_DD_8E:   +Z80_ADC_VIA_IX_d                                           ; ADC A,(IX+d)
Z80_instr_FD_8E:   +Z80_ADC_VIA_IY_d                                           ; ADC A,(IY+d)

Z80_common_adc:

	sta REG_TMP1
	and #$0F                 ; calculate half-carry flag
	sta REG_TMP2
	lda REG_A
	and #$0F
	sec
	adc REG_TMP2
	and #$F0
	beq @1
    lda #Z80_HF
@1:	
	sta REG_F                ; now REG_F has HF set properly, everything else cleared
	lda REG_TMP1
	sec
	adc REG_A
	sta REG_A
	tax
	lda REG_F
	ora z80_ftable_ADD_ADC, x
	sta REG_F
	bvs @V1:
@V0:
	bcs @VxC1
@V0C0:
	jmp ZVM_next
@VxC1:
	+Z80_PUT_1_CF
	jmp ZVM_next
@V1:
	+Z80_PUT_1_VF
	bcs @VxC1
@V1C0:
	jmp ZVM_next

!macro Z80_SUB_n {
	jsr (VEC_fetch_via_PC_inc)
	bra Z80_common_sub
}

!macro Z80_SBC_n {
	jsr (VEC_fetch_via_PC_inc)
	bbs0 REG_F,Z80_common_sbc
	jmp Z80_common_sub
}

!macro Z80_SUB_REGn .REGn {
	lda .REGn
	bra Z80_common_sub
}

!macro Z80_SBC_REGn .REGn {
	lda .REGn
	bbs0 REG_F,Z80_common_sbc
	jmp Z80_common_sub
}

!macro Z80_SUB_VIA_HL {
	jsr (VEC_fetch_via_HL)
	bra Z80_common_sub
}

!macro Z80_SBC_VIA_HL {
	jsr (VEC_fetch_via_HL)
	bbs0 REG_F,Z80_common_sbc
	jmp Z80_common_sub
}

!macro Z80_SUB_VIA_IX_d {
	jsr (VEC_fetch_via_IX_d)
	bra Z80_common_sub
}

!macro Z80_SBC_VIA_IX_d {
	jsr (VEC_fetch_via_IX_d)
	bbs0 REG_F,Z80_common_sbc
	jmp Z80_common_sub
}

!macro Z80_SUB_VIA_IY_d {
	jsr (VEC_fetch_via_IY_d)
	bra Z80_common_sub
}

!macro Z80_SBC_VIA_IY_d {
	jsr (VEC_fetch_via_IY_d)
	bbs0 REG_F,Z80_common_sbc
	jmp Z80_common_sub
}

Z80_instr_D6:      +Z80_SUB_n                                                  ; SUB A,n
Z80_instr_90:      +Z80_SUB_REGn REG_B                                         ; SUB A,B
Z80_instr_91:      +Z80_SUB_REGn REG_C                                         ; SUB A,C
Z80_instr_92:      +Z80_SUB_REGn REG_D                                         ; SUB A,D
Z80_instr_93:      +Z80_SUB_REGn REG_E                                         ; SUB A,E
Z80_instr_94:      +Z80_SUB_REGn REG_H                                         ; SUB A,H
Z80_instr_95:      +Z80_SUB_REGn REG_L                                         ; SUB A,L
Z80_instr_97:      +Z80_SUB_REGn REG_A                                         ; SUB A,A
Z80_illeg_DD_94:   +Z80_SUB_REGn REG_IXH                                       ; SUB A,IXH
Z80_illeg_DD_95:   +Z80_SUB_REGn REG_IXL                                       ; SUB A,IXL
Z80_illeg_FD_94:   +Z80_SUB_REGn REG_IYH                                       ; SUB A,IYH
Z80_illeg_FD_95:   +Z80_SUB_REGn REG_IYL                                       ; SUB A,IYL
Z80_instr_96:      +Z80_SUB_VIA_HL                                             ; SUB A,(HL)
Z80_instr_DD_96:   +Z80_SUB_VIA_IX_d                                           ; SUB A,(IX+d)
Z80_instr_FD_96:   +Z80_SUB_VIA_IY_d                                           ; SUB A,(IY+d)

Z80_common_sub:

	sta REG_TMP1
	and #$0F                 ; calculate half-carry flag
	sta REG_TMP2
	lda REG_A
	and #$0F
	sec
	sbc REG_TMP2
	and #$F0
	beq @1
    lda #Z80_HF
@1:	
	sta REG_F                ; now REG_F has HF set properly, everything else cleared
	lda REG_TMP1
	sec
	sbc REG_A
	sta REG_A
	tax
	lda REG_F
	ora z80_ftable_SUB_SBC, x
	sta REG_F
	bvs @V1:
@V0:
	bcc @VxC1
@V0C0:
	jmp ZVM_next
@VxC1:
	+Z80_PUT_1_CF
	jmp ZVM_next
@V1:
	+Z80_PUT_1_VF
	bcc @VxC1
@V1C0:
	jmp ZVM_next

Z80_instr_DE:      +Z80_SBC_n                                                  ; SBC A,n
Z80_instr_98:      +Z80_SBC_REGn REG_B                                         ; SBC A,B
Z80_instr_99:      +Z80_SBC_REGn REG_C                                         ; SBC A,C
Z80_instr_9A:      +Z80_SBC_REGn REG_D                                         ; SBC A,D
Z80_instr_9B:      +Z80_SBC_REGn REG_E                                         ; SBC A,E
Z80_instr_9C:      +Z80_SBC_REGn REG_H                                         ; SBC A,H
Z80_instr_9D:      +Z80_SBC_REGn REG_L                                         ; SBC A,L
Z80_instr_9F:      +Z80_SBC_REGn REG_A                                         ; SBC A,A
Z80_illeg_DD_9C:   +Z80_SBC_REGn REG_IXH                                       ; SBC A,IXH
Z80_illeg_DD_9D:   +Z80_SBC_REGn REG_IXL                                       ; SBC A,IXL
Z80_illeg_FD_9C:   +Z80_SBC_REGn REG_IYH                                       ; SBC A,IYH
Z80_illeg_FD_9D:   +Z80_SBC_REGn REG_IYL                                       ; SBC A,IYL
Z80_instr_9E:      +Z80_SBC_VIA_HL                                             ; SBC A,(HL)
Z80_instr_DD_9E:   +Z80_SBC_VIA_IX_d                                           ; SBC A,(IX+d)
Z80_instr_FD_9E:   +Z80_SBC_VIA_IY_d                                           ; SBC A,(IY+d)

Z80_common_sbc:

	sta REG_TMP1
	and #$0F                 ; calculate half-carry flag
	sta REG_TMP2
	lda REG_A
	and #$0F
	clc
	sbc REG_TMP2
	and #$F0
	beq @1
    lda #Z80_HF
@1:	
	sta REG_F                ; now REG_F has HF set properly, everything else cleared
	lda REG_TMP1
	clc
	sbc REG_A
	sta REG_A
	tax
	lda REG_F
	ora z80_ftable_SUB_SBC, x
	sta REG_F
	bvs @V1:
@V0:
	bcc @VxC1
@V0C0:
	jmp ZVM_next
@VxC1:
	+Z80_PUT_1_CF
	jmp ZVM_next
@V1:
	+Z80_PUT_1_VF
	bcc @VxC1
@V1C0:
	jmp ZVM_next

!macro Z80_CP_n {
	jsr (VEC_fetch_via_PC_inc)
	bra Z80_common_cp
}

!macro Z80_CP_REGn .REGn {
	lda .REGn
	bra Z80_common_cp
}

!macro Z80_CP_VIA_HL {
	jsr (VEC_fetch_via_HL)
	bra Z80_common_cp
}

!macro Z80_CP_VIA_IX_d {
	jsr (VEC_fetch_via_IX_d)
	bra Z80_common_cp
}

!macro Z80_CP_VIA_IY_d {
	jsr (VEC_fetch_via_IY_d)
	bra Z80_common_cp
}

Z80_instr_FE:      +Z80_CP_n                                                   ; CP n
Z80_instr_B8:      +Z80_CP_REGn REG_B                                          ; CP B
Z80_instr_B9:      +Z80_CP_REGn REG_C                                          ; CP C
Z80_instr_BA:      +Z80_CP_REGn REG_D                                          ; CP D
Z80_instr_BB:      +Z80_CP_REGn REG_E                                          ; CP E
Z80_instr_BC:      +Z80_CP_REGn REG_H                                          ; CP H
Z80_instr_BD:      +Z80_CP_REGn REG_L                                          ; CP L
Z80_instr_BF:      +Z80_CP_REGn REG_A                                          ; CP A
Z80_illeg_DD_BC:   +Z80_CP_REGn REG_IXH                                        ; CP IXH
Z80_illeg_DD_BD:   +Z80_CP_REGn REG_IXL                                        ; CP IXL
Z80_illeg_FD_BC:   +Z80_CP_REGn REG_IYH                                        ; CP IYH
Z80_illeg_FD_BD:   +Z80_CP_REGn REG_IYL                                        ; CP IYL
Z80_instr_BE:      +Z80_CP_VIA_HL                                              ; CP (HL)
Z80_instr_DD_BE:   +Z80_CP_VIA_IX_d                                            ; CP (IX+d)
Z80_instr_FD_BE:   +Z80_CP_VIA_IY_d                                            ; CP (IY+d)

Z80_common_cp:

	sta REG_TMP1
	and #$0F                 ; calculate half-carry flag
	sta REG_TMP2
	lda REG_A
	and #$0F
	sec
	sbc REG_TMP2
	and #$F0
	beq @1
    lda #Z80_HF
@1:	
	sta REG_F                ; now REG_F has HF set properly, everything else cleared
	lda REG_TMP1
	sec
	sbc REG_A
	tax
	and #%00101000
	ora z80_ftable_CP, x
	sta REG_F
	bvs @V1:
@V0:
	bcc @VxC1
@V0C0:
	jmp ZVM_next
@VxC1:
	+Z80_PUT_1_CF
	jmp ZVM_next
@V1:
	+Z80_PUT_1_VF
	bcc @VxC1
@V1C0:
	jmp ZVM_next

!macro Z80_AND_common_int {
	lda z80_ftable_AND, x
	sta REG_F
	jmp ZVM_next
}

!macro Z80_AND_common {
	and REG_A
	sta REG_A
	tax

	+Z80_AND_common_int
}

!macro Z80_AND_REGn .REGn {
	lda .REGn
	+Z80_AND_common
}

!macro Z80_AND_SELF {
	ldx REG_A
	+Z80_AND_common_int
}

!macro Z80_AND_VIA_HL {
	jsr (VEC_fetch_via_HL)
	+Z80_AND_common
}

!macro Z80_AND_n {
	jsr (VEC_fetch_via_PC_inc)
	+Z80_AND_common
}

!macro Z80_AND_VIA_IX_d {
	jsr (VEC_fetch_via_IX_d)
	+Z80_AND_common
}

!macro Z80_AND_VIA_IY_d {
	jsr (VEC_fetch_via_IY_d)
	+Z80_AND_common
}

Z80_instr_A0:      +Z80_AND_REGn REG_B                                         ; AND B
Z80_instr_A1:      +Z80_AND_REGn REG_C                                         ; AND C
Z80_instr_A2:      +Z80_AND_REGn REG_D                                         ; AND D
Z80_instr_A3:      +Z80_AND_REGn REG_E                                         ; AND E
Z80_instr_A4:      +Z80_AND_REGn REG_H                                         ; AND H
Z80_instr_A5:      +Z80_AND_REGn REG_L                                         ; AND L
Z80_illeg_DD_A4:   +Z80_AND_REGn REG_IXH                                       ; AND IXH
Z80_illeg_DD_A5:   +Z80_AND_REGn REG_IXL                                       ; AND IXL
Z80_illeg_FD_A4:   +Z80_AND_REGn REG_IYH                                       ; AND IYH
Z80_illeg_FD_A5:   +Z80_AND_REGn REG_IXL                                       ; AND IYL
Z80_instr_A6:      +Z80_AND_VIA_HL                                             ; AND (HL)
Z80_instr_A7:      +Z80_AND_SELF                                               ; AND A
Z80_instr_E6:      +Z80_AND_n                                                  ; AND n
Z80_instr_DD_A6:   +Z80_AND_VIA_IX_d                                           ; AND (IX+d)
Z80_instr_FD_A6:   +Z80_AND_VIA_IY_d                                           ; AND (IY+d)

!macro Z80_OR_XOR_common_int {
	lda z80_ftable_IN_OR_XOR, x
	sta REG_F
	jmp ZVM_next
}

!macro Z80_OR_common {
	ora REG_A
	sta REG_A
	tax

	+Z80_OR_XOR_common_int
}

!macro Z80_OR_REGn .REGn {
	lda .REGn
	+Z80_OR_common
}

!macro Z80_OR_SELF {
	ldx REG_A
	+Z80_OR_XOR_common_int
}

!macro Z80_OR_VIA_HL {
	jsr (VEC_fetch_via_HL)
	+Z80_OR_common
}

!macro Z80_OR_n {
	jsr (VEC_fetch_via_PC_inc)
	+Z80_OR_common
}

!macro Z80_OR_VIA_IX_d {
	jsr (VEC_fetch_via_IX_d)
	+Z80_OR_common
}

!macro Z80_OR_VIA_IY_d {
	jsr (VEC_fetch_via_IY_d)
	+Z80_OR_common
}

Z80_instr_B0:      +Z80_OR_REGn REG_B                                          ; OR B
Z80_instr_B1:      +Z80_OR_REGn REG_C                                          ; OR C
Z80_instr_B2:      +Z80_OR_REGn REG_D                                          ; OR D
Z80_instr_B3:      +Z80_OR_REGn REG_E                                          ; OR E
Z80_instr_B4:      +Z80_OR_REGn REG_H                                          ; OR H
Z80_instr_B5:      +Z80_OR_REGn REG_L                                          ; OR L
Z80_illeg_DD_B4:   +Z80_OR_REGn REG_IXH                                        ; OR IXH
Z80_illeg_DD_B5:   +Z80_OR_REGn REG_IXL                                        ; OR IXL
Z80_illeg_FD_B4:   +Z80_OR_REGn REG_IYH                                        ; OR IYH
Z80_illeg_FD_B5:   +Z80_OR_REGn REG_IYL                                        ; OR IYL
Z80_instr_B6:      +Z80_OR_VIA_HL                                              ; OR (HL)
Z80_instr_B7:      +Z80_OR_SELF                                                ; OR A
Z80_instr_F6:      +Z80_OR_n                                                   ; OR n
Z80_instr_DD_B6:   +Z80_OR_VIA_IX_d                                            ; OR (IX+d)
Z80_instr_FD_B6:   +Z80_OR_VIA_IY_d                                            ; OR (IY+d)

!macro Z80_XOR_common {
	eor REG_A
	sta REG_A
	tax

	+Z80_OR_XOR_common_int
}

!macro Z80_XOR_REGn .REGn {
	lda .REGn
	+Z80_XOR_common
}

!macro Z80_XOR_SELF {
	lda #$00
	sta REG_A
	lda z80_ftable_IN_OR_XOR
	sta REG_F
	jmp ZVM_next
}

!macro Z80_XOR_VIA_HL {
	jsr (VEC_fetch_via_HL)
	+Z80_XOR_common
}

!macro Z80_XOR_n {
	jsr (VEC_fetch_via_PC_inc)
	+Z80_XOR_common
}

!macro Z80_XOR_VIA_IX_d {
	jsr (VEC_fetch_via_IX_d)
	+Z80_XOR_common
}

!macro Z80_XOR_VIA_IY_d {
	jsr (VEC_fetch_via_IY_d)
	+Z80_XOR_common
}

Z80_instr_A8:      +Z80_XOR_REGn REG_B                                         ; XOR B
Z80_instr_A9:      +Z80_XOR_REGn REG_C                                         ; XOR C
Z80_instr_AA:      +Z80_XOR_REGn REG_D                                         ; XOR D
Z80_instr_AB:      +Z80_XOR_REGn REG_E                                         ; XOR E
Z80_instr_AC:      +Z80_XOR_REGn REG_H                                         ; XOR H
Z80_instr_AD:      +Z80_XOR_REGn REG_L                                         ; XOR L
Z80_illeg_DD_AC:   +Z80_XOR_REGn REG_IXH                                       ; XOR IXH
Z80_illeg_DD_AD:   +Z80_XOR_REGn REG_IXL                                       ; XOR IXL
Z80_illeg_FD_AC:   +Z80_XOR_REGn REG_IYH                                       ; XOR IYH
Z80_illeg_FD_AD:   +Z80_XOR_REGn REG_IXL                                       ; XOR IYL
Z80_instr_AE:      +Z80_XOR_VIA_HL                                             ; XOR (HL)
Z80_instr_AF:      +Z80_XOR_SELF                                               ; XOR A
Z80_instr_EE:      +Z80_XOR_n                                                  ; XOR n
Z80_instr_DD_AE:   +Z80_XOR_VIA_IX_d                                           ; XOR (IX+d)
Z80_instr_FD_AE:   +Z80_XOR_VIA_IY_d                                           ; XOR (IY+d)

!macro Z80_INC_REG_n .REG_n {
	ldx .REG_n
	inc .REG_n
	bra Z80_common_INC
}

Z80_instr_04:      +Z80_INC_REG_n REG_B                                        ; INC B
Z80_instr_0C:      +Z80_INC_REG_n REG_C                                        ; INC C
Z80_instr_14:      +Z80_INC_REG_n REG_D                                        ; INC D
Z80_instr_1C:      +Z80_INC_REG_n REG_E                                        ; INC E
Z80_instr_24:      +Z80_INC_REG_n REG_H                                        ; INC H
Z80_instr_2C:      +Z80_INC_REG_n REG_L                                        ; INC L
Z80_illeg_DD_24:   +Z80_INC_REG_n REG_IXH                                      ; INC IXH
Z80_illeg_DD_2C:   +Z80_INC_REG_n REG_IXL                                      ; INC IXL
Z80_illeg_FD_24:   +Z80_INC_REG_n REG_IYH                                      ; INC IYH
Z80_illeg_FD_2C:   +Z80_INC_REG_n REG_IYL                                      ; INC IYL

Z80_instr_3C:                                                                  ; INC A

	ldx REG_A
	inc REG_A

	; FALLTROUGH

Z80_common_INC:

	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_VF - Z80_NF)
	ora z80_ftable_INC, x
	sta REG_F
	jmp ZVM_next

Z80_instr_34:      ; INC (HL)

	jsr (VEC_fetch_via_HL_back)
	tax
	inc
	sta [PTR_DATA],z
	bra Z80_common_INC

Z80_instr_DD_34:   ; INC (IX+d)

	jsr (VEC_fetch_via_IX_d)
	tax
	inc
	sta [PTR_DATA],z
	bra Z80_common_INC

Z80_instr_FD_34:   ; INC (IY+d)

	jsr (VEC_fetch_via_IY_d)
	tax
	inc
	sta [PTR_DATA],z
	bra Z80_common_INC

!macro Z80_DEC_REG_n .REG_n {
	ldx .REG_n
	dec .REG_n
	bra Z80_common_DEC
}

Z80_instr_05:      +Z80_DEC_REG_n REG_B                                        ; DEC B
Z80_instr_0D:      +Z80_DEC_REG_n REG_C                                        ; DEC C
Z80_instr_15:      +Z80_DEC_REG_n REG_D                                        ; DEC D
Z80_instr_1D:      +Z80_DEC_REG_n REG_E                                        ; DEC E
Z80_instr_25:      +Z80_DEC_REG_n REG_H                                        ; DEC H
Z80_instr_2D:      +Z80_DEC_REG_n REG_L                                        ; DEC L
Z80_illeg_DD_25:   +Z80_DEC_REG_n REG_IXH                                      ; DEC IXH
Z80_illeg_DD_2D:   +Z80_DEC_REG_n REG_IXL                                      ; DEC IXL
Z80_illeg_FD_25:   +Z80_DEC_REG_n REG_IYH                                      ; DEC IYH
Z80_illeg_FD_2D:   +Z80_DEC_REG_n REG_IYL                                      ; DEC IYL

Z80_instr_3D:                                                                  ; DEC A

	ldx REG_A
	dec REG_A

	; FALLTROUGH

Z80_common_DEC:

	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_VF - Z80_NF)
	ora z80_ftable_DEC, x
	sta REG_F
	jmp ZVM_next

Z80_instr_35:      ; DEC (HL)

	jsr (VEC_fetch_via_HL_back)
	tax
	dec
	sta [PTR_DATA],z
	bra Z80_common_DEC

Z80_instr_DD_35:   ; DEC (IX+d)

	jsr (VEC_fetch_via_IX_d)
	tax
	dec
	sta [PTR_DATA],z
	bra Z80_common_DEC

Z80_instr_FD_35:   ; DEC (IY+d)

	jsr (VEC_fetch_via_IY_d)
	tax
	dec
	sta [PTR_DATA],z
	bra Z80_common_DEC


