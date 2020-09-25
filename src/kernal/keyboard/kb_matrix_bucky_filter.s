;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Matrix for filtering out bucky keys while scanning the C64 keyboard
;
; Values based on:
; - [CM64] Computes Mapping the Commodore 64 - pags 58 (SHFLAG), 173 (matrix)
;


!ifndef CONFIG_LEGACY_SCNKEY {


kb_matrix_bucky_filter:

	; values for OR with CIA1_PRB content to filter out bucky keys

	!byte %00000000
	!byte %10000000 ; SHIFT (left)
	!byte %00000000
	!byte %00000000
	!byte %00000000
	!byte %00000000
	!byte %00010000 ; SHIFT (right)
	!byte %00100100 ; VENDOR + CONTROL
}
