;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Extended keyboard matrix for Commodore 128 keyboards, based on
;
; - [CM128] Computes Mapping the Commodore 128 - page 290
; - http://commodore128.mirkosoft.sk/keyboard.html
;


!ifdef CONFIG_KEYBOARD_C128 {


kb_matrix_128:

	!byte KEY_HELP,$38,$35,$00,$32,$34,$37,$31 ; $00 replaces TAB key
	!byte KEY_ESC,$2B,$2D,$8D,$0D,$36,$39,$33
	!byte $00,$30,$2E,$91,$11,$9D,$1D,$00


kb_matrix_128_bucky_filter:

	; values for OR with CIA1_PRB content to filter out bucky keys

	!byte %00000000
	!byte %00000000 
	!byte %10000001 ; ALT, NO_SCRL
}
