;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE

;
; RS-232 part of the CLOSE routine
;


!ifdef HAS_RS232 {


!ifdef CONFIG_MEMORY_MODEL_60K {
	!error "CONFIG_MEMORY_MODEL_60K is not compatible with RS-232 memory allocation code"
}


close_rs232:

	; First check how many RS-232 channels are currently allocated.
	; If more than one, skip deallocation (other channels still uses the buffer).

	jsr rs232_count_channels
	cpx #$02                           ; set Carry if more than one is open
	bcs close_rs232_end

	; Deallocate buffer

	inc MEMSIZK+1
	inc MEMSIZK+1

	; XXX is this needed? check with original ROM what it actually does

	lda #$00
	sta ROBUF+0
	sta ROBUF+1
	sta RIBUF+0
	sta RIBUF+1

	; FALLTROUGH

close_rs232_end:

	jmp close_remove_from_table


} ; HAS_RS232
