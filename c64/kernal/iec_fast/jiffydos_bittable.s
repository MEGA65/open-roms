
//
// Helper table for encoding lower nibble for JiffyDOS,
// values found by observing the actual transfer using
// original ROMs
//

// Similar tables are probably used by nearly all the disk turbo loaders,
// either on the C64 or drive side, soometimes generated in RAM on the fly;
// example disk turbo presented below has a veryy similar table - but the
// values are in reversed order:
// - https://www.pagetable.com/?p=568


#if CONFIG_IEC_JIFFYDOS


jiffydos_bittable:

	.byte $00
	.byte $80    // $10 + $70
	.byte $20
	.byte $A0    // $30 + $70
	.byte $40
	.byte $C0    // $50 + $70
	.byte $60
	.byte $E0    // $70 + $70
	
	.byte $10    // $80 - $70
	.byte $90
	.byte $30    // $A0 - $70
	.byte $B0
	.byte $50    // $C0 - $70
	.byte $D0
	.byte $70    // $E0 - $70
	.byte $F0


#endif // CONFIG_IEC_JIFFYDOS
