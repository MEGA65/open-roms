
;
; Z80 data load instructions, 16 bit
;

Z80_instr_C5:      ; PUSH BC

	lda REG_BC+1
	jsr (VEC_store_stack)
	lda REG_BC+0
	jsr (VEC_store_stack)
	jmp ZVM_next	

Z80_instr_D5:      ; PUSH DE

	lda REG_DE+1
	jsr (VEC_store_stack)
	lda REG_DE+0
	jsr (VEC_store_stack)
	jmp ZVM_next

Z80_instr_E5:      ; PUSH HL

	lda REG_HL+1
	jsr (VEC_store_stack)
	lda REG_HL+0
	jsr (VEC_store_stack)
	jmp ZVM_next

Z80_instr_F5:      ; PUSH AF

	lda REG_AF+1
	jsr (VEC_store_stack)
	lda REG_AF+0
	jsr (VEC_store_stack)
	jmp ZVM_next

Z80_instr_DD_E5:   ; PUSH IX

	lda REG_IX+1
	jsr (VEC_store_stack)
	lda REG_IX+0
	jsr (VEC_store_stack)
	jmp ZVM_next

Z80_instr_FD_E5:   ; PUSH IY

	lda REG_IY+1
	jsr (VEC_store_stack)
	lda REG_IY+0
	jsr (VEC_store_stack)
	jmp ZVM_next

Z80_instr_C1:      ; POP BC

	jsr (VEC_fetch_stack)
	sta REG_BC+0
	jsr (VEC_fetch_stack)
	lda REG_BC+1
	jmp ZVM_next

Z80_instr_D1:      ; POP DE

	jsr (VEC_fetch_stack)
	sta REG_DE+0
	jsr (VEC_fetch_stack)
	lda REG_DE+1
	jmp ZVM_next

Z80_instr_E1:      ; POP HL

	jsr (VEC_fetch_stack)
	sta REG_HL+0
	jsr (VEC_fetch_stack)
	lda REG_HL+1
	jmp ZVM_next

Z80_instr_F1:      ; POP AF

	jsr (VEC_fetch_stack)
	sta REG_AF+0
	jsr (VEC_fetch_stack)
	lda REG_AF+1
	jmp ZVM_next

Z80_instr_DD_E1:   ; POP IX

	jsr (VEC_fetch_stack)
	sta REG_IX+0
	jsr (VEC_fetch_stack)
	lda REG_IX+1
	jmp ZVM_next

Z80_instr_FD_E1:   ; POP IY

	jsr (VEC_fetch_stack)
	sta REG_IY+0
	jsr (VEC_fetch_stack)
	lda REG_IY+1
	jmp ZVM_next
