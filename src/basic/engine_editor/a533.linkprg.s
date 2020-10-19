;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_0 #TAKE
;; #LAYOUT# M65 BASIC_0 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE-FLOAT
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   *       #IGNORE

;
; Well-known BASIC routine, described in:
;
; - [CM64] Computes Mapping the Commodore 64 - page 95
; - https://www.lemon64.com/forum/viewtopic.php?t=64721&sid=bc400a5a6d404f8f092e4d32a92f5de7
;

LINKPRG:

!ifdef SEGMENT_M65_BASIC_0 {

	jsr map_BASIC_1
	jsr (VB1__LINKPRG)
	jmp map_NORMAL

} else {

	; Start by getting pointer to the first line
	jsr init_oldtxt

linkprg_loop:
	; Is the pointer to the end of the program
	ldy #1

!ifdef CONFIG_MB_M65 {
	jsr peek_via_OLDTXT
} else ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<OLDTXT+0
	jsr peek_under_roms
	cmp #$00
} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	jsr peek_under_roms_via_OLDTXT
	cmp #$00
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	bne @1

	; End of program
	rts
@1:
	; Now search forward to find the end of the line
	; Skip forward pointer and line number
	ldy #4

linkprg_end_of_line_search:

!ifdef CONFIG_MB_M65 {
	jsr peek_via_OLDTXT
} else ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<OLDTXT+0
	jsr peek_under_roms
} else ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {
	jsr peek_under_roms_via_OLDTXT
} else { ; CONFIG_MEMORY_MODEL_38K
	lda (OLDTXT),y
}

	cmp #$00
	beq @2

	; Not yet end of line
	iny
	bne linkprg_end_of_line_search

	; line too long
	jmp do_STRING_TOO_LONG_error

@2:
	; Found end of line, so update pointer

	; First, skip over the $00 char
	iny

	; Now overwrite the pointer (carefully)
	;
	tya
	clc
	adc OLDTXT+0
	pha
	php
	ldy #0

!ifdef CONFIG_MB_M65 {
	jsr poke_via_OLDTXT
} else ifdef CONFIG_MEMORY_MODEL_60K {
	ldx #<OLDTXT+0
	jsr poke_under_roms
} else {
	sta (OLDTXT),y
}

	plp
	lda OLDTXT+1
	adc #0
	ldy #1

!ifdef CONFIG_MB_M65 {
	jsr poke_via_OLDTXT
} else ifdef CONFIG_MEMORY_MODEL_60K {
	jsr poke_under_roms
} else {
	sta (OLDTXT),y
}

	sta OLDTXT+1
	pla
	sta OLDTXT+0

	jmp linkprg_loop


} ; ROM layout
