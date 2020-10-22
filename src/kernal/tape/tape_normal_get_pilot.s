;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_1 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape (turbo) helper routine - handling the pilot
;

; Injest the pilot - series of short pulses. According to http://sidpreservation.6581.org/tape-format/
; it consist of the following number of pulses:
; - $6A00 for header
; - $1A00 for data and seq block header
; - $4F for repeated header/data


!ifdef CONFIG_TAPE_NORMAL {


tape_normal_get_pilot_header:          ; entry point, reset calibration, require 128x $40 pulses

	; Reading the pilot header is the first action performed,
	; thus start by setting default thresholds

	lda #$91
	sta __pulse_threshold
	lda #$67
	sta __pulse_threshold_ML

	lda #$80

!ifdef CONFIG_TAPE_AUTODETECT {
	ldy #$FF                           ; marker: try to detect turbo
	bmi tape_normal_get_pilot_header_cont
} else {
	+skip_2_bytes_trash_nvz
}

	; FALLTROUGH

tape_normal_get_pilot_data:            ; entry point, require 4x $40 pulses

	lda #$04
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

tape_normal_get_pilot_short:           ; entry point, require 1x $40 pulses

	lda #$01

!ifdef CONFIG_TAPE_AUTODETECT {
	ldy #$00                           ; marker: do not try to detect turbo
	; FALLTROUGH
tape_normal_get_pilot_header_cont:
	sty INBIT
} else {
	+skip_2_bytes_trash_nvz
}

	; FALLTROUGH

tape_normal_get_pilot_common:

	sta FSBLK

	lda #$0B
	sta VIC_EXTCOL

	; FALLTROUGH

tape_normal_get_pilot_common_restart:

	lda FSBLK
	sta ROPRTY

	; FALLTROUGH

tape_normal_get_pilot_common_loop_outer:

	ldy #$40

	; FALLTROUGH

tape_normal_get_pilot_common_loop_inner:

	jsr tape_common_get_pulse
	bcc tape_normal_get_pilot_common_restart     ; not a pilot - try again

!ifdef CONFIG_TAPE_AUTODETECT {
	bit INBIT
	bpl @1
	; Try to distinguish turbo by checking for short signals
	cmp #$B9                                     ; see comment in tape_common_autodetect.s
	bcs @2
@1:
}

	jsr tape_normal_calibrate_during_pilot

	dey
	bne tape_normal_get_pilot_common_loop_inner

	dec ROPRTY
	bne tape_normal_get_pilot_common_loop_outer

	clc
@2:
	rts
}
