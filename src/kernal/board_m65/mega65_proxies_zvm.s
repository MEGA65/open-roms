;; #LAYOUT# M65 KERNAL_C #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Proxies for calling MEGA65 segment KERNAL_0 routines from ZVM_1
;


proxy_Z1_CHROUT:

	jsr CHROUT

	; FALLTROUGH

proxy_Z1_end:

	jmp map_ZVM_1
