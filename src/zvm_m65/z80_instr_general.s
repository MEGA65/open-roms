
;
; Z80 general purpose instructions
;


Z80_instr_2F:      ; CPL

	lda REG_A
	eor #$FF
	sta REG_A

	lda REG_F
	ora #(Z80_HF + Z80_NF)
	sta REG_F
	jmp ZVM_next

; XXX put NEG here

Z80_instr_3F:      ; CCF

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

Z80_instr_37:      ; SCF

	+Z80_PUT_0_HF
	+Z80_PUT_0_NF
	+Z80_PUT_1_CF
	jmp ZVM_next

Z80_instr_76:      ; HALT

	; Used to call BIOS routines

	ldx #$01 ; default BIOS function, warm start

	lda REG_PC
	sec
	sbc #$64
	cmp #33
	bcs @1
	tax
@1:
	txa
	asl
	tax
	jmp (zvm_BIOS_vectable,x)

Z80_instr_F3:      ; DI

	lda #$00
	sta REG_IFF1
	sta REG_IFF2
	jmp ZVM_next

Z80_instr_FB:      ; EI

	lda #Z80_PF
	sta REG_IFF1
	sta REG_IFF2
	jmp ZVM_next
