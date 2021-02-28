;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; JiffyDOS protocol support for IEC - optimized load loop
;

!ifdef CONFIG_IEC_JIFFYDOS { !ifndef CONFIG_MEMORY_MODEL_60K {


; Note: original JiffyDOS LOAD loop checks for RUN/STOP key every time a sector is read,
; see description at https://sites.google.com/site/h2obsession/CBM/C128/JiffySoft128
;
; For simplicity and some space savings, our routine does not check the RUN/STOP key at all;
; the protocol is fast enough (especially with modern flash mediums) that probably nobody
; will want to terminate the loading.


jiffydos_load:


!ifdef CONFIG_IEC_JD_TEST {

	; XXX test implementation, not ready yet

	; Switch to optimized LOAD protocol
	jsr UNTLK
	lda FA
	jsr TALK
	bcs jiffydos_load_error

	lda #$01
	sta CIA2_DDRB ; XXX for test only

	lda #$61
	jsr TKSA

	lda #$02
	sta CIA2_DDRB ; XXX for test only

	; XXX flow below most likely takes too much time...

	; Timing is critical, do not allow interrupts
	sei

!ifdef CONFIG_IEC_JIFFYDOS_BLANK {

!ifdef CONFIG_MB_U64 {

	; XXX implement for non-blank mode, use jiffydos_prepare_no_preserve_bits

	; Check if turbo register is available
	lda U64_TURBOCTL
	cmp #$FF
	beq @1

	; Store turbo register content, disable badlines
	sta TBTCNT
	lda #$80
	sta U64_TURBOCTL
	bne @2

	; Normal flow - no turbo register
}

@1:
	; Preserve register with screen status (blank/visible)
	lda VIC_SCROLY
	sta TBTCNT

	; Blank screen to make sure no sprite/badline will interrupt
	jsr screen_off
@2:
	; Preserve 3 lowest bits of CIA2_PRA
	jsr jiffydos_preserve_bits

} else {

@1:
	; Store previous sprite status in temporary variable
	jsr jiffydos_prepare
	sta TBTCNT
@2:

}
	; A trick to shorten EAL update time
	ldy #$FF

	; FALLTROUGH

jiffydos_load_loop_esc:

	; We are now in 'escape mode' - release DATA, wait till receiver releases CLK
	jsr iec_release_clk_data
	jsr iec_wait_for_clk_release

	; Check DATA line
	bmi jiffydos_load_check_status

	+panic $01

	; XXX finish the implementation




jiffydos_load_check_status:

	; Check if a device pulls CLK within the next 1100us (at least 1125 cycles, to be sure for NTSC)
	ldx #$67                         ; 2 cycles

	; FALLTROUGH

jiffydos_load_check_loop:

	lda CIA2_PRA                     ; 4 cycles
	bvc jiffydos_load_end            ; 2 cycles if not taken
	dex                              ; 2 cycles
	bne jiffydos_load_check_loop     ; 3 cycles if taken

	; FALLTROUGH

jiffydos_load_error:
	
	lda #$F3
	sta CIA2_DDRB ; XXX for test only

	+panic $03

	; XXX finish the implementation


jiffydos_load_end:

	+panic $FF

	; XXX finish the implementation



} else {

	; XXX implement JiffyDOS optimized LOAD protocol, this one is ineffective


	; Timing is critical, do not allow interrupts
	sei

!ifdef CONFIG_IEC_JIFFYDOS_BLANK {

!ifdef CONFIG_MB_U64 {

	; XXX implement for non-blank mode, use jiffydos_prepare_no_preserve_bits

	; Check if turbo register is available
	lda U64_TURBOCTL
	cmp #$FF
	beq @1

	; Store turbo register content, disable badlines
	sta TBTCNT
	lda #$80
	sta U64_TURBOCTL
	bne @2

	; Normal flow - no turbo register
}

@1:
	; Preserve register with screen status (blank/visible)
	lda VIC_SCROLY
	sta TBTCNT

	; Blank screen to make sure no sprite/badline will interrupt
	jsr screen_off
@2:
	; Preserve 3 lowest bits of CIA2_PRA
	jsr jiffydos_preserve_bits

} else {

@1:
	; Store previous sprite status in temporary variable
	jsr jiffydos_prepare
	sta TBTCNT
@2:

}
	; A trick to shorten EAL update time
	ldy #$FF

!ifdef CONFIG_MB_M65 {
	; Ensure 1 Mhz mode and disabled badlines
	jsr m65_speed_iec
}
	; FALLTROUGH

jiffydos_load_loop:

	; Wait until device is ready to send (releases CLK)
	jsr iec_wait_for_clk_release

	; Prepare 'start sending' message
	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    ; release

!ifdef CONFIG_IEC_JIFFYDOS_BLANK {

	; It seems JiffyDOS needs some time here; waste few cycles
	+nop
	jsr iec_wait_rts

	; Ask device to start sending bits
	sta CIA2_PRA

} else {

	; Wait for appropriate moment, ask device to start sending bits
	tax
	jsr jiffydos_wait_line
	stx CIA2_PRA                       ; cycles: 4
}

	; Prepare 'data pull' byte, cycles: 3 + 2 + 2 = 7
	lda C3PO
	ora #BIT_CIA2_PRA_DAT_OUT          ; pull
	tax

	; Delay, JiffyDOS needs some time, 4 cycles
	+nop
	+nop

	; Get bits, cycles: 4 + 2 + 2 = 8
	lda CIA2_PRA                       ; bits 0 and 1 on CLK/DATA
	lsr
	lsr

	; Delay, JiffyDOS needs some time, 2 cycles
	+nop

	; Get bits, cycles: 4 + 2 + 2 = 8
	ora CIA2_PRA                       ; bits 2 and 3 on CLK/DATA
	lsr
	lsr

	; Get bits, cycles: 3 + 4 + 2 + 2 = 11
	eor C3PO
	eor CIA2_PRA                       ; bits 4 and 5 on CLK/DATA
	lsr
	lsr

	; Get bits, cycles: 3 + 4 = 7
	eor C3PO
	eor CIA2_PRA                       ; bits 6 and 7 on CLK/DATA

	; Store retrieved byte, cycles: 2 + 6 = 8 
	iny                                ; NTSC needs this delay
	sta (EAL),y                        ; not compatible with CONFIG_MEMORY_MODEL_60K

	; Retrieve status bits, cycles: 4
	bit CIA2_PRA

	; Pull DATA at the end, cycles: 4
	stx CIA2_PRA

	; If CLK line not active - this was the last byte
	bvs jiffydos_load_end

	; Handle EAL
	cpy #$FF
	bne jiffydos_load_loop
	inc EAL+1
	+bra jiffydos_load_loop

jiffydos_load_end:

!ifdef CONFIG_MB_M65 {
	; Restore the proper speed
	jsr m65_speed_restore
}
	; Save last byte
	tax

	; Update EAL
	sec
	jsr iec_update_EAL_by_Y

	; Indicate that no byte waits in output buffer
	lda #$00
	sta C3PO

	; Restore proper IECPROTO value
	lda #IEC_JIFFY
	sta IECPROTO

!ifdef CONFIG_IEC_JIFFYDOS_BLANK {

!ifdef CONFIG_MB_U64 {

	; Check if turbo register is available
	lda U64_TURBOCTL
	cmp #$FF
	beq @3

	; Restore turbo register content
	lda TBTCNT
	sta U64_TURBOCTL
	jmp @4

	; Normal flow - no turbo register
}

@3:
	; Restore screen state
	lda TBTCNT
	sta VIC_SCROLY
@4:

} else {

@3:
	; Re-enable sprites
	lda TBTCNT
	sta VIC_SPENA
@4:
}

	; Store last byte as unoptimized LOAD routine would
	stx TBTCNT

	; No need to re-enable interrupts; other IEC routines
	; called by LOAD will do this nevertheless

	; End of load loop
	jmp load_iec_loop_end


} } ; CONFIG_IEC_JIFFYDOS and not CONFIG_MEMORY_MODEL_60K

}