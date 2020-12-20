
;
; Z80 Virtual Machine banking support
;


ZVM_set_bank_0:

	; XXX consider switchink banks using DMA list

	lda #<ZVM_fetch_value_bank_0
	sta VEC_fetch_value+0
	lda #>ZVM_fetch_value_bank_0
	sta VEC_fetch_value+1

	lda #<ZVM_fetch_stack_bank_0
	sta VEC_fetch_stack+0
	lda #>ZVM_fetch_stack_bank_0
	sta VEC_fetch_stack+1

	lda #<ZVM_store_stack_bank_0
	sta VEC_store_stack+0
	lda #>ZVM_store_stack_bank_0
	sta VEC_store_stack+1

	lda #<ZVM_fetch_via_HL_bank_0
	sta VEC_fetch_via_HL+0
	lda #>ZVM_fetch_via_HL_bank_0
	sta VEC_fetch_via_HL+1

	lda #<ZVM_store_via_HL_bank_0
	sta VEC_store_via_HL+0
	lda #>ZVM_store_via_HL_bank_0
	sta VEC_store_via_HL+1

	lda #<ZVM_fetch_via_IX_d_bank_0
	sta VEC_fetch_via_IX_d+0
	lda #>ZVM_fetch_via_IX_d_bank_0
	sta VEC_fetch_via_IX_d+1

	lda #<ZVM_fetch_via_IY_d_bank_0
	sta VEC_fetch_via_IY_d+0
	lda #>ZVM_fetch_via_IY_d_bank_0
	sta VEC_fetch_via_IY_d+1

	lda #<ZVM_store_via_IX_d_bank_0
	sta VEC_store_via_IX_d+0
	lda #>ZVM_store_via_IX_d_bank_0
	sta VEC_store_via_IX_d+1

	lda #<ZVM_store_via_IY_d_bank_0
	sta VEC_store_via_IY_d+0
	lda #>ZVM_store_via_IY_d_bank_0
	sta VEC_store_via_IY_d+1

	lda #<ZVM_fetch_via_nn_bank_0
	sta VEC_fetch_via_nn+0
	lda #>ZVM_fetch_via_nn_bank_0
	sta VEC_fetch_via_nn+1

	lda #<ZVM_store_via_nn_bank_0
	sta VEC_store_via_nn+0
	lda #>ZVM_store_via_nn_bank_0
	sta VEC_store_via_nn+1

	rts

ZVM_set_bank_1:

	lda #<ZVM_fetch_value_bank_1
	sta VEC_fetch_value+0
	lda #>ZVM_fetch_value_bank_1
	sta VEC_fetch_value+1

	lda #<ZVM_fetch_stack_bank_1
	sta VEC_fetch_stack+0
	lda #>ZVM_fetch_stack_bank_1
	sta VEC_fetch_stack+1

	lda #<ZVM_store_stack_bank_1
	sta VEC_store_stack+0
	lda #>ZVM_store_stack_bank_1
	sta VEC_store_stack+1

	lda #<ZVM_fetch_via_HL_bank_1
	sta VEC_fetch_via_HL+0
	lda #>ZVM_fetch_via_HL_bank_1
	sta VEC_fetch_via_HL+1

	lda #<ZVM_store_via_HL_bank_1
	sta VEC_store_via_HL+0
	lda #>ZVM_store_via_HL_bank_1
	sta VEC_store_via_HL+1

	lda #<ZVM_fetch_via_IX_d_bank_1
	sta VEC_fetch_via_IX_d+0
	lda #>ZVM_fetch_via_IX_d_bank_1
	sta VEC_fetch_via_IX_d+1

	lda #<ZVM_fetch_via_IY_d_bank_1
	sta VEC_fetch_via_IY_d+0
	lda #>ZVM_fetch_via_IY_d_bank_1
	sta VEC_fetch_via_IY_d+1

	lda #<ZVM_store_via_IX_d_bank_1
	sta VEC_store_via_IX_d+0
	lda #>ZVM_store_via_IX_d_bank_1
	sta VEC_store_via_IX_d+1

	lda #<ZVM_store_via_IY_d_bank_1
	sta VEC_store_via_IY_d+0
	lda #>ZVM_store_via_IY_d_bank_1
	sta VEC_store_via_IY_d+1

	lda #<ZVM_fetch_via_nn_bank_1
	sta VEC_fetch_via_nn+0
	lda #>ZVM_fetch_via_nn_bank_1
	sta VEC_fetch_via_nn+1

	lda #<ZVM_store_via_nn_bank_1
	sta VEC_store_via_nn+0
	lda #>ZVM_store_via_nn_bank_1
	sta VEC_store_via_nn+1

	rts

ZVM_fetch_opcode_bank_0:

	; XXX implement, should return byte in .A

ZVM_fetch_opcode_bank_1:

	; XXX implement, should return byte in .A

ZVM_fetch_value_bank_0:
ZVM_fetch_value_bank_1:
ZVM_fetch_stack_bank_0:
ZVM_fetch_stack_bank_1:
ZVM_fetch_via_HL_bank_0:
ZVM_fetch_via_HL_bank_1:
ZVM_fetch_via_IX_d_bank_0:
ZVM_fetch_via_IX_d_bank_1:
ZVM_fetch_via_IY_d_bank_0:
ZVM_fetch_via_IY_d_bank_1:
ZVM_fetch_via_nn_bank_0:
ZVM_fetch_via_nn_bank_1:
ZVM_store_stack_bank_0:
ZVM_store_stack_bank_1:

	; XXX
	rts

ZVM_store_via_HL_bank_0:

	; XXX
	jmp ZVM_next

ZVM_store_via_HL_bank_1:

	; XXX
	jmp ZVM_next

ZVM_store_via_IX_d_bank_0:

	; XXX
	jmp ZVM_next

ZVM_store_via_IX_d_bank_1:

	; XXX
	jmp ZVM_next

ZVM_store_via_IY_d_bank_0:

	; XXX
	jmp ZVM_next

ZVM_store_via_IY_d_bank_1:

	; XXX
	jmp ZVM_next

ZVM_store_via_nn_bank_0:

	; XXX
	jmp ZVM_next

ZVM_store_via_nn_bank_1:

	; XXX
	jmp ZVM_next

