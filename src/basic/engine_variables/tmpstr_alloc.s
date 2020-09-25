;; #LAYOUT# STD *       #TAKE
;; #LAYOUT# *   BASIC_0 #TAKE
;; #LAYOUT# *   *       #IGNORE

;
; Allocates memory for a temporary string
;
; Input:
; -.A desired string length, has to be > 0
;
; Output:
; - VARPNT points to the newly alocated descriptor
;

tmpstr_alloc:

	tax

	; First we need to find a free temporary string descriptor

	lda TEMPPT
	cmp #$22
	bcs tmpstr_alloc_try_reuse

	tay
	sta LASTPT
	clc
	adc #$03
	sta TEMPPT

	; FALLTROUGH

tmpstr_alloc_found:

	; Store desired string length

	stx $00, y

	; Store descriptor address

	sty VARPNT+0
	lda #$00
	sta VARPNT+1

	; Jump to alocation routine

	jmp varstr_alloc

tmpstr_alloc_try_reuse:

	; It seems there is no space left - try to find empty entry

	ldy #$19

	; FALLTROUGH

tmpstr_alloc_try_reuse_loop:

	lda $00, y
	beq tmpstr_alloc_found             ; branch if free entry found

	iny
	iny
	iny
	cpy #$22
	bne tmpstr_alloc_try_reuse_loop

	; Everything failed - give up

	jmp do_FORMULA_TOO_COMPLEX_error
