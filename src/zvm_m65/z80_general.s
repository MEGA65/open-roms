
;
; Z80 general purpose instructions
;


Z80_illegal__DD:
Z80_illegal__ED:
Z80_illegal__FD:
Z80_illegal__DDCB:
Z80_illegal__FDCB:

	inc REG_R06 ; XXX check if this is correct

	; FALLTROUGH

Z80_instr_40:      ; LD B,B
Z80_instr_49:      ; LD C,C
Z80_instr_52:      ; LD D,D
Z80_instr_5B:      ; LD E,E
Z80_instr_64:      ; LH H,H
Z80_instr_6D:      ; LD L,L
Z80_instr_7F:      ; LD A,A
Z80_instr_00:      ; NOP

	rts
