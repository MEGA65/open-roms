// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE


M65_MODESET:

	// Carry clear = set native mode; Carry set = set legacy mode 

	bcc m65_mode65

	// FALLTROUGH

m65_mode64:

	// Disable interrupts, they might interfere

	sei

	// Set the magic string to mark legacy mode

	lda #$00
	sta M65_MAGICSTR+0
	sta M65_MAGICSTR+1
	sta M65_MAGICSTR+2

	// Restore VIC-II configuration

	jsr viciv_shutdown
	jsr vicii_init

	// Reenable interrupts

	cli

	// Switch CPU speed back to slow and quit

	jmp M65_SLOW


m65_mode65:

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

	jsr vicii_init
	jsr viciv_init

	// Set screen mode to 80x50

	lda #$02
	jsr m65_scrmodeset_internal

	// Clear the screen

	jmp M65_CLRSCR
