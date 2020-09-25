;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Output:
; .A - current screen mode
;


M65_SCRMODEGET:

	lda M65_SCRMODE

	rts
