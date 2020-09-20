;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; CHROUT routine - screen support (character output)
;


chrout_screen:

!ifdef CONFIG_MB_M65 {

	jsr M65_MODEGET
	+bcc m65_chrout_screen
}

	jsr cursor_hide_if_visible

	lda SCHAR
	tax

	; All the PETSCII control codes are within $0x, $1x, $8x, $9x, remaining
	; ones are always printable characters; separate away control codes

	and #$60
	+beq chrout_screen_control
	txa

	; Literals - first convert PETSCII to screen code

	jsr chrout_to_screen_code

	; FALLTROUGH

chrout_screen_literal: ; entry point for chrout_screen_quote

	; Write normal character on the screen

	tax                                ; store screen code, we need .A for calculations

	; First we need offset from PNT in .Y, we can take it from PNTR

	jsr screen_get_clipped_PNTR

	; Put the character on the screen

	txa
	ora RVS                            ; Computes Mapping the 64, page 38
	sta (PNT),y

	; Decrement number of chars waiting to be inserted

	lda INSRT
	beq @1
	dec INSRT
@1:
	; Toggle quote flag if required

	txa
	jsr screen_check_toggle_quote

	; Set colour of the newly printed character

	lda COLOR
	sta (USER),y

	; Advance the column

	ldy PNTR
	iny
	sty PNTR

	; Scroll down (extend logical line) if needed

	cpy #40
	bne @2
	jsr screen_grow_logical_line
	inc TBLX
	ldy PNTR
@2:
	; If not the 80th character of the logical row, we are done

	cpy #80
	bcc chrout_screen_calc_lptr_done

	; Advance to the next line

	jmp screen_advance_to_next_line

chrout_screen_calc_lptr_done:

	jsr screen_calculate_pointers

	; FALLTROUGH

chrout_screen_done:

	jsr cursor_show_if_enabled
	jmp chrout_done_success
