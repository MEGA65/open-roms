
;
; Z80 Virtual Machine CP/M simulation (just to run selected binaries)
;


zvm_CPMemu:

	jsr PRIMM
	!pet "DBG: CP1", $0D, 0

	ldx REG_C
	cpx #$09
	beq zvm_CPMemu_09

	; XXX implement additional functions if needed

	; FALLTROUGH

zvm_CPMemu_end:

	jmp Z80_instr_C9         ; RET

zvm_CPMemu_09:               ; C_WRITESTR

	+Z80_FETCH_VIA_DE
	cmp #'$'
	beq zvm_CPMemu_end

	jsr CHROUT
	inw REG_DE
	bra zvm_CPMemu_09
