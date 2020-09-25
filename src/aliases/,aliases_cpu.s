
;
; Various macros - mainly for making CPU-specific optimizations easier
;



!macro panic @code {
	; If case no panic screen is used, we can skip providing error codes within Kernal
	!ifdef CONFIG_PANIC_SCREEN { lda #@code }
	jmp ($E4B7)
}

!macro skip_2_bytes_trash_nvz {
	; Trick to skip a 2-byte instruction
	!byte $2C
}

!macro lda_zero {
	; WARNING: this one can be dangerous in soem cases, use with care!
	!ifdef HAS_OPCODES_65CE02 {
		tba
	} else {
		lda #$00		
	}
}



; Stack manipulation - some CPUs will leave .A unchanged, some will use it as temporary storage, so consider .A trashed

!macro phx_trash_a { !ifdef HAS_OPCODES_65C02 {
		phx
	} else {
		txa
		pha
} }

!macro phy_trash_a { !ifdef HAS_OPCODES_65C02 {
		phy
	} else {
		tya
		pha
} }

!macro plx_trash_a { !ifdef HAS_OPCODES_65C02 {
		plx
	} else {
		pla
		tax
} }

!macro ply_trash_a { !ifdef HAS_OPCODES_65C02 {
		ply
	} else {
		pla
		tay
} }



; Near jump, on some CPUs can be substituted with shorter instruction

!macro bra @dst { !ifdef HAS_OPCODE_BRA {
		bra @dst
	} else {
		jmp @dst
} }



; NOP definition, MEGA65 CPU uses EOM instead

!macro nop { !ifdef CONFIG_MB_M65 {
		eom
	} else {
		nop
} }



; Branches with far offsets, substitutes by Bxx + JMP for CPUs not supporting the instruction

!macro bcs @dst { !ifdef HAS_OPCODES_65CE02 {
		lbcs @dst
	} else {
		bcc *+5
		jmp @dst
} }

!macro bcc @dst { !ifdef HAS_OPCODES_65CE02 {
		lbcc @dst
	} else {
		bcs *+5
		jmp @dst
} }

!macro beq @dst { !ifdef HAS_OPCODES_65CE02 {
		lbeq @dst
	} else {
		bne *+5
		jmp @dst
} }

!macro bne @dst { !ifdef HAS_OPCODES_65CE02 {
		lbne @dst
	} else {
		beq *+5
		jmp @dst
} }

!macro bmi @dst { !ifdef HAS_OPCODES_65CE02 {
		lbmi @dst
	} else {
		bpl *+5
		jmp @dst
} }

!macro bpl @dst { !ifdef HAS_OPCODES_65CE02 {
		lbpl @dst
	} else {
		bmi *+5
		jmp @dst
} }

!macro bvc @dst { !ifdef HAS_OPCODES_65CE02 {
		lbvc @dst
	} else {
		bvs *+5
		jmp @dst
} }

!macro bvs @dst { !ifdef HAS_OPCODES_65CE02 {
		lbvs @dst
	} else {
		bvc *+5
		jmp @dst
} }
