;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; This is a part CINT which initializes screen and keyboard
;
; For more details see:
; - [RG64] C64 Programmers Reference Guide   - page 280
; - [CM64] Computes Mapping the Commodore 64 - page 242
;


cint_screen_keyboard:

	; Setup KEYLOG vector

	lda #<scnkey_set_keytab
	sta KEYLOG+0
	lda #>scnkey_set_keytab
	sta KEYLOG+1

	; Initialise cursor blink flags (Computes Mapping the 64 p215)

	lda #$01
	sta BLNCT
	sta BLNSW

	; Enable cursor repeat - XXX make it configurable

!ifdef CONFIG_KEY_REPEAT_DEFAULT { !ifndef CONFIG_KEY_REPEAT_ALWAYS {

	lda #$80
	sta RPTFLG
} }

	; Set current colour for text (Computes Mapping the 64 p215)
	ldx #CONFIG_COLOR_TXT
	stx COLOR

	; Set maximum keyboard buffer size (Computes Mapping the 64 p215)
	ldx #10
	stx XMAX
	
	; Put non-zero value in MODE to enable case switch
	ldx #$00
	stx MODE

	; Fallthrough/jump to screen clear routine (Computes Mapping the 64 p215)

	jmp clear_screen
