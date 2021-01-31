
;
; Z80 general purpose instructions
;


!macro Z80_DAA_TAB .OTAB, .FTAB {
	ldx REG_A
	lda .OTAB,x
	sta REG_A
	lda .FTAB,x
	sta REG_F
	jmp ZVM_next
}

Z80_instr_27:                                                                  ; DAA

	bbs1 REG_F, @N1
@N0:
	bbs0 REG_F, @N0C1
@N0C0:
	bbs4 REG_F, @N0C0H1
@N0C0H0:
	+Z80_DAA_TAB z80_otable_DAA_N0C0H0, z80_ftable_DAA_N0C0H0
@N0C0H1:
	+Z80_DAA_TAB z80_otable_DAA_N0C0H1, z80_ftable_DAA_N0C0H1
@N0C1:
	bbs4 REG_F, @N0C1H1
@N0C1H0:
	+Z80_DAA_TAB z80_otable_DAA_N0C1H0, z80_ftable_DAA_N0C1H0
@N0C1H1:
	+Z80_DAA_TAB z80_otable_DAA_N0C1H1, z80_ftable_DAA_N0C1H1
@N1:
	bbs0 REG_F, @N1C1
@N1C0:
	bbs4 REG_F, @N1C0H1
@N1C0H0:
	+Z80_DAA_TAB z80_otable_DAA_N1C0H0, z80_ftable_DAA_N1C0H0
@N1C0H1:
	+Z80_DAA_TAB z80_otable_DAA_N1C0H1, z80_ftable_DAA_N1C0H1
@N1C1:
	bbs4 REG_F, @N1C1H1
@N1C1H0:
	+Z80_DAA_TAB z80_otable_DAA_N1C1H0, z80_ftable_DAA_N1C1H0
@N1C1H1:
	+Z80_DAA_TAB z80_otable_DAA_N1C1H1, z80_ftable_DAA_N1C1H1

Z80_instr_2F:                                                                  ; CPL

	lda REG_A
	eor #$FF
	sta REG_A

	lda REG_F
	ora #(Z80_HF + Z80_NF)
	sta REG_F
	jmp ZVM_next

Z80_instr_ED_44:                                                               ; NEG
Z80_illeg_ED_4C:                                                               ; NEG
Z80_illeg_ED_54:                                                               ; NEG
Z80_illeg_ED_5C:                                                               ; NEG
Z80_illeg_ED_64:                                                               ; NEG
Z80_illeg_ED_6C:                                                               ; NEG
Z80_illeg_ED_74:                                                               ; NEG
Z80_illeg_ED_7C:                                                               ; NEG

	ldx REG_A
	lda z80_ftable_NEG, x
	sta REG_F
	lda #$00
	sec
	sbc REG_A
	sta REG_A
	jmp ZVM_next

Z80_instr_3F:                                                                  ; CCF

	+Z80_PUT_0_NF
	bbs0 REG_F,@1
@0:
	+Z80_PUT_0_HF
	+Z80_PUT_1_CF
	jmp ZVM_next
@1:
	+Z80_PUT_1_HF
	+Z80_PUT_0_CF
	jmp ZVM_next

Z80_instr_37:                                                                  ; SCF

	+Z80_PUT_0_HF
	+Z80_PUT_0_NF
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_76:                                                                  ; HALT

	; Used to call BIOS and simulated CP/M routines

	+Z80_FETCH_VIA_PC_INC

	cmp  #$FF                ; $FF = CP/M call
	+beq zvm_CPMemu

@halt: ; XXX temporary, as the BIOS is not ready yet
	bra @halt

	ldx #$01                 ; default routine, warm boot

	cmp #33
	bcs @1
	tax
@1:
	txa
	asl
	tax
	jmp (zvm_BIOS_vectable,x)

Z80_instr_F3:                                                                  ; DI

	lda #$00
	sta REG_IFF1
	sta REG_IFF2
	jmp ZVM_next

Z80_instr_FB:                                                                  ; EI

	lda #Z80_PF
	sta REG_IFF1
	sta REG_IFF2
	jmp ZVM_next
