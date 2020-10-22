;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_1 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tries to detect
;
; Carry clear - normal, Carry set - turbo
;

!ifdef CONFIG_TAPE_AUTODETECT {


tape_common_autodetect:

	; Set screen color to something neutral, silence the audio
	lda #$0B
	sta VIC_EXTCOL
	lda #$00
!ifdef CONFIG_MB_M65 {
	sta SID_SIGVOL + __SID_R1_OFFSET
	sta SID_SIGVOL + __SID_L1_OFFSET
} else {
	sta SID_SIGVOL
}

	; FALLTROUGH

tape_common_autodetect_retry:

	; It is not trivial to distinguish between normal and turbo,
	; as short pulses of normal (and sync uses only shorts)
    ; have similar lengths as long pulses of turbo

	; Thus, the routine here reads certain amount of pulses
	; looking for evidence for either normal or turbo system;
	; in case of no evidence found, assume normal

	lda #$00                           ; plus = probably normal, minus = turbo
	sta XSAV

	ldy #$60                           ; $60 pulses cover 12 bytes of turbo recording
	jsr tape_common_get_pulse          ; first pulse might be a garbage, ignore it

	; FALLTROUGH

tape_common_autodetect_loop:

	jsr tape_common_get_pulse          ; read pulse for detection attempt
	
	; If garbage found, retry detection
	cmp #$28
	bcc tape_common_autodetect_retry   ; this is a VERY long pulse
	cmp #$E8
	bcs tape_common_autodetect_retry   ; this is a VERY short pulse

	; First try to distinguish turbo short signal (reference: $CD)
	; from normal signals (reference: $A5 or lower), these values
	; give us threshold of ($CD + $A5) / 2 = $B9

	cmp #$B9
	bcc @1
	dec XSAV                           ; above $B9 (so signal is shorter), looks like turbo 
@1:
	; Now try to distinguish turbo signals (reference: $B1 or higher)
	; from normal medium/long signals (reference: $7D or below), these values
	; give us threshold of ($B1 + $7D) / 2 = $97

	cmp #$97
	bcs @2
	inc XSAV
@2:
	; The sync for turbo is not too long - if we have enough evidence,
	; assume turbo recording already

	lda XSAV
	cmp #$FD
	beq tape_common_autodetect_turbo

	; Next iteration
	dey
	bpl tape_common_autodetect_loop

	; Last chance for turbo

	lda XSAV
	bmi tape_common_autodetect_turbo

	; FALLTROUGH

tape_common_autodetect_normal:

	clc
	rts

tape_common_autodetect_turbo:

	sec
	rts
}
