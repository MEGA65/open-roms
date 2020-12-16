;; #LAYOUT# M65 KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


MONITOR:

	jsr m65_shadow_BZP
	jsr map_MON_1
	jmp ($4000)

	; Monitor knows, that it should exit via m65_shadow_BZP
