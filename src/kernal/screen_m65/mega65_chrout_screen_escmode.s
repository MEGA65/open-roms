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

m65_chrout_esc_LBR: ; set monochrome display
	
	lda #$80
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

m65_chrout_esc_RBR: ; set color display

	lda #$00
	jsr m65_colorset
	bra m65_chrout_esc_done_1

m65_chrout_esc_J: ; move cursor to the beginning of the line        XXX update for window mode

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

m65_chrout_esc_P: ; erase everything from start of the line to cursor      XXX update for window mode
	
	phz
	ldz #$FF
	lda #$20
@1:
	inz
	sta [M65_LPNT_SCR], z
	cpz M65__TXTCOL
	bne @1

	plz
	bra m65_chrout_esc_done_1

m65_chrout_esc_Q: ; erase everything from cursor till the end of line      XXX update for window mode

	phz
	ldx M65_SCRMODE
	lda m65_scrtab_txtwidth,x
	taz
	lda #$20
@1:
	dez
	sta [M65_LPNT_SCR], z
	cpz M65__TXTCOL
	bne @1

	plz
	bra m65_chrout_esc_done_1

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

m65_chrout_esc_AT: ; clears everything from cursor till end of the screen
	+nop
m65_chrout_esc_A: ; enable auto-insert mode
	+nop
m65_chrout_esc_B: ; set bottom-right window position
	+nop
m65_chrout_esc_C: ; disable auto-insert mode
	+nop
m65_chrout_esc_D: ; delete current line, move content up
	+nop
m65_chrout_esc_E: ; disable cursor flashing
	+nop
m65_chrout_esc_F: ; enable cursor flashing
	+nop
m65_chrout_esc_G: ; enable bell
	+nop
m65_chrout_esc_H: ; disable bell
	+nop
m65_chrout_esc_I: ; insert empty line, move content down
	+nop
m65_chrout_esc_L: ; enable screen scrolling
	+nop
m65_chrout_esc_M: ; disable screen scrolling, wrap-around mode
	+nop
m65_chrout_esc_T: ; set top-left window position
	+nop
m65_chrout_esc_V: ; scroll screen up one line
	+nop
m65_chrout_esc_W: ; scroll screen down one line
	+nop
m65_chrout_esc_Y: ; set default TAB stops
	+nop
m65_chrout_esc_Z: ; clear all the TAB stops
	+nop


	jmp m65_chrout_screen_done
