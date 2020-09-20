;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


; Find the BASIC line with number in LINNUM


!ifndef CONFIG_MEMORY_MODEL_46K_OR_50K {

find_line_from_start:

	; Get pointer to start of BASIC text
	jsr init_oldtxt

	; FALLTROUGH

find_line_from_current:

	; Check if line is not empty

	jsr is_line_pointer_null
	beq find_line_fail

	; Fetch the high byte of line number and compare
	ldy #$03

!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<OLDTXT+0
	jsr peek_under_roms
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	cmp LINNUM+1
	beq @1
	bcs find_line_fail                           ; branch if line number too high
	bne find_line_next
@1:

	; Fetch the low byte of line number and compare
	dey

!ifdef CONFIG_MEMORY_MODEL_60K {
	jsr peek_under_roms
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	cmp LINNUM+0
	beq find_line_success
	bcs find_line_fail                           ; branch if line number too high
	bne find_line_next

find_line_success:

	clc
	rts

find_line_next:

	; Advance to the next line

	jsr is_line_pointer_null
	beq find_line_fail                           ; branch in no more lines exist

	ldy #$00

!ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<OLDTXT+0
	jsr peek_under_roms
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	pha
	iny

!ifdef CONFIG_MEMORY_MODEL_60K {
	jsr peek_under_roms
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	sta OLDTXT+1
	pla
	sta OLDTXT+0

	+bra find_line_from_current

find_line_fail:

	sec
	rts
}
