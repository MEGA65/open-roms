;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Helper values to quickly determine row offset from the start of keyboard matrix
;


!ifndef CONFIG_LEGACY_SCNKEY {


kb_matrix_row_offsets:

	; - offsets (in bytes) to the first bytes of keyboard matrix rows

	!byte 0*8
	!byte 1*8
	!byte 2*8
	!byte 3*8
	!byte 4*8
	!byte 5*8
	!byte 6*8
	!byte 7*8
}
