
;
; Z80 CPU reset
;


Z80_reset:

	; Reset registers and internal emulation data
	
	lda #$00
	tay
@1:
	sta z80_cpustate__start, y
	iny
	cmp #(z80_cpustate__end - z80_cpustate__start + 1)
	bne @1

	dew REG_AF               ; AF and SP have $FFFF value at start
	dew REG_SP

	lda TIME+2               ; give a little initial randomness to register R
	sta REG_R06

	; The engine requires all the Z80 visible memory to be present within the 1st 16MB,
	; so set the most significant bytes of 32-bit pointers to 0.

	stz REG_BC_EXT1+1
	stz REG_DE_EXT1+1
	stz REG_HL_EXT1+1
	stz REG_SP_EXT1+1
	stz REG_PC_EXT1+1
	stz PTR_IXY_d+3
	stz PTR_DATA+3

	; Some pointers are useful for bank 0 only - we can set another byte there

	lda #$05
	
	sta REG_BC_EXT1+0
	sta REG_DE_EXT1+0
	sta REG_HL_EXT1+0
	sta REG_SP_EXT1+0
	sta REG_PC_EXT1+0

	; Default bank is 1 (the fastest, continuous memory)	

	jmp ZVM_set_bank_1
