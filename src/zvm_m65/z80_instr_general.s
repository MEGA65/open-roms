
;
; Z80 general purpose instructions
;


Z80_instr_F3:      ; DI

	lda #$00
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

Z80_instr_FB:      ; EI

	lda #Z80_PF
	sta REG_IFF1
	sta REG_IFF2
	jmp ZVM_next
