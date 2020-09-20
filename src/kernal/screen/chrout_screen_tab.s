;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tabulation keys handling within CHROUT
;


!ifdef CONFIG_EDIT_TABULATORS {


chrout_screen_TAB_FW:

	jsr screen_get_clipped_PNTR
	tya
	ora #%00000111
	tay
	iny
	cpy #40
	bcc @1
	ldy #39
@1:
	sty PNTR
	
	jmp chrout_screen_calc_lptr_done


chrout_screen_TAB_BW:

	jsr screen_get_clipped_PNTR
	beq @2                             ; column 0,  recalculating pointers is not necessary, but this is a rare case nevertheless

	dey
	tya
	and #%11111000
	sta PNTR
@2:
	jmp chrout_screen_calc_lptr_done

} ; CONFIG_EDIT_TABULATORS
