	;; Pack a word using the simple compression scheme.
	;; This has to be the same implementation as in compress_text.c
	;; because we compress input lines of BASIC to do the tokenisation.
	;; This allows us to search through the compressed tokens directly
	;; using the compressed fragment of BASIC, and thus work out the
	;; token for a given piece of string.
	;; This also helps ensure that we have an implementation that is totally
	;; different to that of the original C64 BASIC, as well as likely
	;; saving a bit of space in the ROM, especially once we start implementing
	;; larger keyword vocabs for BASIC 7 or BASIC 10 compatibility, since the
	;; compression and decompression machinery is of fixed size.

pack_word:
	;; Inputs:
	;; X = offset of string to pack. Address is $0200 + X
	;; tokenise_work1 = number of bytes to pack
	;; tokenise_work2 = packed length of string

	;; Outputs:
	;; Output is written to $0100 (bottom of stack).

	;; Memory modified:
	;; tokenise_work4 = temporary storage
	;; tokenise_work3 = flag for whether we have a nybl prepared or not.
	;; (This can also be checked on exit, to know whether the last byte
	;; is incomplete, which is important for searching for abbreviated
	;; key words.)

	;; Initialise internal variables
	lda #$00
	sta tokenise_work2
	sta tokenise_work3

pack_char_loop:
	;; Get the next char
	lda $0200,x
	;; Work out what type of character we have, and thus
	;; how we need to pack it.
	jsr get_packed_char_index
	
	cmp #$00
	bne not_exception_char

	;; Char is an exception char.
	;; We need to either finish the previous byte with $xF,
	;; Or if there is no existing nybl, then we need to output
	;; either $FE or $FF, depending on whether this is the last
	;; byte or not

	lda tokenise_work3
	bne have_nybl_before_exception_char

	;; No nybl exists before the exception char, so prefix with $FE or $FF
	;; based on whether we are at the end of the input string or not
	inx
	cpx tokenise_work1
	beq at_end
	lda #$FF
at_end: .byte $2C
	LDA #$FE
	dex
	ldy tokenise_work2
	sta $0100,y
	inc tokenise_work2
	
	jmp output_exception_byte

have_nybl_before_exception_char:
	;; Or existing byte with #$0F, and clear nybl flag
	ldy tokenise_work2
	dey
	lda $0100,y
	ora #$0f
	sta $0100,y

	;; Clear have nybl flag
	lda #$00
	sta tokenise_work3
	
	;; FAll through

output_exception_byte:	
	ldy tokenise_work2
	lda $0200,x
	sta $0100,y
	iny
	sty tokenise_work2
	jmp consider_next_char

not_exception_char:
	;; It wasn't an exception char, so write the symbol out
	cmp #$10
	bcs whole_byte_symbol
	;; Nybl value
	ldy tokenise_work3
	bne store_low_nybl
	;; Store in high nybl -- so shift it into the hi nybl
	asl
	asl
	asl
	asl
	ldy tokenise_work2
	sta $0100,y
	bne stored_nybl 	; Must be taken, as A cannot be $00
	
store_low_nybl:	
	ldy tokenise_work2
	ora $0100,y
	sta $0100,y
stored_nybl:	
	;; Now toggle the nybl flag
	lda tokenise_work3
	eor #$ff
	sta tokenise_work3
	;; And advance the offset if required
	bne consider_next_char
	inc tokenise_work2
	jmp consider_next_char

whole_byte_symbol:
	ldy tokenise_work3
	beq nothing_to_flush
	;; Set low nybl to $F to mark next byte as literal
	ldy tokenise_work2
	lda $0100,y
	ora #$0f
	sta $0100,y
	inc tokenise_work2
	;; Clear nybl flag
	lda #$00
	sta tokenise_work3
	;; Load literal byte for storing in output
	lda $0200,x
	;; FALL THROUGH

nothing_to_flush:
	;; Write the symbol as it is, or the literal
	;; if it has been passed to us via fall-through
	ldy tokenise_work2
	sta $0100,y
	inc tokenise_work2
	
	;; Fall through
	
consider_next_char:	
	;; Pack next char
	inx 
	cpx tokenise_work1
	bne pack_char_loop

	;; Add 1 to length if nybl waiting to be flushed
	;; (but leave flag set so the caller knows if the
	;; bottom nybl might be different if the string were
	;; longer).
	lda tokenise_work3
	beq +
	inc tokenise_work2
	rts
*	
	;; Last byte was full, so we need at $00 on the end
	;; (unless a $FE token was written 2 bytes ago)
	ldy tokenise_work2
	lda #$00
	sta $0100,y
	inc tokenise_work2	
	
	rts

get_packed_char_index:
	;; Find char in A in the packed char list, and return
	;; $1 - $E, $F1 - $FD if the charactar is abbreviable,
	;; or else return $00 if the character has to be stored literally.

	;; Y register and A are modified, as are processor flags.
	
	ldy #$00
find_char_loop:	
	cmp packed_message_chars,y
	bne not_a_match

	;; Is it a nybl abbreviable char?
	cpy #13
	bcs not_nybl_char
	;; Yes, so add 1 and return it
	iny
	tya
	rts
	
not_nybl_char:
	cpy #27
	bcs not_a_match
	;; It's a $Fx character.
	;; Since the lowest index is $F, and it should be encoded as $F1
	;; we need to add $E2
	tya
	clc
	adc #$E2
	rts
	
not_a_match:
	iny
	;; Loop until we find it, or we discover it isn't
	;; a character with a special encoding
	cpy #27
	bne find_char_loop
	;; Not a char that we can pack, so return 0
	lda #$00
	rts
