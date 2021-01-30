
;
; Z80 CPU/memory reset
;


Z80_reset_CPU:

	; Reset registers and internal emulation data
	
	lda #$00
	tay
@1:
	sta z80_cpustate__start, y
	iny
	cpy #(z80_cpustate__end - z80_cpustate__start + 1)
	bne @1

	dew REG_AF               ; AF and SP have $FFFF value at start
	dew REG_SP

	lda TIME+2               ; give a little initial randomness to register R
	sta REG_R06

	; The engine requires all the Z80 visible memory to be present within the 1st 16MB,
	; so set the most significant bytes of 32-bit pointers to 0.

	stz REG_BC_EXT+1
	stz REG_DE_EXT+1
	stz REG_HL_EXT+1
	stz REG_SP_EXT+1
	stz REG_PC_EXT+1
	stz PTR_IXY_d+3
	stz PTR_DATA+3

	; Default bank is 1 (the one user software runs from)	

	jmp ZVM_set_bank_1


Z80_reset_MEM:

	lda #$05
	sta BIOS_LOADPTR+2
	lda #$00
	sta BIOS_LOADPTR+0
	sta BIOS_LOADPTR+1
	sta BIOS_LOADPTR+3

@loop:

	dec BIOS_LOADPTR+2
	sta [BIOS_LOADPTR],z
	inc BIOS_LOADPTR+2
	sta [BIOS_LOADPTR],z

	inw BIOS_LOADPTR
	bne @loop

	rts
