;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Check if VERIFY asked - if yes, terminate loading
;


!ifdef HAS_TAPE {


tape_ditch_verify:

	lda VERCKK
	bne @1
	rts
@1:
	pla
	pla
	jmp lvs_device_not_found_error
}
