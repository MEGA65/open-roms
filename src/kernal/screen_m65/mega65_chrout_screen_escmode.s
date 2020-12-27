;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_chrout_screen_escmode:

	; Regardless if the escape sequence is supported, or not - cancel escape mode

	lda #$00
	sta M65_ESCMODE

	; Select subroutine

	txa
	; XXX cmp #$BD                 ; SHIFT + '@'
	; XXX beq m65_chrout_esc_AT
	sec
	sbc #$30                 ; '0'
	cmp #$2E
	bcs m65_chrout_esc_done

	; XXX add workaround for SHIFT+key

	asl
	tax
	jmp (m65_chrout_screen_jumptable_escape, x)

m65_chrout_esc_J: ; move cursor to the beginning of the line

	lda #$00
	sta M65__TXTCOL
	bra m65_chrout_esc_done

m65_chrout_esc_O: ; cancel quote, reverse, underline, flash, etc

	lda COLOR
	and #$0F
	sta COLOR

	lda #$00
	sta QTSW
	sta INSRT
	sta RVS

	; FALLTROUGH

m65_chrout_esc_done:

	jmp m65_chrout_screen_done



; XXX: implement screen routines below:

m65_chrout_esc_0:
	+nop
m65_chrout_esc_1:
	+nop
m65_chrout_esc_2:
	+nop
m65_chrout_esc_3:
	+nop
m65_chrout_esc_4:
	+nop
m65_chrout_esc_5:
	+nop
m65_chrout_esc_6:
	+nop
m65_chrout_esc_7:
	+nop
m65_chrout_esc_8:
	+nop
m65_chrout_esc_9:
	+nop
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
m65_chrout_esc_K:
	+nop
m65_chrout_esc_L:
	+nop
m65_chrout_esc_M:
	+nop
m65_chrout_esc_N:
	+nop
m65_chrout_esc_P:
	+nop
m65_chrout_esc_Q:
	+nop
m65_chrout_esc_R:
	+nop
m65_chrout_esc_S:
	+nop
m65_chrout_esc_T:
	+nop
m65_chrout_esc_U:
	+nop
m65_chrout_esc_V:
	+nop
m65_chrout_esc_W:
	+nop
m65_chrout_esc_X:
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
