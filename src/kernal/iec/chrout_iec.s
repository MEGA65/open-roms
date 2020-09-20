;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; IEC part of the CHROUT routine
;


chrout_iec:

	lda SCHAR
	jsr JCIOUT
	+bcc chrout_done_success
	jmp chrout_done_fail
