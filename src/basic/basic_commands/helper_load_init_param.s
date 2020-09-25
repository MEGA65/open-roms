;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Sets initial parameters for LOAD and simiar commands
;
; Input:
; - VERCKB content in .A
;


helper_load_init_params:

	; Set LOAD/VERIFY flag

	sta VERCKB

	; FALLTROUGH

helper_load_init_params_no_VERCKB:

	; Set default device, set secondary address to 0

	jsr SELDEV
	ldy #$00                           ; secondary address
	jmp JSETFLS
