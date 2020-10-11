;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; DolphinDOS protocol support for IEC - optimized load loop
;


!ifdef CONFIG_IEC_DOLPHINDOS { !ifndef CONFIG_MEMORY_MODEL_60K {


dolphindos_load:

	; Timing is critical for some parts, do not allow interrupts
	sei

	; A trick to shorten EAL update time
	ldy #$00

!ifdef CONFIG_IEC_DOLPHINDOS_FAST {

	; Another trick: prepare values for quickly setting/releasing DATA
	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT - BIT_CIA2_PRA_CLK_OUT - BIT_CIA2_PRA_ATN_OUT
	sta IECPROTO                       ; release DATA
	ora #BIT_CIA2_PRA_DAT_OUT
	sta TBTCNT                         ; pull DATA
}

!ifdef CONFIG_MB_M65 {
	; If in native mode, switch to 1 MHz
	jsr m65_iec_slow
}
	; FALLTROUGH

dolphindos_load_loop:

!ifndef CONFIG_IEC_DOLPHINDOS_FAST {
	; Check if this was EOI
	bit IOSTATUS
	bvs dolphindos_load_end
}

	; Wait for the talker to release the CLK line
@1:
	bit CIA2_PRA
	bvc @1

	; Release the DATA to signal we are ready
!ifndef CONFIG_IEC_DOLPHINDOS_FAST {
	lda CIA2_PRA
	and #$FF - BIT_CIA2_PRA_DAT_OUT    ; release
} else {
	lda IECPROTO
}
	sta CIA2_PRA

!ifndef CONFIG_IEC_DOLPHINDOS_FAST {

	; Check if EOI
	jsr iec_rx_check_eoi               ; can damage .X, but this is safe

} else {

	; Check if EOI - inlined code to avoid wasting cycles on RTS
	ldx #$13
@2:
	bit CIA2_PRA
	bvc dolphindos_load_no_eoi
	dex
    bne @2

    ; EOI - mark it and retrieve the last byte
    jsr iec_rx_check_eoi_confirm
	lda CIA2_PRB
	sta (EAL),y

	; Update EAL for the last time
	sec
	jsr iec_update_EAL_by_Y

	; Restore proper IECPROTO value
	lda #IEC_DOLPHIN
	sta IECPROTO

	; End of load loop
	+bra load_iec_loop_end

dolphindos_load_no_eoi:

}

	; Retrieve and store byte
	lda CIA2_PRB
	sta (EAL),y

	; Pull DATA to acknowledge
!ifndef CONFIG_IEC_DOLPHINDOS_FAST {
	lda CIA2_PRA
	ora #BIT_CIA2_PRA_DAT_OUT
} else {
	lda TBTCNT
}
	sta CIA2_PRA

	; Handle EAL
	iny
	bne dolphindos_load_loop
	inc EAL+1
	+bra dolphindos_load_loop

!ifndef CONFIG_IEC_DOLPHINDOS_FAST {

dolphindos_load_end:

!ifdef CONFIG_MB_M65 {
	; If in native mode, switch back to fast mode
	jsr m65_iec_fast
}
	; Update EAL
	clc
	jsr iec_update_EAL_by_Y

	; End of load loop
	jmp load_iec_loop_end
}


} } ; CONFIG_IEC_DOLPHINDOS and not CONFIG_MEMORY_MODEL_60K
