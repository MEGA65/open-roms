#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)


init_oldtxt:

	lda TXTTAB+0
	sta OLDTXT+0
	lda TXTTAB+1
	sta OLDTXT+1

	rts


#endif // ROM layout
