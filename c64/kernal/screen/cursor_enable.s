#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Variables used:
// - BLNSW (cursor blink switch)
//


cursor_enable:
	lda #$00
	sta BLNSW
	rts


#endif // ROM layout
