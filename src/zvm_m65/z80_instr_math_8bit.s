
;
; Z80 arithmetic instructions, 8 bit
;

; XXX put ADD instructions here
; XXX put SUB instructions here
; XXX put SBC instructions here
; XXX put AND instructions here
; XXX put OR instructions here
; XXX put XOR instructions here
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
