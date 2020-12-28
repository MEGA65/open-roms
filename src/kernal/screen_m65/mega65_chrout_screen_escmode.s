;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_chrout_screen_escmode:

	; Regardless if the escape sequence is supported, or not - cancel escape mode

	lda #$00
	sta M65_ESCMODE

	; Select subroutine

	txa
	sec
	sbc #$40                           ; '@'
	cmp #$1E
	bcc @1

	; Check for shifted characters

	sec
	sbc #$20
	beq m65_chrout_esc_done_1          ; $60 - character not supported here
	cmp #$1B
	bcc @1

	
	; Check for fgew special shifted characters
	cpx #$3A                           ; colon
	+beq m65_chrout_esc_LBR
	cpx #$3B                           ; semicolon
	+beq m65_chrout_esc_RBR
	cpx #$DB
	+beq m65_chrout_esc_AT

	bra m65_chrout_esc_done_1
@1:
	asl
	tax
	jmp (m65_chrout_screen_jumptable_escape, x)

m65_chrout_esc_J: ; move cursor to the beginning of the line

	lda #$00
	sta M65__TXTCOL
	bra m65_chrout_esc_done_1

m65_chrout_esc_K: ; move cursor after the text within the line       XXX update for window mode

	phz
	ldx M65_SCRMODE
	lda m65_scrtab_txtwidth,x
	sta M65__TXTCOL
	dec
	taz
@1:
	lda [M65_LPNT_SCR], z
	cmp #$20                 ; 'SPACE'
	bne @2
	dec M65__TXTCOL
	dez
	bpl @1
@2:
	plz
	lda M65__TXTCOL
	cmp m65_scrtab_txtwidth,x
	bne m65_chrout_esc_done_1
	dec M65__TXTCOL
	bra m65_chrout_esc_done_1

m65_chrout_esc_O: ; cancel quote, reverse, underline, flash, etc

	jsr m65_screen_clear_colorattr
	jsr m65_screen_clear_special_modes

	; FALLTROUGH

m65_chrout_esc_done_1:

	jmp m65_chrout_screen_done

m65_chrout_esc_X: ; cycle through available screen modes

	lda M65_SCRMODE
	dec
	bpl @1
	lda #$02
@1:
	jsr M65_SCRMODESET
	jsr M65_CLRSCR
	bra m65_chrout_esc_done_1

m65_chrout_esc_S: ; set 'bold' attribute
	
	lda COLOR
	ora #%01000000

	; FALLTROUGH

m65_chrout_esc_COLOR_done:

	sta COLOR
	bra m65_chrout_esc_done_1

m65_chrout_esc_U: ; unset 'bold' attribute

	lda COLOR
	and #%10111111
	bra m65_chrout_esc_COLOR_done

m65_chrout_esc_N: ; normal screen colors

	lda #CONFIG_COLOR_BG
	sta VIC_EXTCOL
	sta VIC_BGCOL0
	lda COLOR
	and #$F0
	ora #CONFIG_COLOR_TXT
	bra m65_chrout_esc_COLOR_done

m65_chrout_esc_R: ; 'reversed' screen colors

	lda #$0B
	sta VIC_EXTCOL
	lda #$0F
	sta VIC_BGCOL0
	lda COLOR
	and #$F0
	bra m65_chrout_esc_COLOR_done







; XXX: implement screen routines below:

m65_chrout_esc_AT:
	+nop
m65_chrout_esc_A:
	+nop
m65_chrout_esc_B:
	+nop
m65_chrout_esc_C:
	+nop
m65_chrout_esc_D:
	+nop
m65_chrout_esc_E:
	+nop
m65_chrout_esc_F:
	+nop
m65_chrout_esc_G:
	+nop
m65_chrout_esc_H:
	+nop
m65_chrout_esc_I:
	+nop
m65_chrout_esc_L:
	+nop
m65_chrout_esc_M:
	+nop
m65_chrout_esc_P:
	+nop
m65_chrout_esc_Q:
	+nop
m65_chrout_esc_T:
	+nop
m65_chrout_esc_V:
	+nop
m65_chrout_esc_W:
	+nop
m65_chrout_esc_Y:
	+nop
m65_chrout_esc_Z:
	+nop
m65_chrout_esc_LBR:
	+nop
m65_chrout_esc_RBR:
	+nop

	jmp m65_chrout_screen_done
