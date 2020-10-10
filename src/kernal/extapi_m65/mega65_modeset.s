;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


M65_MODESET:

	; Carry clear = set native mode; Carry set = set legacy mode 

	bcc m65_mode65

	; FALLTROUGH

m65_mode64:

	; Disable interrupts, they might interfere

	sei

	; Set the magic string to mark legacy mode

	jsr m65_clr_magictstr

	; Restore VIC-II configuration

	jsr viciv_shutdown
	jsr vicii_init

	; Switch CPU speed back to normal

	lda #$40
	sta CPU_D6510

	; Reenable interrupts and quit

	cli
	rts


m65_mode65:

	; Disable interrupts, they might interfere

	sei

	; Switch CPU speed to fast

	lda #$41
	sta CPU_D6510

	; Set the magic string to mark native mode

	lda #$4D ; 'M'
	sta M65_MAGICSTR+0
	lda #$36 ; '6'
	sta M65_MAGICSTR+1
	lda #$35 ; '5'
	sta M65_MAGICSTR+2

	; Initialize VIC-IV

	jsr vicii_init
	jsr viciv_init

	; Initialize various memory structures

	jsr m65_native_meminit

	; Set screen mode to 80x50

	lda #$02
	jsr m65_scrmodeset_internal

	; Clear the screen

	jmp M65_CLRSCR
