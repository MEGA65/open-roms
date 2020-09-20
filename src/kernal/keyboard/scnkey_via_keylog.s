;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

; Short helper jump-via-vector routine, to set the keyboard matrix

!ifndef HAS_OPCODES_65CE02 {

scnkey_via_keylog:

	jmp (KEYLOG)
}
