
// XXX provide documentation and finish the implementation

INITMSG:

	// Print PAL/NTSC
	ldx #30 // NTSC
	lda TVSFLG
	beq !+
	ldx #31 // PAL
!:
	jsr print_packed_message

	// Work out free bytes, display them
	jsr basic_do_new
	lda MEMSIZ+0
	sec
	sbc TXTTAB+0
	tax
	lda MEMSIZ+1
	sbc TXTTAB+1

	jsr print_integer
	jsr print_space

	// Print the rest of the start up message
	ldx #34
	jmp print_packed_message
