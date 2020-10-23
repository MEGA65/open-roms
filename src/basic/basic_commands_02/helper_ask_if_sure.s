;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# CRT BASIC_1 #TAKE
;; #LAYOUT# M65 BASIC_1 #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; For direct mode, asks the user if he is sure (sets Carry if not);
; otherwise returns with Carry clear
;


!ifndef HAS_SMALL_BASIC {

helper_ask_if_sure:

!ifdef SEGMENT_M65_BASIC_0 {

	jsr map_BASIC_1
	jsr (VB1__helper_ask_if_sure)
	jmp map_NORMAL

} else ifdef SEGMENT_CRT_BASIC_0 {

	jsr map_BASIC_1
	jsr JB1__helper_ask_if_sure
	jmp map_NORMAL

} else {

	; First check, if we are in direct mode,; if not, do not ask

	ldx CURLIN+1
	inx
	bne helper_ask_if_sure_ok                    ; branch if not direct mode

	; Not direct mode - display the question

	ldx #IDX__STR_IF_SURE
	jsr print_packed_misc_str

	; Clear the keyboard queue

	lda #$00
	sta NDX

	; Enable cursor, fetch the answer

	lda #$00
	sta BLNSW
@1:
	jsr JGETIN
	cmp #$00
	beq @1

	; Check if 'Y'

	cmp #$59
	beq @2

	lda #$4E                                     ; 'N'
	jsr JCHROUT

	sec
	rts
@2:
	; Display 'Y' and wait a short moment for a better user experience

	jsr JCHROUT

	clc
	lda TIME+2
	adc #$0C
@3:
	cmp TIME+2
	bne @3

	; FALLTROUGH

helper_ask_if_sure_ok:

	clc
	rts


} ; ROM layout

} ; !HAS_SMALL_BASIC
