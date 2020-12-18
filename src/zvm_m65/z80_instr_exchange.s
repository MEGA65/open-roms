
;
; Z80 data exchange instructions
;


Z80_instr_EB:      ; EX DE,HL

	ldx REG_D
	ldy REG_H
	sty REG_D
	stx REG_H

	ldx REG_E
	ldy REG_L
	sty REG_E
	stx REG_L

	rts

Z80_instr_08:      ; EX AF,AF''

	ldx REG_A
	ldy REG_A_SH
	sty REG_A
	stx REG_A_SH

	ldx REG_F
	ldy REG_F_SH
	sty REG_F
	stx REG_F_SH

	rts

Z80_instr_D9:      ; EXX

	ldx REG_B
	ldy REG_B_SH
	sty REG_B
	stx REG_B_SH

	ldx REG_C
	ldy REG_C_SH
	sty REG_C
	stx REG_C_SH

	ldx REG_D
	ldy REG_D_SH
	sty REG_D
	stx REG_D_SH

	ldx REG_E
	ldy REG_E_SH
	sty REG_E
	stx REG_E_SH

	ldx REG_H
	ldy REG_H_SH
	sty REG_H
	stx REG_H_SH

	ldx REG_L
	ldy REG_L_SH
	sty REG_L
	stx REG_L_SH

	rts
