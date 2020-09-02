
//
// Names of hardware registers
//
// See https://github.com/MEGA65/mega65-core/blob/master/iomap.txt
//


#if CONFIG_MB_MEGA_65

	// VIC-IV registers

	.label VIC_KEY         = $D02F
	.label VIC_CTRLA       = $D030
	.label VIC_CTRLB       = $D031

	.label VIC_XPOS        = $D050

	.label VIC_CTRLC       = $D054

	.label VIC_CHARSTEP    = $D058 // 2 bytes  - logical characters per line

	.label VIC_SRH         = $D05D //          - various flags, bit 7 = hot registers

	.label VIC_SCRNPTR     = $D060 // 4 bytes  - pointer to start of screen memory
	.label VIC_COLPTR      = $D064 // 2 bytes  - pointer to start of color memory

	.label VIC_CHARPTR     = $D068 // 3 bytes  - pointer to start of character generator

	// DMAgic

	.label DMA_ADDRLSBTRIG = $D700
	.label DMA_ADDRMSB     = $D701
	.label DMA_ADDRBANK    = $D702
	.label DMA_EN018B      = $D703
	.label DMA_ADDRMB      = $D704
	.label DMA_ETRIG       = $D705
	.label DMA_ADDRLSB     = $D70E

	// MISC registers

	.label MISC_BOARDID    = $D629 // board identification byte
	.label MISC_EMU        = $D710 // to enable badlines and slow interrupts

#endif
