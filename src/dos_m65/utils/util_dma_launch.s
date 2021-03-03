
; Launch the DMA list


util_dma_launch_from_hwbuf:

	; Operation from source $FFD6E00 (hardware SD card / floppy buffer)
	; Destination has to be set by the caller

	lda #$FF
	sta DMAJOB_SRC_MB
	lda #$00
	sta DMAJOB_SRC_ADDR+0
	lda #$6E
	sta DMAJOB_SRC_ADDR+1
	lda #$0D
	sta DMAJOB_SRC_ADDR+2

	; FALLTROUGH

util_dma_launch:

	lda #$01
	sta DMA_ADDRBANK                  ; $D702
	dec
	sta DMA_ADDRMB                    ; $D704

	lda #>(DMAJOB_LIST-$8000)
	sta DMA_ADDRMSB                   ; $D701
	lda #<(DMAJOB_LIST-$8000)
	sta DMA_ETRIG                     ; $D705

	rts
