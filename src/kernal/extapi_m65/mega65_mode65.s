// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


M65_MODE65:

	// Disable interrupts, they might interfere

	sei

	// Switch CPU speed to fast

	jsr M65_FAST

	// Set the magic string to mark native mode

	lda #$4D // 'M'
	sta M65_MAGICSTR+0
	lda #$36 // '6'
	sta M65_MAGICSTR+1
	lda #$35 // '5'
	sta M65_MAGICSTR+2

	// Initialize VIC-IV

	jsr viciv_init

	// Set screen mode to 80x50

	lda #$02
	jsr m65_scrmodeset_internal

	// Clear the screen

	jmp M65_CLRSCR
