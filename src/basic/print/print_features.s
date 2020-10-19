;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_0 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# X16 BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Print configured features and current video system on startup banner
;

!ifdef CONFIG_SHOW_FEATURES {

print_features:

	ldx #IDX__STR_FEATURES
	jsr print_packed_misc_str

	; FALLTROUGH

print_pal_ntsc:

	ldx #IDX__STR_NTSC
	lda TVSFLG
	beq @1
	ldx #IDX__STR_PAL
@1:
	jmp print_packed_misc_str

} ; CONFIG_SHOW_FEATURES
