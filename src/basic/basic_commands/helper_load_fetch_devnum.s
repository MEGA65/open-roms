;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE


;
; Tries to fetch device number - sets Carry if failure
;


helper_load_fetch_devnum:

	; Fetch the device number

	jsr fetch_coma_uint8
	bcs @1

	sta FA
@1:
	rts
