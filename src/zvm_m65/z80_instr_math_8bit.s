
;
; Z80 arithmetic instructions, 8 bit
;

; XXX put ADD instructions here
; XXX put SUB instructions here
; XXX put SBC instructions here


!macro Z80_AND_common_int {
	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_PF - Z80_NF - Z80_CF)
	ora z80_ftable_AND, x
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
	jsr (VEC_fetch_value)
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
Z80_instr_A6:      +Z80_AND_VIA_HL                                             ; AND (HL)
Z80_instr_A7:      +Z80_AND_SELF                                               ; AND A
Z80_instr_E6:      +Z80_AND_n                                                  ; AND n
Z80_instr_DD_A6:   +Z80_AND_VIA_IX_d                                           ; AND (IX+d)
Z80_instr_FD_A6:   +Z80_AND_VIA_IY_d                                           ; AND (IY+d)

!macro Z80_OR_XOR_common_int {
	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_PF - Z80_NF - Z80_CF)
	ora z80_ftable_OR_XOR, x
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
	jsr (VEC_fetch_value)
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
	lda REG_F
	and #($FF - Z80_SF - Z80_ZF - Z80_HF - Z80_PF - Z80_NF - Z80_CF)
	ora z80_ftable_OR_XOR
	sta REG_F
	jmp ZVM_next
}

!macro Z80_XOR_VIA_HL {
	jsr (VEC_fetch_via_HL)
	+Z80_XOR_common
}

!macro Z80_XOR_n {
	jsr (VEC_fetch_value)
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
Z80_instr_AE:      +Z80_XOR_VIA_HL                                             ; XOR (HL)
Z80_instr_AF:      +Z80_XOR_SELF                                               ; XOR A
Z80_instr_EE:      +Z80_XOR_n                                                  ; XOR n
Z80_instr_DD_AE:   +Z80_XOR_VIA_IX_d                                           ; XOR (IX+d)
Z80_instr_FD_AE:   +Z80_XOR_VIA_IY_d                                           ; XOR (IY+d)

; XXX put CP instructions here

Z80_instr_04:      ; INC B

	ldx REG_B
	inc REG_B
	bra Z80_common_INC

Z80_instr_0C:      ; INC C

	ldx REG_C
	inc REG_C
	bra Z80_common_INC

Z80_instr_14:      ; INC D

	ldx REG_D
	inc REG_D
	bra Z80_common_INC

Z80_instr_1C:      ; INC E

	ldx REG_E
	inc REG_E
	bra Z80_common_INC

Z80_instr_24:      ; INC H

	ldx REG_H
	inc REG_H
	bra Z80_common_INC

Z80_instr_2C:      ; INC L

	ldx REG_L
	inc REG_L
	bra Z80_common_INC

Z80_instr_3C:      ; INC A

	ldx REG_A
	inc REG_A

	; FALLTROUGH

Z80_common_INC:

	lda REG_F
	and #(0xFF - Z80_SF - Z80_ZF - Z80_HF - Z80_VF - Z80_NF)
	ora z80_ftable_INC, x
	sta REG_F
	jmp ZVM_next

Z80_instr_34:      ; INC (HL)

	jsr (VEC_fetch_via_HL)
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

Z80_instr_05:      ; DEC B

	ldx REG_B
	dec REG_B
	bra Z80_common_DEC

Z80_instr_0D:      ; DEC C

	ldx REG_C
	dec REG_C
	bra Z80_common_DEC

Z80_instr_15:      ; DEC D

	ldx REG_D
	dec REG_D
	bra Z80_common_DEC

Z80_instr_1D:      ; DEC E

	ldx REG_E
	dec REG_E
	bra Z80_common_DEC

Z80_instr_25:      ; DEC H

	ldx REG_H
	dec REG_H
	bra Z80_common_DEC

Z80_instr_2D:      ; DEC L

	ldx REG_L
	dec REG_L
	bra Z80_common_DEC

Z80_instr_3D:      ; DEC A

	ldx REG_A
	dec REG_A

	; FALLTROUGH

Z80_common_DEC:

	lda REG_F
	and #(0xFF - Z80_SF - Z80_ZF - Z80_HF - Z80_VF - Z80_NF)
	ora z80_ftable_DEC, x
	sta REG_F
	jmp ZVM_next

Z80_instr_35:      ; DEC (HL)

	jsr (VEC_fetch_via_HL)
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
