// #LAYOUT# M65 KERNAL_1 #TAKE
// #LAYOUT# *   *        #IGNORE

// Helper routines for DMAgic usage

// See:
// - https://c65gs.blogspot.com/2019/03/auto-detecting-required-revision-of.html
// - https://c65gs.blogspot.com/2018/01/improving-dmagic-controller-interface.html


// XXX: finish the implementation, use in screen editor


m65_dmagic_oper_fill:

	// To configure job parameters, use:
	// - M65_DMAJOB_SIZE_*
	// - M65_DMAJOB_DST_*
	// - .A - byte for filling
	// Afterwards, consider M65_DMAJOB_*_2 and M65_DMAJOB_*_3 destroyed.

	// Set fill address
	
	sta M65_DMAJOB_SRC_0

	// Set operation type

	lda #$03                           // operation: FILL
	sta M65_DMAGIC_LIST+6

	// Go to common part

	jmp_8 m65_dmagic_common

m65_dmagic_oper_copy:

	// To configure job parameters, use:
	// - M65_DMAJOB_SIZE_*
	// - M65_DMAJOB_SRC_*
	// - M65_DMAJOB_DST_*
	// Afterwards, consider M65_DMAJOB_DST_2 and M65_DMAJOB_DST_3 destroyed.

	// Set operation type

	lda #$00                           // operation: COPY
	sta M65_DMAGIC_LIST+6

	// Adapt the source addresses, go to common part

	jsr m65_dmagic_adapt_src

	// FALLTROUGH

m65_dmagic_common:

	// Adapt destination addresses - this is always needed
	// XXX consider inlining this here

	jsr m65_dmagic_adapt_dst

	// Set remaining job parameters

	lda #$0A
	sta M65_DMAGIC_LIST+0              // <- $0A = use F018A list format (it is shorter by 1 byte)
	lda #$80
	sta M65_DMAGIC_LIST+1              // <- $80 = next byte is highest 8 bits of source address
	inc_a
	sta M65_DMAGIC_LIST+3              // <- $81 = next byte is highest 8 bits of destination address

	lda #$00
	sta M65_DMAGIC_LIST+5              // <- end of options

	sta M65_DMAGIC_LIST+15             // <- set modulo to 0
	sta M65_DMAGIC_LIST+16

	// FALLTROUGH

m65_dmagic_launch:

	// Launch the DMA list

	lda #$00
	sta DMA_ADDRBANK                   // $D702
	sta DMA_ADDRMB                     // $D704

	lda #>M65_DMAGIC_LIST
	sta DMA_ADDRMSB                    // $D701
	lda #<M65_DMAGIC_LIST
	sta DMA_ETRIG                      // $D705

	rts


m65_dmagic_adapt_src:

	// We need to adapt the addresses:
	// - M65_DMAJOB_SRC_2 - contain bits 16-23, should contain 16-19
	// - M65_DMAJOB_SRC_3 - contain bits 24-27, should contain 20-27

	lda M65_DMAJOB_SRC_2
	pha

	asl
	ror M65_DMAJOB_SRC_3 
	asl
	ror M65_DMAJOB_SRC_3
	asl
	ror M65_DMAJOB_SRC_3
	asl
	ror M65_DMAJOB_SRC_3

	pla
	and %00001111
	sta M65_DMAJOB_SRC_2

	rts


m65_dmagic_adapt_dst:

	// We need to adapt the addresses:
	// - M65_DMAJOB_DST_2 - contain bits 16-23, should contain 16-19
	// - M65_DMAJOB_DST_3 - contain bits 24-27, should contain 20-27

	lda M65_DMAJOB_DST_2
	pha

	asl
	ror M65_DMAJOB_DST_3 
	asl
	ror M65_DMAJOB_DST_3
	asl
	ror M65_DMAJOB_DST_3
	asl
	ror M65_DMAJOB_DST_3

	pla
	and %00001111
	sta M65_DMAJOB_DST_2

	rts
