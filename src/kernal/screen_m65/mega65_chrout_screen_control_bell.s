;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_chrout_screen_BELL:                ; play bell (jingle)

	lda M65_BELLDSBL
	bmi m65_chrout_screen_BELL_done

	; Play bell on both left&right secondary SIDs - first reset the SIDs

	ldx #$1F
	lda #$00
@1:
	sta __SID_BASE + $20,x
	sta __SID_BASE + $60,x
	dex
	bpl @1

	; Set jingle parameters

	lda #$0A                           ; volume
	sta SID_SIGVOL + $20
	sta SID_SIGVOL + $60

	ldx #$04                           ; wait loop, to prevent popping sound
	jsr m65_chrout_screen_BELL_wait

	lda #$1D                           ; channel 1 - attack/decay
	sta SID_ATDCY1 + $20
	sta SID_ATDCY1 + $60

	lda #$06                           ; channel 1 - sustain/release
	sta SID_SUREL1 + $20
	sta SID_SUREL1 + $60

	lda #$21                           ; channel 1 - frequency (HI)
	sta SID_FREHI1 + $20
	sta SID_FREHI1 + $60

	lda #$00                           ; channel 1 - frequency (LO)
	sta SID_FRELO1 + $20
	sta SID_FRELO1 + $60

	; Play jingle

	lda #$11                           ; channel 1 - waveform (triangle)
	sta SID_VCREG1 + $20
	sta SID_VCREG1 + $60

	ldx #$08                           ; wait loop
	jsr m65_chrout_screen_BELL_wait
	
	lda #$10
	sta SID_VCREG1 + $20
	sta SID_VCREG1 + $60

	ldx #$04                           ; wait loop before clear, to prevent popping sound
	jsr m65_chrout_screen_BELL_wait

	; FALLTROUGH

m65_chrout_screen_BELL_done:

	jmp m65_chrout_screen_done

m65_chrout_screen_BELL_wait:           ; XXX this can probably be deduplicated

	phx
	ldx #$FF
	jsr wait_x_bars
	plx
	dex
	bne m65_chrout_screen_BELL_wait
	rts

m65_chrout_esc_G:                      ; enable bell

	lda #$00
	+skip_2_bytes_trash_nvz
	
	; FALLTROUGH

m65_chrout_esc_H:                      ; disable bell
	
	lda #$FF
	sta M65_BELLDSBL
	bra m65_chrout_screen_BELL_done
