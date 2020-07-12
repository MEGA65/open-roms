// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 BASIC_1 #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// For direct mode, asks the user if he is sure (sets Carry if not);
// otherwise returns with Carry clear
//


helper_ask_if_sure:

#if (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

	jsr     map_BASIC_1
	jsr_ind VB1__helper_ask_if_sure
	jmp     map_NORMAL

#else

	// First check, if we are in direct mode,; if not, do not ask

	ldx CURLIN+1
	inx
	bne helper_ask_if_sure_ok                    // branch if not direct mode

	// Not direct mode - display the question

	ldx #IDX__STR_IF_SURE
	jsr print_packed_misc_str

	// Clear the keyboard queue

	lda #$00
	sta NDX

	// Enable cursor, fetch the answer

	lda #$00
	sta BLNSW
!:
	jsr JGETIN
	cmp #$00
	beq !-

	// Check if 'Y'

	cmp #$59
	beq !+

	lda #$4E                                     // 'N'
	jsr JCHROUT

	sec
	rts
!:
	// Display 'Y' and wait a short moment for a better user experience

	jsr JCHROUT

	clc
	lda TIME+0
	adc #$0C
!:
	cmp TIME+0
	bne !-

	// FALLTROUGH

helper_ask_if_sure_ok:

	clc
	rts


#endif // ROM layout
