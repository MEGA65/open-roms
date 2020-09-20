;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Get PNTR value clipped to 0-39 range in .Y, sets flags to compare with 0, can trash .A
;

screen_get_clipped_PNTR:

	ldy PNTR
	cpy #40
	bcc @1
	tya
	sbc #40
	tay
@1:
	cpy #$00
	rts
