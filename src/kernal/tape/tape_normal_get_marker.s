;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_1 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape (normal) helper routine - marker reading
;
; Reeturns marker type in Carry flag, set = end of data (normal marker) or failure (marker while sync)
;


!ifdef CONFIG_TAPE_NORMAL {

	; (L,M) - end of byte, (L,S) - end of data


tape_normal_get_marker: 


	jsr tape_common_get_pulse
	cmp __pulse_threshold_ML
	bcs tape_normal_get_marker                             ; too short for a long pulse

	; FALLTROUGH

tape_normal_get_marker_type:

	jmp tape_common_get_pulse



	; Not an entry point!!!

tape_normal_get_marker_while_sync__loop:

!ifdef HAS_TAPE_AUTOCALIBRATE {
	jsr tape_normal_calibrate_during_pilot                 ; while sync use short pulses for calibration
}
	; FALLTROUGH

tape_normal_get_marker_while_sync:

	jsr tape_common_get_pulse
	bcs tape_normal_get_marker_while_sync__loop             ; branch if short pulse

	cmp __pulse_threshold_ML
	bcs tape_normal_get_marker_while_sync                  ; too short for a long pulse
	
	bcc tape_normal_get_marker_type                        ; branch always
}
