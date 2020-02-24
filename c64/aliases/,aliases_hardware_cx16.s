
//
// Names of hardware registers
//


#if CONFIG_PLATFORM_COMMANDER_X16

	// VERA registers

	.label __VERA_BASE   = $9F20  // base address of the chip

	.label VERA_ADDR_LO  = $9F20
	.label VERA_ADDR_MID = $9F21
	.label VERA_ADDR_HI  = $9F22

	.label VERA_DATA0    = $9F23
	.label VERA_DATA1    = $9F24

	.label VERA_CTRL     = $9F25

	.label VERA_IEN      = $9F26
	.label VERA_ISR      = $9F27

	// VIA #1 registers

	.label __VIA1_BASE  = $9F60  // base address of the chip

	.label VIA1_PRB     = $9F60
	.label VIA1_PRA     = $9F61
	.label VIA1_DDRB    = $9F62
	.label VIA1_DDRA    = $9F63

	.label VIA1_T1C_L   = $9F64
	.label VIA1_T1C_H   = $9F65
	.label VIA1_T1L_L   = $9F66
	.label VIA1_T1L_H   = $9F67
	.label VIA1_T2C_L   = $9F68
	.label VIA1_T2C_H   = $9F69

	.label VIA1_SR      = $9F6A
	.label VIA1_ACR     = $9F6B
	.label VIA1_PCR     = $9F6C
	.label VIA1_IFR     = $9F6D
	.label VIA1_IER     = $9F6E

	.label VIA1_PRA_NH  = $9F6F

	// VIA #2 registers

	.label __VIA2_BASE  = $9F70  // base address of the chip

	.label VIA2_PRB     = $9F70
	.label VIA2_PRA     = $9F71
	.label VIA2_DDRB    = $9F72
	.label VIA2_DDRA    = $9F73

	.label VIA2_T1C_L   = $9F74
	.label VIA2_T1C_H   = $9F75
	.label VIA2_T1L_L   = $9F76
	.label VIA2_T1L_H   = $9F77
	.label VIA2_T2C_L   = $9F78
	.label VIA2_T2C_H   = $9F79

	.label VIA2_SR      = $9F7A
	.label VIA2_ACR     = $9F7B
	.label VIA2_PCR     = $9F7C
	.label VIA2_IFR     = $9F7D
	.label VIA2_IER     = $9F7E

	.label VIA2_PRA_NH  = $9F7F

#endif
