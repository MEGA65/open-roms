;; #LAYOUT# M65 KERNAL_1 #TAKE
;; #LAYOUT# *   *        #IGNORE


m65_native_meminit:

	; Clear pages 4-7

	lda #$00
	tax
@1:
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	inx
	bne @1

	; Initialize variables for keyboard scanning

	jsr m65_scnkey_init_pressed

	lda VIC_CTRLA
	pha
	ora #%00100000
	sta VIC_CTRLA

	jsr (VKC__m65_scnkey_init_keylog)

	pla
	sta VIC_CTRLA

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
