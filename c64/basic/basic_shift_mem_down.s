basic_shift_mem_down_and_relink:
	;; Shift memory down to basic_current_line_pointer
	;; from X bytes further along.

	;; Destination is basic_current_line_ptr
	lda basic_current_line_ptr+0
	sta memmove_dst+0
	lda basic_current_line_ptr+1
	sta memmove_dst+1	
	
	;; Source is that plus X
	txa
	pha 			; also keep for later
	clc
	adc basic_current_line_ptr+0
	sta memmove_src+0
	lda basic_current_line_ptr+1
	adc #0
	sta memmove_src+1

	;; Size is distance from source to end of BASIC text.
	lda basic_end_of_text_ptr+0
	sec
	sbc memmove_src+0
	sta memmove_size+0
	lda basic_end_of_text_ptr+1
	sbc memmove_src+1
	sta memmove_size+1

	jsr printf
	.byte "TOP OF BASIC = $"
	.byte $f1,<basic_end_of_text_ptr,>basic_end_of_text_ptr
	.byte $f0,<basic_end_of_text_ptr,>basic_end_of_text_ptr
	.byte $0d
	.byte "SHIFTING DOWN $"
	.byte $f1,<memmove_size,>memmove_size
	.byte $f0,<memmove_size,>memmove_size
	.byte " BYTES FROM $"
	.byte $f1,<memmove_src,>memmove_src
	.byte $f0,<memmove_src,>memmove_src
	.byte " TO $"
	.byte $f1,<memmove_dst,>memmove_dst
	.byte $f0,<memmove_dst,>memmove_dst
	.byte $0d,0
	
	;; The copy routine that copies under the ROMs is as simple
	;; as possible to be as small as possible, so we have
	;; to adjust the pointers and counts so that the simple
	;; increment and decrement bounds checks work.

	;; Specifically we want Y pre-set so that the end of the
	;; copy ends when Y = $00.
	;; So if copying 1 byte, we want Y=$FF
	;; This means we have to then reduce the source and
	;; target pointers by the same amount

	lda memmove_size+0
	eor #$ff
	sta tokenise_work3
	sta memmove_size+0

	lda memmove_src+0
	sec
	sbc tokenise_work3
	sta memmove_src+0
	lda memmove_src+1
	sbc #0
	sta memmove_src+1

	lda memmove_dst+0
	sec
	sbc tokenise_work3
	sta memmove_dst+0
	lda memmove_dst+1
	sbc #0
	sta memmove_dst+1

	;; Get Y value ready for the copy
	ldy memmove_size+0
	
	jsr printf
	.byte "REVISED BOUNDS $"
	.byte $f1,<memmove_size,>memmove_size
	.byte $f0,<memmove_size,>memmove_size
	.byte " BYTES FROM $"
	.byte $f1,<memmove_src,>memmove_src
	.byte $f0,<memmove_src,>memmove_src
	.byte " TO $"
	.byte $f1,<memmove_dst,>memmove_dst
	.byte $f0,<memmove_dst,>memmove_dst
	.byte $0d,0

	jsr shift_mem_down

	inc $d020
	
	;; Get length of deletion back
	pla
	sta tokenise_work3
	
relink_down_next_line:
	inc $d020
	jmp relink_down_next_line

	;; Subtract tokenise_work3 from the pointer
	ldy #0
	ldx #<basic_current_line_ptr+0
	jsr peek_under_roms
	sec
	sbc tokenise_Work3
	sta memmove_src+0
	iny
	jsr peek_under_roms
	sbc #0
	sta memmove_src+1

	ldy #0
	ldx #<basic_current_line_ptr
	lda memmove_src+0
	jsr poke_under_roms
	iny
	lda memmove_src+1
	jsr poke_under_roms

relink_down_loop:	
	;; Now advance pointer to the next line,
	lda memmove_src+0
	sta basic_current_line_ptr+0
	lda memmove_src+1
	sta basic_current_line_ptr+1

	;; Have we run out of lines to patch?
	ldx #<basic_current_line_ptr
	jsr peek_pointer_null_check
	bcs relink_down_next_line

	rts
	
