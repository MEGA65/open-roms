// #LAYOUT# STD *       #TAKE
// #LAYOUT# M65 *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Tokenise a line of BASIC stored at $0200
//
// Input:
// - length in __tokenise_work1
//


tokenise_line:

#if (ROM_LAYOUT_M65 && SEGMENT_BASIC_0)

	jsr     map_BASIC_1
	jsr_ind VB1__tokenise_line
	jmp     map_NORMAL

#else

	// Reuse the CPU stack - addresses above $101 are used by 'tk_pack.s'

	.label tk__offset       = $100               // offset into string
	.label tk__length       = $101               // length of the raw string  XXX reuse __tokenise_work1?

	// Initialize variables

	lda #$00
	sta tk__offset

	ldx __tokenise_work1
	stx tk__length

	// Terminate input string with $00

	// XXX do we need this?
	sta BUF, x

	// FALLTROUGH

tokenise_line_loop:

	// Check if we have reached end of the line

	lda tk__offset
	cmp tk__length
	beq tokenise_line_done

	// Check for some special characters

	ldx tk__offset
	lda BUF, x

	cmp #$22
	beq tokenise_line_quote

	cmp #$DE
	beq tokenise_line_pi

	cmp #$3F
	beq tokenise_line_question_mark              // shortcut for PRINT command

	// Try to tokenise

	jsr tk_pack
!:
	lda tk__len_unpacked
	beq tokenise_line_char                       // branch if attempt to tokenise failed

	lda #<packed_str_keywords_V2
	sta FRESPC+0
	lda #>packed_str_keywords_V2
	sta FRESPC+1

	jsr tk_search
	bcc tokenise_line_keyword_V2                 // branch if keyword identified

	// XXX add support for additional keyword lists here

	// Shorten packed keyword candidate and try again

	jsr tk_shorten

#if HAS_OPCODES_65C02
	bra !-
#else
	jmp !-
#endif

tokenise_line_keyword_V2:

	// .X contains a token ID, starting from 0

	txa
	pha                                          // store the token on the stack, we will need it for REM support

	// Store the token

	ldx tk__offset
	clc
	adc #$80
	sta BUF, x

	// Cut away unnecessary bytes

	inc tk__offset
	ldx tk__offset

	dec tk__len_unpacked                         // keyword length, afterwards number of bytes to cut away
	lda tk__len_unpacked
	clc
	adc tk__offset
	tay
!:
	lda BUF, y
	sta BUF, x
	beq !+

	inx
	iny
	bne !-	
!:
	// Special handling for REM command - after this one nothing more should be tokenised

	pla
	cmp #$0F                                     // REM token index
	bne tokenise_line_loop

	// FALLTROUGH

tokenise_line_done:

	// Update line length and quit

	lda tk__length
	sta __tokenise_work1

	rts

tokenise_line_quote:

	// For the quote, we advance without tokenizing, until the next quote is found

	inc tk__offset
	ldx tk__offset

	lda BUF, x
	beq tokenise_line_done

	cmp #$22
	beq tokenise_line_char
	bne tokenise_line_quote                      // branch always

tokenise_line_pi:

	lda #$FF                                     // token for PI
	skip_2_bytes_trash_nvz

	// FALLTROUGH

tokenise_line_question_mark:

	lda #$99                                     // token for PRINT
	sta BUF, x

	// FALLTROUGH

tokenise_line_char:

	inc tk__offset
	jmp tokenise_line_loop

#endif // ROM layout
