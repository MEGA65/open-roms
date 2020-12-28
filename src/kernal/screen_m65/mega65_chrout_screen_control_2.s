;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


; Escape mode support

m65_chrout_screen_ESC:
	
	lda #$FF
	sta M65_ESCMODE
	bra m65_chrout_screen_ctrl2_end

; Flashing and underline support

m65_chrout_screen_UNDERLINE_ON:

	lda COLOR
	ora #%10000000
	bra m65_chrout_screen_FLAUND_common

m65_chrout_screen_UNDERLINE_OFF:

	lda COLOR
	and #%01111111
	bra m65_chrout_screen_FLAUND_common

m65_chrout_screen_FLASHING_ON:

	lda COLOR
	ora #%00010000
	bra m65_chrout_screen_FLAUND_common

m65_chrout_screen_FLASHING_OFF:

	lda COLOR
	and #%11101111

	; FALLTROUGH

m65_chrout_screen_FLAUND_common:

	sta COLOR
	bra m65_chrout_screen_ctrl2_end

; 'REVERSE' mode support

m65_chrout_screen_RVS_ON:

	lda #$80
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

m65_chrout_screen_RVS_OFF:

	lda #$00
	sta RVS

	; FALLTROUGH

m65_chrout_screen_ctrl2_end:

	jmp m65_chrout_screen_done


; 'SHIFT ON/OFF' support

m65_chrout_screen_SHIFT_ON:

	lda #$00 ; enable SHIFT+VENDOR combination
	+skip_2_bytes_trash_nvz

	; FALLTROUGH

m65_chrout_screen_SHIFT_OFF:

	lda #$80 ; disable SHIFT+VENDOR combination

	sta MODE
	bra m65_chrout_screen_ctrl2_end


; STOP key support

m65_chrout_screen_STOP:

	lda #$00
	sta QTSW
	sta INSRT
	bra m65_chrout_screen_ctrl2_end

; CLR/HOME key support

m65_chrout_screen_CLR:

	jsr M65_CLRWIN
	bra m65_chrout_screen_ctrl2_end

m65_chrout_screen_HOME:

	jsr M65_HOME
	bra m65_chrout_screen_ctrl2_end

; Character set switching

m65_chrout_screen_TXT:
	
	lda VIC_CHARPTR+1
	ora #%00001000

	; FALLTROUGH

m65_chrout_screen_GFXTXT_cont:

	sta VIC_CHARPTR+1
	bra m65_chrout_screen_ctrl2_end

m65_chrout_screen_GFX:

	lda VIC_CHARPTR+1
	and #%11110111
	bra m65_chrout_screen_GFXTXT_cont

; INS key

m65_chrout_screen_INS:

	; First prepare the pointer to the current row

	jsr m65_helper_scrlpnt_color
	jsr m65_helper_scrlpnt_to_screen

	; Check for windowed mode

	lda M65_SCRWINMODE
	+bmi m65_chrout_screen_INS_winmode

	; Check if last character of the line is space

	ldy M65_SCRMODE
	lda m65_scrtab_txtwidth,y
	dec
	taz
	lda [M65_LPNT_SCR], z
	cmp #$20
	+bne m65_chrout_screen_ctrl2_end
	phz

	; Last character is space - move the characters

	jsr m65_chrout_screen_INS_copy

	; Store space in the current character cell

	lda #$20
	sta [M65_LPNT_SCR], z

	; Move the color memory

	jsr m65_helper_scrlpnt_color
	plz
	jsr m65_chrout_screen_INS_copy

	; Store current colour in the current character cell

	lda COLOR
	and #$0F
	sta [M65_LPNT_SCR], z

	; Increase insert mode count (which causes quote-mode like behaviour) and quit

	inc INSRT
	bra m65_chrout_screen_ctrl2_end

m65_chrout_screen_INS_winmode:

	; Check if last character of the line within window is space

	; XXX provide implementation

	bra m65_chrout_screen_ctrl2_end

m65_chrout_screen_INS_copy:

	dez
	lda [M65_LPNT_SCR], z
	inz
	sta [M65_LPNT_SCR], z
	dez
	cpz M65__TXTCOL
	bne m65_chrout_screen_INS_copy

	rts

; Bell (jingle)

m65_chrout_screen_BELL:

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

	lda #$0A                           ; volume
	sta SID_SIGVOL + $20
	sta SID_SIGVOL + $60

	lda #$23                           ; channel 1 - attack/decay
	sta SID_ATDCY1 + $20
	sta SID_ATDCY1 + $60

	lda #$52                           ; channel 1 - sustain/release
	sta SID_SUREL1 + $20
	sta SID_SUREL1 + $60

	lda #$1E                           ; channel 1 - frequency (HI)
	sta SID_FREHI1 + $20
	sta SID_FREHI1 + $60

	lda #$00                           ; channel 1 - frequency (LO)
	sta SID_FRELO1 + $20
	sta SID_FRELO1 + $60

	lda #$11                           ; channel 1 - waveform
	sta SID_VCREG1 + $20
	sta SID_VCREG1 + $60

	ldx #$0E                           ; wait loop
@2:
	phx
	ldx #$FF
	jsr wait_x_bars
	plx
	dex
	bne @2

	lda #$10                           ; stop the jingle
	sta SID_VCREG1 + $20
	sta SID_VCREG1 + $60

	; FALLTROUGH

m65_chrout_screen_BELL_done:

	jmp m65_chrout_screen_done
