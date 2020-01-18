// #LAYOUT# STD *        #TAKE
// #LAYOUT# *   KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// This is a part CINT which initializes screen and keyboard
//
// For more details see:
// - [RG64] C64 Programmers Reference Guide   - page 280
// - [CM64] Computes Mapping the Commodore 64 - page 242
//


cint_screen_keyboard:

	// Setup KEYLOG vector

	lda #<scnkey_set_keytab
	sta KEYLOG+0
	lda #>scnkey_set_keytab
	sta KEYLOG+1

	// Initialise cursor blink flags (Computes Mapping the 64 p215)

	lda #$01
	sta BLNCT
	sta BLNSW

	// Enable cursor repeat - XXX make it configurable

#if CONFIG_KEY_REPEAT_DEFAULT && !CONFIG_KEY_REPEAT_ALWAYS

	lda #$80
	sta RPTFLG

#endif

	// Set keyboard decode vector  (Computes Mapping the 64 p215)

#if CONFIG_LEGACY_SCNKEY

	// Set initial variables for our improved keyboard scan routine
	lda #$FF
	ldx #6
!:	sta BufferOld,x
	dex
	bpl !-
	sta BufferQuantity

	// Set key repeat delay (Computes Mapping the 64 p215)
	// Making some numbers up here: Repeat every ~1/10th sec
	// But require key to be held for ~1/3sec before
	// repeating (Computes Mapping the 64 p58)

	// Not needed for default keyboard scanning code

	ldx #22-2 		// Fudge factor to match speed
	stx DELAY
	
#endif

	// Set current colour for text (Computes Mapping the 64 p215)
	ldx #$01     // default is light blue ($0E), but we use a different one
	stx COLOR

	// Set maximum keyboard buffer size (Computes Mapping the 64 p215)
	ldx #10
	stx XMAX
	
	// Put non-zero value in MODE to enable case switch
	ldx #$00
	stx MODE

	// Fallthrough/jump to screen clear routine (Computes Mapping the 64 p215)

	jmp clear_screen
