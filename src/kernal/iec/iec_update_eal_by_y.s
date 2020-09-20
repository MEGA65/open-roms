;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Common EAL update routine
;


!ifdef CONFIG_IEC_JIFFYDOS_OR_DOLPHINDOS { !ifndef CONFIG_MEMORY_MODEL_60K {


iec_update_EAL_by_Y: ; note: Carry has to be set by caller!

	tya
	adc EAL+0
	sta EAL+0
	bcc @1
	inc EAL+1
@1:
	rts
} }
