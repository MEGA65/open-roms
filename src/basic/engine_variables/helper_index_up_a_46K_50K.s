;; #LAYOUT# STD *       #TAKE-HIGH
;; #LAYOUT# *   BASIC_0 #TAKE-HIGH
;; #LAYOUT# *   *       #IGNORE

; This has to go $E000 or above - it can be used by routines which bank out the main BASIC ROM!

;
; Helper routine, used in several places
;

!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {

helper_INDEX_up_A:                     ; .A - bytes to increase INDEX, uses DSCPNT+0

	sta DSCPNT+0 

	clc
	lda INDEX+0
	adc DSCPNT+0 
	sta INDEX+0
	bcc @1
	dec INDEX+1
@1:
	rts
}
