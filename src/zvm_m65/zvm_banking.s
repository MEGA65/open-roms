
;
; Z80 Virtual Machine banking support
;


ZVM_set_bank_0:

	; XXX use DMAgic to switch banks (vectors on zeropage)

	rts

ZVM_set_bank_1:

	; XXX use DMAgic to switch banks (vectors on zeropage)

	rts

ZVM_fetch_IO:

	; XXX fetch addresses via ADDR_IO - but which ones are safe? Should we have a whitelist?
	lda #$00
	sta REG_A
	rts

ZVM_store_IO:

	; XXX again, we should have a whitelist of addresses
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
ZVM_store_via_HL_bank_0:
ZVM_store_via_HL_bank_1:
ZVM_store_via_IX_d_bank_0:
ZVM_store_via_IX_d_bank_1:
ZVM_store_via_IY_d_bank_0:
ZVM_store_via_IY_d_bank_1:
ZVM_store_via_nn_bank_0:
ZVM_store_via_nn_bank_1:

	; XXX
	rts