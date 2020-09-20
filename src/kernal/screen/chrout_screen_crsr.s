;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Cursor keys handling within CHROUT
;


chrout_screen_CRSR_UP:

	lda TBLX
	beq chrout_screen_CRSR_done
	dec TBLX

	; FALLTROUGH

chrout_screen_CRSR_done:

	jmp chrout_screen_calc_lptr_done


chrout_screen_CRSR_DOWN:

	lda TBLX
	cmp #24
	bne @1
	jsr screen_scroll_up
@1:
	inc TBLX
	jmp chrout_screen_calc_lptr_done


chrout_screen_CRSR_RIGHT:

	jsr screen_get_clipped_PNTR
	cpy #39
	+beq screen_advance_to_next_line
	
	iny

	; FALLTROUGH

chrout_screen_CRSR_LR_end:

	sty PNTR
	bpl chrout_screen_CRSR_done        ; branch always


chrout_screen_CRSR_LEFT:

	jsr screen_get_clipped_PNTR
	dey
	bpl chrout_screen_CRSR_LR_end

	lda TBLX
	beq chrout_screen_CRSR_done

	dec TBLX
	lda #39
	sta PNTR
	bne chrout_screen_CRSR_done        ; branch always
