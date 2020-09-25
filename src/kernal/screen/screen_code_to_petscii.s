;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# X16 *        #IGNORE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Screen code to PETSCII conversion - see:
;
; - https://www.lemon64.com/forum/viewtopic.php?t=66362
; - https://sta.c64.org/cbm64scrtopetext.html
;


screen_code_to_petscii:

	cmp #$20
	bcc s2p_adc_40                     ; $00-$1F -> $40-$5F

	cmp #$40
	bcc s2p_end                        ; $20-$3F -> $20-$3F

	cmp #$60
	bcc s2p_adc_80                     ; $40-$5F -> $C0-$DF

	cmp #$80
	bcc s2p_adc_40                     ; $60-$7F -> $A0-$BF

	; Here we have to check for quote mode

	bit QTSW
	bmi screen_code_to_petscii_quote

	; Not quote mode - continue

	cmp #$A0
	bcc s2p_adc_C0                     ; $80-$9F -> $40-$5F

	cmp #$C0
	bcc s2p_adc_80                     ; $A0-$BF -> $20-$3F

	cmp #$E0
	bcc s2p_end                        ; $C0-$DF -> $C0-$DF

	clc
	bcc s2p_adc_C0                     ; $E0-$FF -> $A0-$BF

s2p_adc_40:

	adc #$40                           ; Carry already clear

s2p_end:

	rts

s2p_adc_80:

	adc #$80                           ; Carry already clear
	rts

screen_code_to_petscii_quote:

	cmp #$C0
	bcc s2p_adc_80                     ; $80-$BF -> $00-$3F

	clc

	; FALLTROUGH                         $C0-$FF -> $80-$BF

s2p_adc_C0:

	adc #$C0                           ; Carry already clear
	rts
