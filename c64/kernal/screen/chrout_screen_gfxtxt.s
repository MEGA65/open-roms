#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// GFX/TXT mode switch handling within CHROUT
//


chrout_screen_GFX:

	lda VIC_YMCSB
	and #$02 // to upper case
!:
	sta VIC_YMCSB
	jmp chrout_screen_done

chrout_screen_TXT:

	lda VIC_YMCSB
	ora #$02    // to lower case
	bne !-      // branch always


#endif // ROM layout
