;; #LAYOUT# M65 KERNAL_0 #TAKE-FLOAT
;; #LAYOUT# M65 KERNAL_1 #TAKE-FLOAT
;; #LAYOUT# M65 KERNAL_C #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Definitions for communication with MEGA65 segment KERNAL_C from KERNAL_0 / KERNAL_1
;


!ifndef SEGMENT_KERNAL_C {

	; Label definitions

	!addr VKC__m65_cursor_blink          = $C000 + 2 * 0
	!addr VKC__m65_scnkey                = $C000 + 2 * 1
	!addr VKC__m65_scnkey_init_keylog    = $C000 + 2 * 2

} else {

	; Vector table (Open ROMs private!)

	!word m65_cursor_blink
	!word m65_scnkey
	!word m65_scnkey_init_keylog
}
