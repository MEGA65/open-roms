;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


; XXX invent something pleasant to hear, afterwards size-optimize the code

m65_chrout_screen_BELL:                ; play bell (jingle)

	lda M65_BELLDSBL
	bmi m65_chrout_screen_BELL_done

	; Play bell on both left&right secondary SIDs - first reset the SIDs

	jsr m65_chrout_screen_BELL_clear

	lda #$0A                           ; volume
	sta SID_SIGVOL + $20
	sta SID_SIGVOL + $60

	ldx #$04                           ; wait loop, to prevent popping sound
	jsr m65_chrout_screen_BELL_wait

	lda #$23                           ; channel 1 - attack/decay
	sta SID_ATDCY1 + $20
	sta SID_ATDCY1 + $60

	lda #$91                           ; channel 1 - sustain/release
	sta SID_SUREL1 + $20
	sta SID_SUREL1 + $60

	lda #$1D                           ; channel 1 - frequency (HI)
	sta SID_FREHI1 + $20
	sta SID_FREHI1 + $60
	lda #$42                           ; channel 3 - frequency (HI)
	sta SID_FREHI3 + $20
	sta SID_FREHI3 + $60

	lda #$00                           ; channel 1 - frequency (LO)
	sta SID_FRELO1 + $20
	sta SID_FRELO1 + $60
	lda #$00                           ; channel 3 - frequency (LO)
	sta SID_FRELO3 + $20
	sta SID_FRELO3 + $60

	lda #$10                           ; channel 3 - waveform (triangle)
	sta SID_VCREG3 + $20
	sta SID_VCREG3 + $60

	lda #$17                           ; channel 1 - waveform (triangle), synchronized, modulated
	sta SID_VCREG1 + $20
	sta SID_VCREG1 + $60

	ldx #$0F                           ; wait loop
	jsr m65_chrout_screen_BELL_wait

	lda #$14                           ; stop the jingle
	sta SID_VCREG1 + $20
	sta SID_VCREG1 + $60

	ldx #$04                           ; wait loop
	jsr m65_chrout_screen_BELL_wait

	; FALLTROUGH

m65_chrout_screen_BELL_done:

	jmp m65_chrout_screen_done

m65_chrout_screen_BELL_wait: ; XXX this can probably be deduplicated

	phx
	ldx #$FF
	jsr wait_x_bars
	plx
	dex
	bne m65_chrout_screen_BELL_wait
	rts

m65_chrout_screen_BELL_clear:

	ldx #$1F
	lda #$00
@1:
	sta __SID_BASE + $20,x
	sta __SID_BASE + $60,x
	dex
	bpl @1
	rts

m65_chrout_esc_G:                      ; enable bell

	lda #$00
	+skip_2_bytes_trash_nvz
	
	; FALLTROUGH

m65_chrout_esc_H:                      ; disable bell
	
	lda #$FF
	sta M65_BELLDSBL
	bra m65_chrout_screen_BELL_done
