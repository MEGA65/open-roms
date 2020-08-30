// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

// Helper routines for DMAgic usage

// See:
// - https://c65gs.blogspot.com/2019/03/auto-detecting-required-revision-of.html
// - https://c65gs.blogspot.com/2018/01/improving-dmagic-controller-interface.html


// XXX: finish the implementation, use in screen editor


/*
	// XXX implementation is wrong - this example seems to work, copies 32 bytes from $19000 to $19001

	// Prepare list

	lda #$0A                        // format F018A
	sta M65_DMAGIC_LIST + 0

	lda #$80                        // src MB code
	sta M65_DMAGIC_LIST + 1
	lda #$00                        // src address - bits 20-27
	sta M65_DMAGIC_LIST + 2

	lda #$81                        // dst MB code
	sta M65_DMAGIC_LIST + 3
	lda #$00                        // dst address - bits 20-27
	sta M65_DMAGIC_LIST + 4

	lda #$00                        // end of options
	sta M65_DMAGIC_LIST + 5

	lda #$00                        // COPY, not a chained request
    sta M65_DMAGIC_LIST + 6

	lda #$20                        // copy $0020 bytes
    sta M65_DMAGIC_LIST + 7
	lda #$00
    sta M65_DMAGIC_LIST + 8 

	lda #$00                        // src address is $xxx9000 (setting bits 0-15)
    sta M65_DMAGIC_LIST + 9
	lda #$90
    sta M65_DMAGIC_LIST + 10 
	lda #$01                        // src address - bits 16-19
    sta M65_DMAGIC_LIST + 11

	lda #$01                        // dst address is $xxx9001 (setting bits 0-15)
    sta M65_DMAGIC_LIST + 12
	lda #$90
    sta M65_DMAGIC_LIST + 13 
	lda #$01                        // dst address - bits 16-19
    sta M65_DMAGIC_LIST + 14

	lda #$00                        // 'modulo' value is $0000
    sta M65_DMAGIC_LIST + 15
    sta M65_DMAGIC_LIST + 16

    // Launch the DMAgic list

	lda #$00                        // DMA list location - bits 16-19                       
	sta $D702

	lda #$00                        // DMA list location - bits 20-27                    
	sta $D704

	lda #>M65_DMAGIC_LIST
	sta $D701
	lda #<M65_DMAGIC_LIST
	sta $D705                       // should launch the DMA list
*/




m65_dmagic_oper_copy:

	// To configure parameters, use:
	// - M65_DMAJOB_SIZE_*
	// - M65_DMAJOB_SRC_*
	// - M65_DMAJOB_DST_*	

	lda #$00
	sta M65_DMAGIC_LIST+6              // operation: copy

	jmp_8 m65_dmagic_common

m65_dmagic_oper_fill:

	// XXX provide implementation

	// FALLTROUGH

m65_dmagic_common:

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
