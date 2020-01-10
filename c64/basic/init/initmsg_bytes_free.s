#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

//
// Print out the amount of free bytes - for the startup banner
//


initmsg_bytes_free:

	jsr basic_do_new
    sec
	lda MEMSIZ+0
	sbc TXTTAB+0
	tax
	lda MEMSIZ+1
	sbc TXTTAB+1

	jsr print_integer

	// Print rest of the start up message
	ldx #34
	jmp print_packed_message


#endif // ROM layout
