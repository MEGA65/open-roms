
//
// Names of hardware registers - names from C64 Programmer's Reference Guide, sometimes slightly modified
//


#if CONFIG_PLATFORM_COMMODORE_64

	// CPU memory registers

	.label CPU_D6510    = $00
	.label CPU_R6510    = $01

	// VIC-II registers

	.label __VIC_BASE   = $D000  // base address of the chip

	.label VIC_SP0X     = $D000
	.label VIC_SP0Y     = $D001
	.label VIC_SP1X     = $D002
	.label VIC_SP1Y     = $D003
	.label VIC_SP2X     = $D004
	.label VIC_SP2Y     = $D005
	.label VIC_SP3X     = $D006
	.label VIC_SP3Y     = $D007
	.label VIC_SP4X     = $D008
	.label VIC_SP4Y     = $D009
	.label VIC_SP5X     = $D00A
	.label VIC_SP5Y     = $D00B
	.label VIC_SP6X     = $D00C
	.label VIC_SP6Y     = $D00D
	.label VIC_SP7X     = $D00E
	.label VIC_SP7Y     = $D00F

	.label VIC_MSIGX    = $D010
	.label VIC_SCROLY   = $D011
	.label VIC_RASTER   = $D012
	.label VIC_LPENX    = $D013
	.label VIC_LPENY    = $D014
	.label VIC_SPENA    = $D015
	.label VIC_SCROLX   = $D016
	.label VIC_YXPAND   = $D017
	.label VIC_YMCSB    = $D018
	.label VIC_IRQ      = $D019
	.label VIC_IRQMSK   = $D01A
	.label VIC_SPBGPR   = $D01B
	.label VIC_SPMC     = $D01C
	.label VIC_XXPAND   = $D01D
	.label VIC_SPSPCL   = $D01E
	.label VIC_SPBGCL   = $D01F

	.label VIC_EXTCOL   = $D020
	.label VIC_BGCOL0   = $D021
	.label VIC_BGCOL1   = $D022
	.label VIC_BGCOL2   = $D023
	.label VIC_BGCOL3   = $D024
	.label VIC_SPMC0    = $D025
	.label VIC_SPMC1    = $D026
	.label VIC_SP0COL   = $D027
	.label VIC_SP1COL   = $D028
	.label VIC_SP2COL   = $D029
	.label VIC_SP3COL   = $D02A
	.label VIC_SP4COL   = $D02B
	.label VIC_SP5COL   = $D02C
	.label VIC_SP6COL   = $D02D
	.label VIC_SP7COL   = $D02E

#if !CONFIG_MB_MEGA_65 && !CONFIG_MB_ULTIMATE_64

	.label VIC_XSCAN    = $D02F // C128 only
	.label VIC_CLKRATE  = $D030 // C128 only

#endif

#if CONFIG_MB_MEGA_65

	.label VIC_KEY      = $D02F
	.label VIC_XPOS     = $D050

#endif

	// SID registers

	.label __SID_BASE   = $D400  // base address of the chip

#if CONFIG_MB_MEGA_65

	.label __SID_R1_OFFSET = $00 // right SID 1, $D400
	.label __SID_R2_OFFSET = $20 // right SID 2, $D420
	.label __SID_L1_OFFSET = $40 // left  SID 1, $D440
	.label __SID_L2_OFFSET = $60 // left  SID 2, $D460

#endif

	.label SID_FRELO1   = $D400
	.label SID_FREHI1   = $D401
	.label SID_PWLO1    = $D402
	.label SID_PWHI1    = $D403
	.label SID_VCREG1   = $D404
	.label SID_ATDCY1   = $D405
	.label SID_SUREL1   = $D406

	.label SID_FRELO2   = $D407
	.label SID_FREHI2   = $D408
	.label SID_PWLO2    = $D409
	.label SID_PWHI2    = $D40A
	.label SID_VCREG2   = $D40B
	.label SID_ATDCY2   = $D40C
	.label SID_SUREL2   = $D40D

	.label SID_FRELO3   = $D40E
	.label SID_FREHI3   = $D40F
	.label SID_PWLO3    = $D410
	.label SID_PWHI3    = $D411
	.label SID_VCREG3   = $D412
	.label SID_ATDCY3   = $D413
	.label SID_SUREL3   = $D414

	.label SID_CUTLO    = $D415
	.label SID_CUTHI    = $D416
	.label SID_RESON    = $D417
	.label SID_SIGVOL   = $D418
	.label SID_POTX     = $D419
	.label SID_POTY     = $D41A
	.label SID_RANDOM   = $D41B
	.label SID_ENV3     = $D41C

	// CIA #1 registers

	.label __CIA1_BASE  = $DC00  // base address of the chip

	.label CIA1_PRA     = $DC00
	.label CIA1_PRB     = $DC01
	.label CIA1_DDRA    = $DC02
	.label CIA1_DDRB    = $DC03

	.label CIA1_TIMALO  = $DC04
	.label CIA1_TIMAHI  = $DC05
	.label CIA1_TIMBLO  = $DC06
	.label CIA1_TIMBHI  = $DC07

	.label CIA1_TODTEN  = $DC08
	.label CIA1_TODSEC  = $DC09
	.label CIA1_TODMIN  = $DC0A
	.label CIA1_TODHRS  = $DC0B

	.label CIA1_SDR     = $DC0C
	.label CIA1_ICR     = $DC0D
	.label CIA1_CRA     = $DC0E
	.label CIA1_CRB     = $DC0F

	// CIA #2 registers

	.label __CIA2_BASE  = $DD00  // base address of the chip

	.label CIA2_PRA     = $DD00  // VIC bank switching and IEC port
	.label CIA2_PRB     = $DD01
	.label CIA2_DDRA    = $DD02
	.label CIA2_DDRB    = $DD03

	.label CIA2_TIMALO  = $DD04
	.label CIA2_TIMAHI  = $DD05
	.label CIA2_TIMBLO  = $DD06
	.label CIA2_TIMBHI  = $DD07

	.label CIA2_TODTEN  = $DD08
	.label CIA2_TODSEC  = $DD09
	.label CIA2_TODMIN  = $DD0A
	.label CIA2_TODHRS  = $DD0B

	.label CIA2_SDR     = $DD0C
	.label CIA2_ICR     = $DD0D
	.label CIA2_CRA     = $DD0E
	.label CIA2_CRB     = $DD0F

	// CIA #2 helper bits - IEC bus
	
	.const BIT_CIA2_PRA_ATN_OUT  = $08  // 1 - low (pulled), 0 - high (released)
	.const BIT_CIA2_PRA_CLK_OUT  = $10  // 1 - low (pulled), 0 - high (released)
	.const BIT_CIA2_PRA_DAT_OUT  = $20  // 1 - low (pulled), 0 - high (released)
	.const BIT_CIA2_PRA_CLK_IN   = $40  // 0 - low (pulled), 1 - high (released)
	.const BIT_CIA2_PRA_DAT_IN   = $80  // 0 - low (pulled), 1 - high (released)

#if CONFIG_MB_MEGA_65

	.const C65_EXTKEYS_PR  = $D607
	.const C65_EXTKEYS_DDR = $D608

	.const M65_BADL_SLI    = $D710

#endif


#endif
