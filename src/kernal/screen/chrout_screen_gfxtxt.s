;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; GFX/TXT mode switch handling within CHROUT
;


chrout_screen_GFX:

	lda VIC_YMCSB
	and #$02                           ; to upper case

	; FALLTROUGH

chrout_screen_GFX_TXT_end:

	sta VIC_YMCSB
	jmp chrout_screen_done

chrout_screen_TXT:

	lda VIC_YMCSB
	ora #$02                           ; to lower case
	bne chrout_screen_GFX_TXT_end      ; branch always
