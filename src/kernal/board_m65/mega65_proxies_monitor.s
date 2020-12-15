;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Proxies for calling MEGA65 segment KERNAL_0 routines from MON_1
;


proxy_M1_CHRIN:

	jsr map_NORMAL
	jsr CHRIN
	bra proxy_M1_end

proxy_M1_CHROUT:

	jsr map_NORMAL
	jsr CHROUT

	; FALLTROUGH

proxy_M1_end:

	jmp map_MON_1


; Routines below typicaly do not change mapping - but it is still possible they'll do


proxy_M1_SECOND:

	jsr SECOND
	bra proxy_M1_end

proxy_M1_TKSA:

	jsr TKSA
	bra proxy_M1_end

proxy_M1_ACPTR:

	jsr ACPTR
	bra proxy_M1_end

proxy_M1_CIOUT:

	jsr CIOUT
	bra proxy_M1_end

proxy_M1_UNTLK:

	jsr UNTLK
	bra proxy_M1_end

proxy_M1_UNLSN:

	jsr UNLSN
	bra proxy_M1_end

proxy_M1_LISTEN:

	jsr LISTEN
	bra proxy_M1_end

proxy_M1_TALK:

	jsr TALK
	bra proxy_M1_end
