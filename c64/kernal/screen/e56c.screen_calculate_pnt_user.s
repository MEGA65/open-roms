#if ROM_LAYOUT_STD || (ROM_LAYOUT_M65 && SEGMENT_KERNAL_0)

//
// Set pointer (PNT) to current screen line , described in:
//
// - [CM64] Computes Mapping the Commodore 64 - page 216
// - http://sta.c64.org/cbm64scrfunc.html
//


screen_calculate_PNT_USER:

	ldx TBLX

	// FALLTROUGH

screen_calculate_PNT_USER_from_X: // entry point for screen_clear_line

	// Reset pointer to start of screen

	lda HIBASE
	sta PNT+1
	lda #$00
	sta PNT+0

	// Add 40 to PNT for every line

	cpx #$00	
	beq screen_calculate_USER
!:
	lda #40
	clc
	adc PNT+0
	sta PNT+0
	bcc !+
	inc PNT+1
!:
	dex
	bne !--

	// FALLTROUGH

screen_calculate_USER:

	// Calculate USER (pointer to the current line in color RAM)

	lda PNT+0
	sta USER+0
	lda PNT+1
	sec
	sbc HIBASE
	clc
	adc #>$d800
	sta USER+1

	rts


#endif // ROM layout
