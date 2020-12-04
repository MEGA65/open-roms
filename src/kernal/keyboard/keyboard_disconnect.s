;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper routine - disconnects the keyboard from CIA1_PRB,
; leaves $FF in .X (behavior needed in some places)
;


keyboard_disconnect:

	ldx #$FF
	stx CIA1_PRA  ; disconnect all the rows
!ifdef CONFIG_KEYBOARD_C128 {
	stx VIC_XSCAN
}

	rts
