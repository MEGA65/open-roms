
//
// Helper functions for various LOAD/VERIFY/SAVE routine variants (IEC / U64 / etc.)
//


lvs_handle_byte_load_verify:

	ldy VERCKK
	bne lvs_handle_byte_verify

	// As with our BASIC, we want to enable LOADing
	// anywhere in memory, including over the IO space.
	// Thus we have to use a helper routine in low memory
	// to do the memory access

#if CONFIG_MEMORY_MODEL_60K

	// Save byte under ROMs and IO if required
	php
	sei
	ldx #$33
	stx $01
	ldy #0
	sta (EAL),y
	ldx #$37
	stx $01
	plp

#else

	ldy #0
	sta (EAL),y

#endif

	// FALLTROUGH

lvs_handle_byte_load_verify_end:

	clc
	rts


lvs_handle_byte_verify:

#if CONFIG_MEMORY_MODEL_60K

	// Store byte for comparing
	sta TBTCNT

	// Retrieve byte from under ROMs and IO if required
	php
	sei
	ldx #$33
	stx $01
	ldy #0
	lda (EAL),y
	ldx #$37
	stx $01
	plp
	
	// Compare with stored byte
	cmp TBTCNT

#else

	ldy #0
	cmp (EAL),y

#endif

	beq lvs_handle_byte_load_verify_end

	sec
	rts

#if CONFIG_IEC

lvs_advance_STAL:

	// Advance pointer
	inc STAL+0
	bne !+
	inc STAL+1
!:
	rts


lvs_advance_EAL:

	// Advance pointer
	inc EAL+0
	bne !+
	inc EAL+1
!:
	rts

#endif

#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO

lvs_advance_MEMUSS_check_EAL:

	// Advance pointer
	inc MEMUSS+0
	bne !+
	inc MEMUSS+1
!:
	lda MEMUSS+1
	cmp EAL+1
	bne !+
	lda MEMUSS+0
	cmp EAL+0
!:
	rts

#endif

lvs_display_searching_for:

	lda MSGFLG
	bpl lvs_display_end

	ldx #__MSG_KERNAL_SEARCHING_FOR
	jsr print_kernal_message

	ldy #$00
!:
	cpy FNLEN
	beq lvs_display_end

#if CONFIG_MEMORY_MODEL_60K
	ldx #<FNADDR+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (FNADDR),y
#endif

	jsr JCHROUT
	iny
	jmp !-

lvs_display_end:
	rts


lvs_display_loading_verifying:

	// Display LOADING / VERIFYING and start address
	lda MSGFLG
	bpl lvs_display_end

	ldx #__MSG_KERNAL_LOADING
	lda VERCKK
	beq !+
	ldx #__MSG_KERNAL_VERIFYING
!:
	jsr print_kernal_message

	// FALLTHROUGH

lvs_display_start_addr:

	ldx #__MSG_KERNAL_FROM_HEX
	jsr print_kernal_message

#if CONFIG_TAPE_NORMAL || CONFIG_TAPE_TURBO

	lda FA

#if CONFIG_TAPE_NORMAL
	cmp #$01
	beq lvs_display_addr_STAL
#endif
#if CONFIG_TAPE_TURBO
	cmp #$07
	beq lvs_display_addr_STAL
#endif

#endif

	// FALLTROUGH

lvs_display_addr_EAL:

	lda EAL+1
	jsr print_hex_byte
	lda EAL+0
	jmp print_hex_byte

lvs_display_addr_STAL:

	lda STAL+1
	jsr print_hex_byte
	lda STAL+0
	jmp print_hex_byte

lvs_display_done:

	// Display end address
	lda MSGFLG
	bpl lvs_display_end

	ldx #__MSG_KERNAL_TO_HEX
	jsr print_kernal_message
	jmp lvs_display_addr_EAL

lvs_display_saving:

	// Display SAVING and file name
	lda MSGFLG
	bpl lvs_display_end

	ldx #__MSG_KERNAL_SAVING
	jsr print_kernal_message

	ldy #$00
!:	
	cpy FNLEN
	beq !+
	lda (FNADDR), y
	jsr JCHROUT
	iny
	bne !- // jump alwayys 
!:
	jsr print_return
	rts


lvs_error_end:

	sec
	rts

lvs_return_last_address:

	// Return last address - Compute's Mapping the 64 says without the '+1',
	// checked (short test program) on original ROMs that this is really the case
	ldx EAL+0
	ldy EAL+1
	// FALLTHROUGH

lvs_success_end:

	clc
	rts

lvs_device_not_found_error:

	jsr kernalstatus_DEVICE_NOT_FOUND
	jmp kernalerror_DEVICE_NOT_FOUND

lvs_illegal_device_number:

	jsr kernalstatus_DEVICE_NOT_FOUND
	jmp kernalerror_ILLEGAL_DEVICE_NUMBER

lvs_load_verify_error:
	// XXX should we really return BASIC error code here?
	lda VERCKK
	bne lvs_verify_error
	lda #B_ERR_LOAD
	bne lvs_error_end
	// FALLTHROUGH

lvs_verify_error:
	lda #B_ERR_VERIFY
	sec
	rts
