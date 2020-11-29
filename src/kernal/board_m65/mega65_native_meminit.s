;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_native_meminit:

	; Initialize variables for keyboard scanning

	jsr m65_scnkey_init_pressed

	; Prepare generic DMAgic list

	jsr m65_dmagic_init

	;
	; Copy MEGA65 charset to target location - set size
	;

	lda #$00
	sta M65_DMAJOB_SIZE_0
	lda #$10
	sta M65_DMAJOB_SIZE_1

	; Set destination

	lda #$00
	sta M65_DMAJOB_DST_3
	lda #$01
	sta M65_DMAJOB_DST_2
	lda #>MEMCONF_CHRBASE
	sta M65_DMAJOB_DST_1
	lda #<MEMCONF_CHRBASE
	sta M65_DMAJOB_DST_0

	; Set source

	lda #$00
	sta M65_DMAJOB_SRC_3
	lda #$02
	sta M65_DMAJOB_SRC_2
	lda #$90
	sta M65_DMAJOB_SRC_1
	lda #$00
	sta M65_DMAJOB_SRC_0

	; Launch the DMA job

	jmp m65_dmagic_oper_copy
