
;
; Z80 Virtual Machine CP/M simulation (just to run selected binaries)
;


zvm_CPMemu:

	ldx REG_C
	cpx #$09
	beq zvm_CPMemu_09
	cpx #$02
	beq zvm_CPMemu_02

	; XXX implement additional functions if needed

	; FALLTROUGH

zvm_CPMemu_end:

	jmp Z80_instr_C9         ; RET

zvm_CPMemu_02:               ; C_WRITE

	lda REG_E
	jsr CHROUT
	bra zvm_CPMemu_end

zvm_CPMemu_09:               ; C_WRITESTR

	+Z80_FETCH_VIA_DE
	cmp #$24                 ; CP/M string termination character
	beq zvm_CPMemu_end

	jsr CHROUT
	inw REG_DE
	bra zvm_CPMemu_09
