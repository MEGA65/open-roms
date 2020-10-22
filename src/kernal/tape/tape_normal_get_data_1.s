;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_1 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape (normal) helper routine - data block (primary) reading
;
; Stores data starting from MEMUSS, Carry set means error, on 0 bit .A is 0 too
; .Y not equal to 0 - returns error if data block is longer (length includes checksum)


!ifdef CONFIG_TAPE_NORMAL {


tape_normal_get_data_1:

	; Initialize checksum (RIPRTY, see http://sta.c64.org/cbm64mem.html)
	; and pointers for error log and correction mechanism
	lda #$00
	sta RIPRTY

	sta PTR2
	sta PTR1

	; FALLTROUGH

tape_normal_get_data_1_block:

	;
	; Read the 1st copy of the block
	;

	; Read sync of the block
	ldy #$89
	jsr tape_normal_sync
	bcs tape_normal_get_data_1_fail
	jsr tape_normal_get_marker

tape_normal_get_data_1_loop:

	jsr tape_normal_get_byte
	bcc tape_normal_get_data_1_loop_byte_OK

	; Problem reading a byte, try to add it to the error log

	tsx
	cpx #$20                           ; just to be on a safe side
	bcc tape_normal_get_data_1_fail    ; branch if no more space in error log

	ldx PTR1
	lda MEMUSS+0
	sta STACK, x
	inx
	lda MEMUSS+1
	sta STACK, x
	inx
	stx PTR1 

	; Addres added to error log, check if this was a checksum
	jsr tape_normal_get_marker
	bcc tape_normal_get_data_1_loop_advance
	bcs tape_normal_get_data_1_success

tape_normal_get_data_1_loop_byte_OK:

	jsr tape_normal_get_marker
	bcc @1

	; End of the block
	jsr tape_normal_update_checksum
	jmp tape_normal_get_data_1_success

@1:
	; Store byte, calculate checksum
	lda INBIT
	ldy #$00
!ifdef CONFIG_MB_M65 {
	jsr tape_normal_byte_store
} else {
	sta (MEMUSS), y
}
	jsr tape_normal_update_checksum
	
	; FALLTROUGH

tape_normal_get_data_1_loop_advance:

	; Advance pointer
!ifndef HAS_OPCODES_65CE02 {
	jsr lvs_advance_MEMUSS
} else {
	inw MEMUSS+0
}

	jmp tape_normal_get_data_1_loop


tape_normal_get_data_1_success:

	clc
	rts

tape_normal_get_data_1_fail:

	sec
	rts
}
