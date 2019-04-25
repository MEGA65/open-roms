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
*	lda $0200,x
	;; Work out what type of character we have, and thus
	;; how we need to pack it.
	jsr get_packed_char_index
	sta $0100,x
	inx 
	cpx tokenise_work1
	bne -
	lda tokenise_work1
	sta tokenise_work2
	
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
