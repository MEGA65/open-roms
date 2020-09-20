;; #LAYOUT# STD *        #TAKE
;; #LAYOUT# *   KERNAL_0 #TAKE
;; #LAYOUT# *   *        #IGNORE


!ifdef CONFIG_MEMORY_MODEL_46K_OR_50K {


peek_under_roms_via_MEMUSS:

	; Store current memory mapping, unmap BASIC ROM

	lda CPU_R6510
	pha
	and #$FE
	sta CPU_R6510 

	; Retrieve value from under ROMs

	lda (MEMUSS), y

	; FALLTROUGH

peek_under_roms_finalize:

	; Store value in a safe place

	tax

	; Restore memory mapping

	pla
	sta CPU_R6510

	; Retrieve value and quit

	txa
	rts


peek_under_roms_via_FNADDR:

	; Store current memory mapping, unmap BASIC ROM

	lda CPU_R6510
	pha
	and #$FE
	sta CPU_R6510 

	; Retrieve value from under ROMs

	lda (FNADDR), y

	; Continue using common code

	+bra peek_under_roms_finalize


peek_under_roms_via_EAL:

	; Store current memory mapping, unmap BASIC ROM

	lda CPU_R6510
	pha
	and #$FE
	sta CPU_R6510 

	; Retrieve value from under ROMs

	lda (EAL), y

	; Continue using common code

	+bra peek_under_roms_finalize
}

