;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE-OFFSET 2000
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Math package - compute ST value
;
; See also:
; - https://www.c64-wiki.com/wiki/BASIC-ROM
;

compute_ST:

	lda IOSTATUS
	jmp convert_A_to_FAC1
