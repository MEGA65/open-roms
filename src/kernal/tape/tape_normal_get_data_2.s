;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# CRT KERNAL_0 #TAKE
;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; Tape (normal) helper routine - data block (backup) reading
;


!ifdef CONFIG_TAPE_NORMAL {


tape_normal_get_data_2:

	; NOTE: Always read all the bytes fro second copy, to taht we stop
	;       at the moment when it is safe to start recording!

	; Read sync of the block
	
	ldy #$09
	jsr tape_normal_sync
	bcs tape_normal_get_data_2_done              ; Carry already set, will indicate error
	jsr tape_normal_get_marker

	; FALLTROUGH

tape_normal_get_data_2_loop:

	; Read missing bytes

	jsr tape_normal_get_byte
	bcc tape_normal_get_data_2_loop_byte_OK

	; Problem reading a byte - just skip it

	bcs tape_normal_get_data_2_loop_advance

tape_normal_get_data_2_loop_byte_OK:

	jsr load_cmp_log_MEMUSS
	beq tape_normal_get_data_2_loop_from_log     ; branch if byte from the log

	jsr tape_normal_get_marker
	bcs tape_normal_get_data_2_log_checksum      ; branch if end of blocks
	bcc tape_normal_get_data_2_loop_advance


tape_normal_get_data_2_loop_from_log:

	; This is a byte from the log

	jsr tape_normal_get_marker
	bcs @1

	lda INBIT
	ldy #$00
!ifdef CONFIG_MB_M65 {
	jsr tape_normal_byte_store
} else {
	sta (MEMUSS), y
}
@1:
	jsr tape_normal_update_checksum

	; FALLTROUGH

tape_normal_get_data_2_loop_advance:

	; Advance pointer
!ifndef HAS_OPCODES_65CE02 {
	jsr lvs_advance_MEMUSS
} else {
	inw MEMUSS+0
}

	jmp tape_normal_get_data_2_loop


tape_normal_get_data_2_log_checksum:

	lda PTR1
	cmp PTR2
	bne tape_normal_get_data_2_done              ; Carry already set

	; Validate checksum

	lda RIPRTY
	cmp #$01                                     ; sets Carry if checksum verification fails

	; FALLTROUGH

tape_normal_get_data_2_done:

	rts


load_cmp_log_MEMUSS:

	ldx PTR2
	lda STACK+0, x
	cmp MEMUSS+0
	bne @2

	lda STACK+1, x
	cmp MEMUSS+1
	bne @2

	; MEMUSS matches address from the log

	inc PTR2
	inc PTR2
	lda #$00                                     ; to set Zero flag
@2:
	rts
}
