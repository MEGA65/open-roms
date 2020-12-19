
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

	; LD instructions with no effect
Z80_instr_40:      ; LD B,B
Z80_instr_49:      ; LD C,C
Z80_instr_52:      ; LD D,D
Z80_instr_5B:      ; LD E,E
Z80_instr_64:      ; LH H,H
Z80_instr_6D:      ; LD L,L
Z80_instr_7F:      ; LD A,A
	; For interrupts (not emulated as of yet)
Z80_instr_ED_46:   ; IM 0
Z80_instr_ED_56:   ; IM 1
Z80_instr_ED_5E:   ; IM 2
	; Real NOP
Z80_instr_00:      ; NOP

	jmp ZVM_next

Z80_instr_F3:      ; DI

	lda #$00
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

Z80_instr_FB:      ; EI

	lda #Z80_PF
	sta REG_IFF1
	sta REG_IFF2
	jmp ZVM_next
