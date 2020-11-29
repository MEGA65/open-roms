;; #LAYOUT# M65 KERNAL_0 #TAKE-FLOAT
;; #LAYOUT# M65 KERNAL_C #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Definitions for communication with MEGA65 segment KERNAL_C from KERNAL_0
;


!ifdef SEGMENT_KERNAL_0 {

	; Label definitions

	!addr VKC__m65_scnkey                = $C000 + 2 * 0

} else {

	; Vector table (Open ROMs private!)

	!word m65_scnkey
}
