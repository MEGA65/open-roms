;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Random number generator routine
;
; Input:
; - FAC1 (0 - reinitialize the seed with random value, negative - create seed from FAC1)
;
; Output:
; - FAC1
;

rnd_FAC1:

	jsr sgn_FAC1_A

	; FALLTROUGH to rnd_A

