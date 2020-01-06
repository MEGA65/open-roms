

screen_preserve_sal_eal:

	plx_trash_a
	ply_trash_a

	lda SAL+0
	pha
	lda SAL+1
	pha	
	lda EAL+0
	pha
	lda EAL+1
	pha

	// FALLTROUGH

screen_common_sal_eal:

	phy_trash_a
	phx_trash_a
	rts
