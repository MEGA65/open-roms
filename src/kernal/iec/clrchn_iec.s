;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; IEC part of the CLRCHN routine
;


!ifdef CONFIG_IEC {


clrchn_iec:

	; Check input device
	lda DFLTN
	jsr iec_check_devnum_oc
	bcs @1

	; It was IEC device - send UNTALK first
	jsr UNTLK
@1:
	; Check output device
	lda DFLTO
	jsr iec_check_devnum_oc

	; If it was IEC device - send UNLSN first
	+bcc UNLSN

	rts


} ; CONFIG_IEC
