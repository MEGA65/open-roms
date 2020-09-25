;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape head alignemnt tool - prints out a help message on screen
;


!ifdef CONFIG_TAPE_HEAD_ALIGN {


; Helper variable - reuse BASIC numeric work area on zero page

!addr __ha_storage = TEMPF1;          ; 1 byte


tape_head_align_print_help:

	; Make screen font visible

	lda CPU_R6510
	pha
	and #%11111011
	sta CPU_R6510

	; Print help message

	ldy #$00

	; Retrieve address
@1:
	lda tape_head_align_help_text, y
	iny
	cmp #$FF
	beq tape_head_align_print_end
	sta EAL+0
 
	lda tape_head_align_help_text, y
	iny
	sta EAL+1
@2:
	; Retrieve and print character

	lda tape_head_align_help_text, y
	iny
	cmp #$FF
	beq @1

	sty __ha_storage
	jsr tape_head_align_print_char
	ldy __ha_storage

	bne @2                             ; branch alwats


tape_head_align_print_end:

	; Restore normal memory configuration and quit

	pla
	sta CPU_R6510
	rts

tape_head_align_print_string:



tape_head_align_print_char:

	; Calculate start address of character in .A

	sta SAL+0
	lda #$00
	sta SAL+1

	asl SAL+0
	rol SAL+1
	asl SAL+0
	rol SAL+1
	asl SAL+0
	rol SAL+1

	clc
	lda SAL+1
	adc #$D0
	sta SAL+1

	; Print out the character

	ldy #$07
@3:
	lda (SAL), y
	sta (EAL), y
	dey
	bpl @3

	; Prepare EAL for the next character

	lda EAL+0
	clc
	adc #$08
	sta EAL+0
	bne @4
	inc EAL+1
@4:
	rts


;
; Strings to print
;

tape_head_align_help_text:

	; Each string consists of:
	; - destination (start byte) address
	; - text in screencodes
	; - $FF to mark end

	!word $2000 + (40 * 8) * 0 + 8 * 1
	!scr  "computer has to tell the signals apart"
	!byte $FF

	!word $2000 + (40 * 8) * 3 + 8 * 6
	!scr  "align head for minimum noise"
	!byte $FF

	!word $2000 + (40 * 8) * 6 + 8 * 2
	!scr  "if the deck has a pitch (tape speed)"
	!byte $FF

	!word $2000 + (40 * 8) * 7 + 8 * 1
	!scr  "control, tweak it so that dotted lines"
	!byte $FF

	!word $2000 + (40 * 8) * 8 + 8 * 5
	!scr  "are half a way between signals"
	!byte $FF

	!byte $FF                          ; end of strings
}
