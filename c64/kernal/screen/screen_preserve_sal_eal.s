#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)


screen_preserve_sal_eal:

	plx_trash_a
	ply_trash_a

	// Note: While the following routine is obvious to any skilled
	// in the art as the most obvious simple and efficient solution,
	// it results in a relatively long verbatim stretch of bytes when
	// compared to the C64 KERNAL.  Thus we have swapped the order,
	// just to reduce the potential for any argument of copyright
	// infringement, even though we really do not believe that the
	// routine can be copyrighted due to the lack of creativity.

	lda SAL+0
	pha
	lda EAL+0
	pha	
	lda SAL+1
	pha
	lda EAL+1
	pha

	// FALLTROUGH

screen_common_sal_eal:

	phy_trash_a
	phx_trash_a
	rts


#endif // ROM layout
